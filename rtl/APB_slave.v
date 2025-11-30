
module APB_slave (input PCLK,PRESET_n,PWRITE_i,PSEL_i,PENABLE_i,ss_i,tip_i,recieve_data_i,
                  input [2:0]PADDR_i,
                  input [7:0]PWDATA_i,miso_data_i,
                  output reg[7:0]PRDATA_o,
                  output mstr_o,cpol_o,cpha_o,lsbfe_o,spiswai,
                  output [2:0]sppr_o,spr_o,
                  output reg spi_interrupt_request_o,
                  output PREADY_o,PSLVRR_o,
                  output reg send_data_o,
                  output reg[7:0] mosi_data_o,
                  output reg [1:0]spi_mode_o);


reg [7:0] SPI_CR1;
reg [7:0] SPI_CR2;
reg [7:0] SPI_BR;
reg [7:0] SPI_S


wire sptie,spe,spie,ssoe;
wire modfen;
wire modf,spif,sptef;

wire wr_en,rd_en;


parameter spi_run=2'b00,
          spi_wait=2'b01,
          spi_stop=2'b10;


parameter idle=2'b00,
          setup=2'b01,
          enable=2'b10;


reg [1:0]state,next_state;
reg [1:0]state1,next_state1;

wire [7:0]spi_cr2_mask = 8'b00011011;
wire [7:0]spi_br_mask  = 8'b01110111;


assign lsbfe_o=SPI_CR1[0];
assign ssoe=SPI_CR1[1];
assign cpha_o=SPI_CR1[2];
assign cpol_o=SPI_CR1[3];
assign mstr_o=SPI_CR1[4];
assign sptie=SPI_CR1[5];
assign spe=SPI_CR1[6];
assign spie=SPI_CR1[7];


assign spiswai=SPI_CR2[1];
assign modfen=SPI_CR2[4];

assign sppr_o=SPI_BR[2:0];
assign spr_o=SPI_BR[6:4];

assign spif=(SPI_DR==8'b0)?1'b1:1'b0;
assign sptef=(SPI_DR!=0)?1'b1:1'b0;
assign modf=(!ss_i && mstr_o && modfen && ssoe)?1'b1:1'b0;




always @ (posedge PCLK or negedge PRESET_n)begin

if (!PRESET_n) state=spi_run;

else state<=next_state;


end

always @ (*) begin

case(next_state)

spi_run : if (!spe) next_state=spi_wait;
          else next_state=spi_run;

spi_wait : if (spiswai) next_state=spi_stop;
           else if (!spe) next_state=spi_wait;
           else next_state=spi_run;

spi_stop : if (!spiswai) next_state=spi_wait;
           else if (spe) next_state=spi_run;
           

default : next_state=spi_run;

endcase
end


always @(*) begin

if (!PRESET_n) spi_mode_o=0;

else spi_mode_o=state;

end


always @ (posedge PCLK or negedge PRESET_n)begin

if (!PRESET_n) state1=idle;

else state1<=next_state1;


end

always @ (*) begin

case(next_state1)

idle : if (PSEL_i && !PENABLE_i) next_state1=setup;
       else next_state1=idle;

setup : if (PSEL_i && PENABLE_i) next_state1=enable;
        else next_state1=spi_run;

enable : if (PSEL_i) next_state1=setup;
         else  next_state1=idle;
           

default : next_state1=spi_run;
endcase
end

assign  PREADY_o=(state1==enable);
assign  PSLVRR_o=(state==enable && !tip_i);
assign wr_en=(state1==enable && PWRITE_i);
assign  rd_en=(state1==enable && !PWRITE_i);


//spi_cr1
always @ (posedge PCLK or negedge PRESET_n)begin

if (!PRESET_n) SPI_CR1<=8'b00000100;

else if (PADDR_i==3'b000) begin

    if (wr_en) SPI_CR1<=PWDATA_i ;

    else SPI_CR1<=SPI_CR1;

end 

else SPI_CR1<=SPI_CR1;


end

//spi_cr2
always @ (posedge PCLK or negedge PRESET_n)begin

if (!PRESET_n) SPI_CR2<=8'b00000000;

else if (PADDR_i==3'b001) begin

    if (wr_en)SPI_CR2<=PWDATA_i & spi_cr2_mask ;
    
    else SPI_CR2<=SPI_CR2;

end 

else SPI_CR2<=SPI_CR2;


end

//spi_br
always @ (posedge PCLK or negedge PRESET_n)begin

if (!PRESET_n) SPI_BR<=0;

else if (PADDR_i==3'b010) begin

    if (wr_en)SPI_BR<=PWDATA_i & spi_br_mask ;
    
    else SPI_BR<=SPI_BR;

end 

else SPI_BR<=SPI_BR;

end

//spi_sr

always @ (posedge PCLK or negedge PRESET_n)begin

if (!PRESET_n) SPI_SR<=8'b00100000;

else begin
    if (PADDR_i==3'b010) SPI_SR<={spif,1'b0,sptef,modf,1'b0,1'b0,1'b0,1'b0};
    
    else SPI_SR<=SPI_SR;
end
end

//spi_dr

always @ (posedge PCLK or negedge PRESET_n)begin

	if(!PRESET_n) begin
		SPI_DR<=0;
		mosi_data_o<=0;
	end


else begin
   
    if (wr_en)begin 
        
        if (PADDR_i==3'b101) SPI_DR<=PWDATA_i; 

        else SPI_DR <= SPI_DR;

    end
    
    
    else if (SPI_DR==PWDATA_i && SPI_DR != miso_data_i && (spi_mode_o == spi_run || spi_mode_o== spi_wait))  
	begin
		SPI_DR <=0;
		mosi_data_o<=SPI_DR;
         end 
        else if ((spi_mode_o == spi_run || spi_mode_o==spi_wait) && recieve_data_i) 
        
                SPI_DR<=miso_data_i;
                    
    
    end
    

end
/*
always @ (posedge PCLK or negedge PRESET_n)begin

if(PRESET_n) mosi_data_o<=0;

else begin
    
    if (!wr_en)begin 
        
       if (SPI_DR==PWDATA_i && SPI_DR != miso_data_i && spi_mode_o == spi_run || spi_wait)  mosi_data_o <=SPI_DR;
        
       else begin
            
           if (spi_mode_o == spi_run || spi_wait && recieve_data_i) mosi_data_o<=SPI_DR;
        
           else mosi_data_o<=mosi_data_o;
                    
       end
    
    end
   
end

end

*/
always @ (posedge PCLK or negedge PRESET_n)begin
if (!PRESET_n) send_data_o<=0;

else if (SPI_DR==PWDATA_i && SPI_DR != miso_data_i && (spi_mode_o==spi_run ||spi_mode_o== spi_wait)) send_data_o<=1'b1;
        
else if ((spi_mode_o==spi_run || spi_mode_o==spi_wait) && recieve_data_i) send_data_o<=0;
            
else send_data_o <= 1'b0;

end

always @ (*) begin

if (rd_en)

case(PADDR_i)

3'b000 : PRDATA_o=SPI_CR1;

3'b001 : PRDATA_o=SPI_CR2;

3'b010 : PRDATA_o=SPI_BR;

3'b011 : PRDATA_o=SPI_SR;

3'b101 : PRDATA_o=SPI_DR;

default: PRDATA_o=SPI_DR;

endcase
else PRDATA_o=8'b0;


end


//interrupt

always @ (*)begin

spi_interrupt_request_o<=0;
if (!spie && !sptie) spi_interrupt_request_o<=0;

else if (spie && !sptie) begin 

    if (spif || modf)spi_interrupt_request_o<=1;

end

else if (sptie && spie) spi_interrupt_request_o<=sptef;

else if (spif || modf || sptef) spi_interrupt_request_o<=1;

else spi_interrupt_request_o<=spi_interrupt_request_o;

end


endmodule

