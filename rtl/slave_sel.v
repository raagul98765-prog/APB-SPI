module slave_sel(input PCLK,PRESET_n,mstr_i,spiswai_i,send_data_i,
                 input [1:0]spi_mode_i,
                 input [11:0]baudRateDivisor,
                 output reg recieve_data_o,ss_o,
		 output tip_o);

reg [15:0]count_s;
reg rcv_s ;
wire [15:0]target_s;
assign tip_o=~ss_o;
assign target_s= 16 * (baudRateDivisor/2);

always @(posedge PCLK or negedge PRESET_n)begin

if (~PRESET_n)begin
    count_s<=16'hffff;
    ss_o <=1;
    rcv_s<= 0;
end

else if ((spi_mode_i == 2'b00 || spi_mode_i == 2'b01) && ~spiswai_i && mstr_i)
begin
    if (send_data_i) 
    begin
           ss_o <= 0; // act as slave 
           rcv_s<=0;
		count_s<=0;
    end

    else if (count_s<=target_s-1)
    begin
           //ss_o<=0;
           //rcv_s<=0;
           count_s<=count_s+1;
         if(count_s == target_s-1)
           rcv_s<=1'b1; 
           

    end
    

    else 
    begin
    ss_o<=1;
    rcv_s<=0;
    count_s<=16'hffff;
    end

end

else  begin
     ss_o<=1;
     rcv_s<=0;
     count_s<=16'hffff;
         
end
end


always @(posedge PCLK or negedge PRESET_n)
  begin
   if (~PRESET_n) 
	   recieve_data_o<=0;
  else 
	  recieve_data_o <= rcv_s;


end
endmodule
