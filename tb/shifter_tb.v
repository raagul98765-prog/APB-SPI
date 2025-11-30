
module shifter_tb();
reg PCLK,PRESET_i,ss_i,send_data_i,lsbfe_i,cpha_i,cpol_i,miso_recieve_sclk_i,miso_recieve_sclk0_i,mosi_send_sclk_i,mosi_send_sclk0_i;
reg [7:0]data_mosi_i;
reg miso_i,recieve_data_i;
wire mosi_o;
wire [7:0] data_miso_o;

shifter uut  (PCLK,PRESET_i,ss_i,send_data_i,lsbfe_i,cpha_i,cpol_i,miso_recieve_sclk_i,miso_recieve_sclk0_i,mosi_send_sclk_i,mosi_send_sclk0_i,data_mosi_i,miso_i,recieve_data_i,mosi_o,data_miso_o);

always #5 PCLK=~PCLK;


task initialize();begin
PCLK=0;PRESET_i=1;ss_i=0;send_data_i=0;lsbfe_i=0;cpha_i=0;cpol_i=0;miso_recieve_sclk_i=0;miso_recieve_sclk0_i=0;mosi_send_sclk_i=0;mosi_send_sclk0_i=0;data_mosi_i=0;miso_i=0;recieve_data_i=0;
#10;
end
endtask

task reset();begin
PRESET_i=0;
@(negedge PCLK);
PRESET_i=1;
end
endtask

task pol_pha(input a,input b);begin
cpol_i=a;
cpha_i=b;
end
endtask

task lsb(input a);begin
lsbfe_i=a;
end
endtask

task send_recieve(input a,input b,input c,input d);begin

miso_recieve_sclk_i=a;
miso_recieve_sclk0_i=b;
mosi_send_sclk_i=c;
mosi_send_sclk0_i=d;

end
endtask

task slave_mstr(input a,input b);begin
send_data_i=a;
recieve_data_i=b;
end
endtask 

task delay();begin
#10;
end
endtask

task mosi_in (input [7:0]a); begin
data_mosi_i= a;
end
endtask

task miso_in (input a);begin
miso_i= a;
end
endtask

initial begin

$dumpfile("shifter.vcd");
$dumpvars(0,shifter_tb);

initialize;reset;
pol_pha(0,0);
send_recieve(1,0,1,0);
slave_mstr(1,1);
mosi_in(8'b10110110);
miso_in(1);#10;
miso_in(0);#10;
miso_in(1);#10;
miso_in(0);#10;
miso_in(1);#10;
miso_in(0);#10;
miso_in(1);#10;
miso_in(0);#10;

end
endmodule
