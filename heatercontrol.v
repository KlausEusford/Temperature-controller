module heatercontrol(clk,heater_open,high_len,heater_con);
input clk;
input heater_open;
input signed[15:0]high_len;
output reg heater_con;    
reg [15:0]point_now;
always @(posedge clk)	
begin
   if(heater_open==1) 
      begin
	       if(point_now<high_len)
				begin
		        point_now<=point_now+16'd1;
		        heater_con<=1;
				end
	       else if(point_now<16'd1010)
		        begin
                 heater_con<=0;
				     point_now<=point_now+16'd1;
              end	    
		    else
	           begin
	              heater_con<=1;
				     point_now<=16'd0;
				  end
      end
	else				
	   begin
			heater_con<=0;
	   end
end

endmodule 