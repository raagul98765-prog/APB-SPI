module baud_gen_tb();
reg PCLK,PRESET_n,spiswai_i,cpol_i,cpha_i,ss_i;
reg [1:0]spi_mode_i;
reg [2:0]sppr_i;
reg [2:0]spr_i;
wire sclk_o,miso_recieve_sclk_o,miso_recieve_sclk0_o,mosi_send_sclk_o,mosi_send_sclk0_o;
wire [11:0]BaudRateDivisor_o;


baud_gen uut (PCLK,PRESET_n,spiswai_i,cpol_i,cpha_i,ss_i,spi_mode_i,sppr_i,spr_i,sclk_o,miso_recieve_sclk_o,miso_recieve_sclk0_o,mosi_send_sclk_o,mosi_send_sclk0_o,BaudRateDivisor_o);

always #5 PCLK=~PCLK;

initial begin

$dumpfile("baud.vcd");
$dumpvars(0,baud_gen_tb);

PCLK=1;PRESET_n=1;spiswai_i=0;cpol_i=0;cpha_i=0;ss_i=0;spi_mode_i=0;sppr_i=0;spr_i=0;#10;
PRESET_n=0;#10;
PRESET_n=1;
spi_mode_i=2'b00;sppr_i=3'b001;spr_i=3'b000;




end

endmodule
