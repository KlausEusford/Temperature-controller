module clk_1us(clk,rst,CP);
input clk,rst;
output reg CP;

reg [7:0]count1us;

parameter  T1=7'd11;           				
always @(posedge clk or negedge rst)
 if (!rst)											
       begin
	     count1us<=7'd0;							
		 end 			
	else  if (count1us==T1)						
				begin
				CP<=~CP;								
				count1us<=7'd0;					
				end
			else  									
			   begin
			   count1us<=count1us+7'b1;		
 			end			
endmodule											