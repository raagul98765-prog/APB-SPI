`timescale 1ns/1ps
module top_module_tb();

reg PCLK,PRESET_n,PWRITE_i,PSEL_i,PENABLE_i;
reg [2:0] PADDR_i;
reg [7:0] PWDATA_i;
reg miso_i;
wire ss_o,sclk_o,spi_interrupt_request_o,mosi_o;
wire [7:0] PRDATA_o;
wire PREADY_o,PSLVERR_o;

top_module uut (PCLK,PRESET_n,PWRITE_i,PSEL_i,PENABLE_i,PADDR_i,PWDATA_i,miso_i,ss_o,sclk_o,spi_interrupt_request_o,mosi_o,PRDATA_o,PREADY_o,PSLVERR_o);


always #5 PCLK=~PCLK;


task initialize;begin

PCLK=0;PRESET_n=1;PWRITE_i=0;PSEL_i=0;PENABLE_i=0;PADDR_i=0;PWDATA_i=0;miso_i=0;
@(negedge PCLK);


end
endtask

task reset;begin
PRESET_n=0;
@(negedge PCLK);
PRESET_n=1;


end
endtask

task write (input [2:0]addr,input [7:0] data);begin
     PSEL_i=1'b1;
     PWRITE_i=1'b1;
     PENABLE_i=1'b0;
     PADDR_i=addr;
     PWDATA_i=data;
     @(negedge PCLK);
     PENABLE_i=1'b1;
     @(negedge PCLK);
     wait(PREADY_o);
     PENABLE_i=1'b0;
     @(negedge PCLK);

end
endtask

task read (input [2:0]addr);begin
     PSEL_i=1'b1;
     PWRITE_i=1'b0;
     PENABLE_i=1'b0;
     PADDR_i=addr;
     @(negedge PCLK);
     PENABLE_i=1'b1;
     @(negedge PCLK);
     wait(PREADY_o);
     PENABLE_i=1'b0;
     @(negedge PCLK);

end
endtask



initial begin

$dumpfile ("spi.vcd");
$dumpvars (0,top_module_tb);

initialize;
reset;
write (3'b000,8'b10110111);
read (3'b000);
write (3'b010,8'b10000100);
read (3'b010);
write (3'b101,8'b10101010);
miso_i=1;@(negedge PCLK);
wait (uut.recieve_data) read (3'b101);

#1000;



end



endmodule
