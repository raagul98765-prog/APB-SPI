module slave_sel_tb();
reg PCLK,PRESET_n,mstr_i,spiswai_i,send_data_i;
reg [1:0]spi_mode_i;
reg [11:0]baudRateDivisor;
wire recieve_data_o,ss_o;
wire tip_o;

slave_sel uut (PCLK,PRESET_n,mstr_i,spiswai_i,send_data_i,spi_mode_i,baudRateDivisor,recieve_data_o,ss_o,tip_o);

always #5 PLCK=~PCLk; 

task initialize();begin
PCLK=0;PRESET_n=1;mstr_i=0;spiswai_i=0;send_data_i=0;spi_mode_i=0,baudRateDivisor=0;
@(negedge PCLK);
end

task reset();begin
PRESET_n=0;
@(negedge PCLK) PRESET_n=1;
end
endtask

task spi_mode (input [1:0]in);begin
spi_mode_i=in;
end
endtask


task data_transfer (input dat);begin
send_data_i=dat;
end
endtask

task baud (input [11:0]in);begin
baudRateDivisor=in;
end
endtask


initial begin
initialize;
reset;
spimode(0);data_transfer(1);baud(8);




end
endmodule








