
module top_module (input PCLK,PRESET_n,PWRITE_i,PSEL_i,PENABLE_i,
                   input [2:0] PADDR_i,
                   input [7:0] PWDATA_i,
                   input miso_i,
                   output ss_o,sclk_o,spi_interrupt_request_o,mosi_o,
                   output [7:0] PRDATA_o,
                   output PREADY_o,PSLVERR_o);


wire  tip,recieve_data;// slave_sel to APB (1,2,3) slave_sel to baud(1) slave_sel to shifter(1,3)

wire [7:0]miso_data;//shifter to APB
                
wire cpol,cpha,spiswai;//APB to baud (1,2,3) APB to slave_sel(3) APB to shifter(1,2)
wire [1:0]spi_mode;//APB to baud_gen,slave_sel
wire mstr;//APB to slave_sel
wire lsbfe;//APB to shifter
wire [2:0]sppr,spr;//APB to baud
wire send_data;//APB to shifter,slave_sel
wire [7:0] mosi_data;//APB to shifter


wire miso_recieve_sclk,miso_recieve_sclk0,mosi_send_sclk_o,mosi_send_sclk0;//  baud to shifter
wire[11:0] baudRateDivisor;//baud to slave_sel



baud_gen b1(PCLK,PRESET_n,spiswai,cpol,cpha,ss_o,spi_mode,sppr,spr,sclk_o,miso_recieve_sclk,miso_recieve_sclk0,mosi_send_sclk,mosi_send_sclk0,baudRateDivisor);
slave_sel s1(PCLK,PRESET_n,mstr,spiswai,send_data,spi_mode,baudRateDivisor,recieve_data,ss_o,tip);
shifter s2(PCLK,PRESET_n,ss_o,send_data,lsbfe,cpha,cpol,miso_recieve_sclk,miso_recieve_sclk0,mosi_send_sclk,mosi_send_sclk0,mosi_data,miso_i,recieve_data,mosi_o,miso_data);
APB_slave s3(PCLK,PRESET_n,PWRITE_i,PSEL_i,PENABLE_i,ss_o,tip,recieve_data,PADDR_i,PWDATA_i,miso_data,PRDATA_o,mstr,cpol,cpha,lsbfe,spiswai,sppr,spr,spi_interrupt_request_o,PREADY_o,PSLVERR_o,send_data,mosi_data,spi_mode);



endmodule
