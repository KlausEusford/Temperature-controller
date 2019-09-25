module clk_1ms(clk,rst,CP);
input clk,rst;
output reg CP;

reg [27:0]count1ms;				//除了T1不一样，其他和count1s一模一样

parameter  T1=28'd11999;      //加到11999就等于1ms 因为FPGA板的晶振是24M，12000是24M/2的一千分之一，因此是1ms

always @(posedge clk or negedge rst)
 if (!rst)
	     count1ms<=28'd0; 
	else  if (count1ms==T1)
				begin
				CP<=~CP;
				count1ms<=28'd0;
				end
			else  count1ms<=count1ms+28'b1; 	  
endmodule								