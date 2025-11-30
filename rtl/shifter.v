module shifter (input     PCLK,PRESET_n,ss_i,send_data_i,lsbfe_i,cpha_i,cpol_i,miso_recieve_sclk_i,miso_recieve_sclk0_i,mosi_send_sclk_i,mosi_send_sclk0_i,
                input [7:0]data_mosi_i,
                input miso_i,recieve_data_i,
                output reg mosi_o,
                output [7:0] data_miso_o);

reg [2:0]count1;
reg [2:0]count2;

reg [2:0]count3;
reg [2:0]count4;

reg [7:0]temp1;
reg [7:0]temp2;

always @(posedge PCLK or negedge PRESET_n)
begin
	if(!PRESET_n)
		temp1<=8'b0;
	else if(send_data_i)
		temp1<=data_mosi_i;
end

assign data_miso_o= recieve_data_i?temp2:8'b0;

//mosi
always @(posedge PCLK or negedge PRESET_n)begin

if (!PRESET_n)begin
count1<=3'd0;
count2<=3'd7;
mosi_o<=1'b0;
end

else if (!ss_i)begin
     
     if (!cpol_i && !cpha_i || cpol_i && cpha_i )begin
           
         if (lsbfe_i)begin
           
             if (count1<8)begin
             
                 if (mosi_send_sclk_i)begin
                    
                  //  temp1[count1]=data_mosi_i[count1];
                    mosi_o<=temp1[count1];
                    count1<=count1+1;
                    
                 end
                 
                 else count1<=count1;
                 
              end
           
          end
          
          else begin
             if (count2>=0)begin
             
                 if (mosi_send_sclk_i)begin
                    
                   // temp1[count2]=data_mosi_i[count2];
                    mosi_o<=temp1[count2];
                    count2<=count2-1;
                    
                 end
                 
                 else count2<=count2;
                 
              end
           
          end
          
        
     end
     
     else begin
           
         if (lsbfe_i)begin
           
             if (count1<8)begin
             
                 if (mosi_send_sclk0_i)begin
                    
                   // temp1[count1]=data_mosi_i[count1];
                    mosi_o<=temp1[count1];
                    count1<=count1+1;
                    
                 end
                 
                 else count1<=count1;
                 
              end
           
          end
          
          else begin
             if (count2>=0)begin
             
                 if (mosi_send_sclk0_i)begin
                    
                   // temp1[count1]=data_mosi_i[count1];
                    mosi_o<=temp1[count1];
                    count2<=count2-1;
                    
                 end
                 
                 else count2<=count2;
                 
              end
           
          end
          
        
     end

end  
  
end

//miso
always @(posedge PCLK or negedge PRESET_n)begin

if (!PRESET_n)begin
count3<=3'd0;
count4<=3'd7;
temp2<=8'b0;
end

else if (!ss_i)begin
     
     if (!cpol_i && !cpha_i || cpol_i && cpha_i )begin
           
         if (lsbfe_i)begin
           
             if (count1<8)begin
                    if (miso_recieve_sclk_i)begin
                    temp2[count3]<=miso_i;
                 //   data_miso_o[count3]<=temp2[count3];
                    count3<=count3+1;
                    
                 end
                 
                 
                 
                 else count3<=count3;
                 
              end
           
          end
          
          else begin
             if (count2>=0)begin
             
                 if (miso_recieve_sclk_i)begin
                    
                  //  temp2=miso_i;
                    temp2[count4]<=miso_i;
                    count4<=count4-1;
                    
                 end
                 
                 else count4<=count4;
                 
              end
           
          end
          
        
     end
     
     else begin
           
         if (lsbfe_i)begin
           
             if (count1<8)begin
             
                 if (miso_recieve_sclk0_i)begin
                  
                    temp2[count3]<=miso_i;
                  //  data_miso_o[count3]<=temp2[count3];
                    count3<=count3+1;
                    
                  end
                 
                  else count3<=count3;
                 
             end
           
          end

          
          else begin
             if (count2>=0)begin
             
                 if (miso_recieve_sclk0_i)begin
                    
                 //  temp2=miso_i;
                    temp2[count4]<=miso_i;
                    count4<=count4-1;
                    
                 end
                 
                 else count4<=count4;
                 
              end
           
          end
          
        
     end

end  
  
end

endmodule






















