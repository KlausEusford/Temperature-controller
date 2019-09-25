module clk_1s(clk,rst,CP);
input clk,rst;
output reg CP;

reg [27:0]count1s;

parameter  T1=28'd11999999;

always @(posedge clk or negedge rst)
 if (!rst)       					
	     count1s<=28'd0; 		
	else  if (count1s==T1)		
				begin
				CP<=~CP;          
				count1s<=28'd0;	
				end
			else  count1s<=count1s+28'b1; 	
endmodule
