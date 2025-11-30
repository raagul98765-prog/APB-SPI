module APB_slave_tb();
reg PCLK,PRESET_n,PWRITE_i,PSEL_i,PENABLE_i,ss_i,recieve_data_i,tip_i,recieve_data_o;
reg [2:0]PAADR_i;
reg [7:0]PWDATA_i,miso_data_i;
wire [7:0]PRDATA_o;
wire mstr_o,cpol_o,cpha_o,lsbfe_o,spiswai;
wire [2:0]sppr_o,spr_o;
wire spi_interrupt_request_o,PREADY_o,PSLVRR_o,send_data_o;
wire [7:0] mosi_data_o;
wire spi_mode_o;


AP_slave uut (PCLK,PRESET_n,PWRITE_i,PSEL_i,PENABLE_i,ss_i,recieve_data_i,tip_i,recieve_data_o,PAADR_i,PWDATA_i,miso_data_i,PRDATA_o,mstr_o,cpol_o,cpha_o,lsbfe_o,spiswai,sppr_o,spr_o, spi_interrupt_request_o,PREADY_o,PSLVRR_o,send_data_o,mosi_data_o,spi_mode_o);

always #5 PCLK=~PCLK;


task initialize ();begin
PCLK=0;PRESET_n=1;PWRITE_i=0;PSEL_i=0;PENABLE_i=0;ss_i=1;recieve_data_i=0;tip_i=1;PAADR_i=0;PWDATA_i=0;miso_data_i=0;
delay;

end
endtask


task reset();begin
PRESET_n=0;delay;
PRESET_n=1;

end
endtask

task write(input wr);begin
PWRITE_i=wr;
end
endtask


task address(input [2:0]addr);begin
PADDR_i=addr;

end
endtask

task stimulus(input x,input y);begin
PSEL_i=x;
PENABLE=y;
end
endtask

task wr_data(input [7:0]wr);begin
PWDATA_i=wr;

end
endtask

task miso_data(input [7:0]data_in);begin
miso_data_i=data_in;

end
endtask

task tip(input tip_in);begin
tip_i=tip_in;
end
endtask

task ss(input ss_in);begin
ss_i=ss_in;
end
endtask

task recieve_data(input recieve_dat);begin
recieve_data_i=wr;
end
endtask

task delay();begin
#10;
end
endtask


initial begin
initialize;reset;



end

endmodule
