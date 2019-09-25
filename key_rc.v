module key_rc(clk,key1,key2,key3,key1_out,key2_out,key3_out);
input		clk;				
input		key1;
input		key2;
input		key3;
output	reg	key1_out;
output	reg	key2_out;
output	reg	key3_out;

initial key1_out=1'b0;
initial key2_out=1'b0;
initial key3_out=1'b0;

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

always @(posedge clk)
	begin
		case(key_state)
		 state_0 :          
				 begin
				 if(key1&key2&key3)
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
					if(key1&key2&key3)   //防抖
						key_state<=state_0;
					 else					 
						key_state<=state_3;
				 end

		 state_3 :
				 begin
					if		 ((!key1)&key2&key3)
						key_value<=2'd1;
					else if(key1&(!key2)&key3)
						key_value<=2'd2;
					else if(key1&key2&(!key3))
						key_value<=2'd3;
						
					key_state<=state_4;
				 end
		 state_4 :					
				begin
					if(!(key1&key2&key3)) 
							key_state<=state_4;
					else					 
							key_state<=state_5;
				end
		state_5 :
				 begin
					if		 (1==key_value)
						key1_out<=1'b1;
					else if(2==key_value)
						key2_out<=1'b1;
					else if(3==key_value)
						key3_out<=1'b1;
						
					key_value<=2'd0;			
					key_state<=state_6;
				 end
		state_6 :
				 begin
					key_state<=state_7;		
				 end
		state_7 :

				 begin
					if(key_count > 2)
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
						key1_out<=1'b0;
						key2_out<=1'b0;
						key3_out<=1'b0;
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