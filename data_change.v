module	data_change(key1_in,key2_in,key3_in,data_warn,show_flag,flash_flag);
input	key1_in;
input	key2_in;
input	key3_in;
output	reg [11:0]data_warn;
output	reg show_flag;
output	reg	[2:0]flash_flag;
reg	change_flag;
initial data_warn=12'd200; 
initial	show_flag=1'b0;

always @(posedge key3_in &&(!key1_in))		
	begin
	show_flag<=~show_flag;
	end

always @(posedge key2_in)
	begin
	if(show_flag)					
		begin
		case(flash_flag)
		2'd0:						
				begin
					if(data_warn%10==9)
						data_warn<=data_warn-12'd9;
					else
					data_warn<=data_warn+12'd1;		
				end	
			2'd1:
				begin
					if(data_warn/10%10==9)
						data_warn<=data_warn-12'd90;		
					else
					data_warn<=data_warn+12'd10;
				end			
			2'd2:
				begin
					if(data_warn/100==9)
						data_warn<=data_warn-12'd900;			
					else
					data_warn<=data_warn+12'd100;
				end
			endcase
		end
	end

always @(posedge key1_in&&(!key3_in))		
	begin
	if(show_flag)								
		begin
			begin
			if(flash_flag==2)
			flash_flag<=3'b0;
			else
			flash_flag<=flash_flag+3'd1;		
			end		
		end
	end

endmodule 