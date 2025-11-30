
module baud_gen(input PCLK,PRESET_n,spiswai_i,cpol_i,cpha_i,ss_i,
                input  [1:0] spi_mode_i,
                input  [2:0] sppr_i,spr_i,
                output reg   sclk_o,miso_recieve_sclk_o,miso_recieve_sclk0_o,mosi_send_sclk_o,mosi_send_sclk0_o,     
                output [11:0] BaudRateDivisor_o);

    
    assign BaudRateDivisor_o = (sppr_i + 1) * (2 ** (spr_i + 1));
    wire [11:0] baud = BaudRateDivisor_o / 2;  

    reg [11:0] count ;

    always @(posedge PCLK or negedge PRESET_n) begin
        if (!PRESET_n) begin
            sclk_o <= cpol_i;
            count  <= 0;
        end
        else if (!ss_i) begin
            if ( (spi_mode_i == 2'b00) || (spi_mode_i == 2'b01 && !spiswai_i) ) begin
                if (count < (baud-1)) begin
                    count <= count + 1;
                end else begin
                    count  <= 0; 
                    sclk_o <= ~sclk_o;
                end
            end
        end
        else begin
           
            sclk_o <= cpol_i;
            count  <= 0;
        end
    end
 
    always @(posedge PCLK or negedge PRESET_n) begin
        if (!PRESET_n) begin
            miso_recieve_sclk_o   <= 1'b0;
            miso_recieve_sclk0_o  <= 1'b0;
            mosi_send_sclk_o      <= 1'b0;
            mosi_send_sclk0_o     <= 1'b0;
        end
        else begin
            
            miso_recieve_sclk_o   <= 1'b0;
            miso_recieve_sclk0_o  <= 1'b0;
            mosi_send_sclk_o      <= 1'b0;
            mosi_send_sclk0_o     <= 1'b0;

            if (!ss_i && ( (spi_mode_i == 2'b00) || (spi_mode_i == 2'b01 && !spiswai_i) )) begin
               
                 if (( (!cpha_i && !cpol_i) || ( cpha_i &&  cpol_i) )) begin
                         
                         if ((sclk_o==0 && count==( baud-2) )|| count<0) mosi_send_sclk_o <=1;
                         
                         else if (sclk_o==0 && count==(baud-1)) miso_recieve_sclk_o <=1;
                       
                 end
                 
                 else  begin
                         
                         if ((sclk_o==1 && count==(baud-2) )|| count==3'b110) mosi_send_sclk0_o <=1;
                         
                         else if (sclk_o==1 && count==(baud-1)) miso_recieve_sclk0_o <=1;
                       
                 end
            end
        end
    end
   /*  
   always @(posedge PCLK or negedge PRESET_n) begin

   if (!PRESET_n)begin
            miso_recieve_sclk_o   <= 1'b0;
            miso_recieve_sclk0_o  <= 1'b0;
            mosi_send_sclk_o      <= 1'b0;
            mosi_send_sclk0_o     <= 1'b0;
   end





   else if (!ss_i && ( (spi_mode_i == 2'b00) || (spi_mode_i == 2'b01 && !spiswai_i) )) begin
               
                 if (( (!cpha_i && !cpol_i) || ( cpha_i &&  cpol_i) )) begin

			               if (sclk_o==0 && count==(baud-2)) mosi_send_sclk_o <=1;

			               else mosi_send_sclk_o <=0;
                 end

		           else begin
                       if (sclk_o==1 && count==(baud-2)) mosi_send_sclk0_o<=1;

			              else mosi_send_sclk0_o <=0;
                 end

  end
  
  end

  always @(posedge PCLK or negedge PRESET_n) begin

   if (!PRESET_n)begin
            miso_recieve_sclk_o   <= 1'b0;
            miso_recieve_sclk0_o  <= 1'b0;
            mosi_send_sclk_o      <= 1'b0;
            mosi_send_sclk0_o     <= 1'b0;
   end

  else  if (!ss_i && ( (spi_mode_i == 2'b00) || (spi_mode_i == 2'b01 && !spiswai_i) )) begin
               
        if (( (!cpha_i && !cpol_i) || ( cpha_i &&  cpol_i) )) begin

			   if (sclk_o==0 && count==(baud-1)) miso_recieve_sclk_o <=1;

			   else miso_recieve_sclk_o <=0;
        end

		 else begin
          if (sclk_o==1 && count==(baud-1)) miso_recieve_sclk0_o <=1;

			 else miso_recieve_sclk0_o <=0;
			 
       end

  end
  
  end
*/

endmodule































