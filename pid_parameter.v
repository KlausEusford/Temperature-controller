module pid_parameter(clk,change_p,k_p,k_i,k_d,p_pa,i_pa,d_pa,pid_show);
input clk;
input change_p;
input k_p;
input k_i;
input k_d;
output reg [9:0]p_pa;
output reg [9:0]i_pa;
output reg [9:0]d_pa;
output reg [1:0]pid_show; 

initial p_pa=10'd70;				
initial i_pa=10'd10;
initial d_pa=10'd4;
initial pid_show=1'b0;

parameter state_0  = 0;
parameter state_1  = 1;
parameter state_2  = 2;
parameter state_3  = 3;
parameter state_4  = 4;
parameter state_5  = 5;
parameter state_6  = 6;
parameter state_7  = 7;
parameter state_8  = 8;
parameter state_9  = 9;

reg	[3:0]key_state;
reg	[7:0]key_count;
reg	[2:0]key_value;

initial key_state=0;

always @(posedge clk && (~change_p))
   begin
		case(key_state)
		 state_0 :          
				 begin
					 if(k_p&k_i&k_d)
						key_state<=state_0;
					 else					
						key_state<=state_1;
				 end 
		 state_1 :
				 begin
					if(key_count > 20)
						begin
						 key_count <= 0;
						 key_state <= state_2;
						end
					else
						begin
						 key_count <= key_count + 1'b1;
						 key_state <= state_1;
						end 
				 end 
		 state_2 :         
				 begin
					if(k_p&k_i&k_d) 
						key_state<=state_0;
					 else					 
						key_state<=state_3;
				 end

		 state_3 :
				 begin
					if		 ((!k_p)&k_i&k_d)
						key_value<=2'd1;
					else if(k_p&(!k_i)&k_d)
						key_value<=2'd2;	
					else if(k_p&k_i&(!k_d))
						key_value<=2'd3;
						
					key_state<=state_4;
				 end
		 state_4 :						 
				begin
					if(!(k_p&k_i&k_d)) 
							key_state<=state_4;
					else					
							key_state<=state_5;
				end
		state_5 :
				 begin
					case(key_value[2:0])
					1:begin
					   if(p_pa==99)
						begin
						   p_pa<=0;
						end
    					p_pa<=p_pa+1;
						pid_show<=1;
					end
					
					2:begin
					   if(i_pa==99)
						begin
						   i_pa<=0;
						end
				   	i_pa<=i_pa+1;
						pid_show<=2;
					end
					
					3:begin
					   if(d_pa==99)
						begin
						   d_pa<=0;
						end
						d_pa<=d_pa+1;
					   pid_show<=3;
					end
	            endcase				
					key_value<=2'd0;	
					key_state<=state_6;
				 end
		state_6 :
				 begin
					key_state<=state_7;
				 end
		state_7 :
				 begin
					if(key_count > 20)
						begin
						 key_count <= 0;
						 key_state <= state_8;
						end
					else
						begin
						 key_count <= key_count + 1'b1;
						 key_state <= state_7;
						end 
				end
		 state_8 :
				 begin
				   pid_show<=0;
					key_state<=state_9;
				 end	
		 state_9 :
				 begin
					key_state<=state_0;
				 end	
		default :
				 begin
					key_state<=state_0;
				 end 
		endcase
	end
endmodule 