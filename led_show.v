module led_show(flash_flag,show_flag,clk_1ms,cs,data_warn,data_show,data,sta_p1,sta_p2,p_data,i_data,d_data,pid_show,pid_lock);
input		clk_1ms;			
input		show_flag;		
input		[2:0]flash_flag;
input		[11:0]data_show;			
input		[11:0]data_warn;	
input    [9:0]p_data;
input    [9:0]i_data;
input    [9:0]d_data;
input    [1:0]pid_show;		
output	reg[3:0]cs;			
output	reg[7:0]data;		
output   reg[7:0]sta_p1;
output   reg[7:0]sta_p2;
output   reg pid_lock;


parameter	SEG_NUM0	=8'hC0,		
				SEG_NUM1	=8'hF9,		
				SEG_NUM2	=8'hA4,	
				SEG_NUM3	=8'hB0,	
				SEG_NUM4	=8'h99,	
				SEG_NUM5	=8'h92,	
				SEG_NUM6	=8'h82,	
				SEG_NUM7	=8'hF8,	
				SEG_NUM8	=8'h80,	
				SEG_NUM9	=8'h90,	
				SEG_DU   =8'hFF,	
				SEG_C    =8'hFF,	
				SEG_P    =8'h8C,                                                                                          
				SEG_I    =8'hCF,  
				SEG_D    =8'hA1,  
				SEG_NULL =8'hFF;			
reg			[2:0]cs_count;			
reg			[3:0]data_in;			
reg			[9:0]flash_count;		
reg			flash_single_flag;
reg         [9:0]pid_count; 
reg         [3:0]sta_p1_in;
reg         [3:0]sta_p2_in;
initial pid_lock=0;
always@(posedge clk_1ms)			
	begin
	if(pid_show==2'b00 && pid_lock==1'b0)
		  begin
				if(!show_flag)		
					begin
						if(cs_count==2)
							cs_count<=0;
						else
							cs_count<=cs_count+8'd1;
						if(cs_count==1)
							data<=data+8'h80;
						case(cs_count[2:0])
						3'd0:
							begin
							cs[3:0]=8'b0111;						
							data_in[3:0]=data_show/100;		
							if(data_in==0) 
							begin
								data_in=8'd10;
							end
							end 
						3'd1:			
							begin
							cs[3:0]=8'b1011;											
							data_in[3:0]=data_show/10%10;	
							end 
						3'd2:
							begin	
							cs[3:0]=8'b1101;						
							data_in[3:0]=data_show%10;		
							end
						default:data_in[3:0]=0;
						endcase
					
						case(data_in[3:0])
							8'd0:data[7:0]=SEG_NUM0;
							8'd1:data[7:0]=SEG_NUM1;
							8'd2:data[7:0]=SEG_NUM2;
							8'd3:data[7:0]=SEG_NUM3;
							8'd4:data[7:0]=SEG_NUM4;
							8'd5:data[7:0]=SEG_NUM5;
							8'd6:data[7:0]=SEG_NUM6;
							8'd7:data[7:0]=SEG_NUM7;
							8'd8:data[7:0]=SEG_NUM8;
							8'd9:data[7:0]=SEG_NUM9;
							8'd10:data[7:0]=SEG_NULL;
							default:data[7:0]=0;
						endcase
					end
				
				else					
					begin
						if(flash_count==10'd500)  
							begin
							flash_count<=0;
							flash_single_flag<=~flash_single_flag;
							end
						else
							flash_count<=flash_count+1'b1;
							
							
						case(cs_count[2:0])
						3'd0:
							begin
							if((flash_flag==2)&&(!flash_single_flag))
							cs[3:0]=8'b1111;
							else
							cs[3:0]=8'b0111;						
							data_in[3:0]=data_warn/100;		
							if(data_in==0) 
							begin
							   data_in=8'd10;
							end
							end 
						3'd1:			
							begin
							if((flash_flag==1)&&(!flash_single_flag))
							cs[3:0]=8'b1111;
							else
							cs[3:0]=8'b1011;												
							data_in[3:0]=data_warn/10%10;	
							end 
						3'd2:
							begin
							if((flash_flag==0)&&(!flash_single_flag))
							cs[3:0]=8'b1111;
							else
							cs[3:0]=8'b1101;						
							data_in[3:0]=data_warn%10;		
							end
						default:data_in[3:0]=0;
						endcase
					
						case(data_in[3:0])
							8'd0:data[7:0]=SEG_NUM0;
							8'd1:data[7:0]=SEG_NUM1;
							8'd2:data[7:0]=SEG_NUM2;
							8'd3:data[7:0]=SEG_NUM3;
							8'd4:data[7:0]=SEG_NUM4;
							8'd5:data[7:0]=SEG_NUM5;
							8'd6:data[7:0]=SEG_NUM6;
							8'd7:data[7:0]=SEG_NUM7;
							8'd8:data[7:0]=SEG_NUM8;
							8'd9:data[7:0]=SEG_NUM9;
							8'd10:data[7:0]=SEG_NULL;
							default:data[7:0]=0;
						endcase
						if(cs_count==2)
							cs_count<=0;
						else
							cs_count<=cs_count+8'd1;
				 		if(cs_count==1)
							data<=data+8'h80;		
					end
					sta_p1[7:0]=SEG_DU;
					sta_p2[7:0]=SEG_C;
			end
	else 
		  begin
		   case(pid_show[1:0])
		   2'd1:
		      begin
		         cs[3:0]<=8'b0111;					
				   data[7:0]<=SEG_P;
				   sta_p1_in[3:0]<=p_data/10;
				   sta_p2_in[3:0]<=p_data%10;
		      end
		   2'd2:
		      begin
		         cs[3:0]<=8'b0111;					
				   data[7:0]<=SEG_I;
				   sta_p1_in[3:0]<=i_data/10;
				   sta_p2_in[3:0]<=i_data%10;
		      end
		   2'd3:
		      begin
		         cs[3:0]<=8'b0111;					
				   data[7:0]<=SEG_D;
				   sta_p1_in[3:0]<=d_data/10;
				   sta_p2_in[3:0]<=d_data%10;
		      end			
		   endcase
			case(sta_p1_in[3:0])
					8'd0:sta_p1[7:0]=SEG_NUM0;
					8'd1:sta_p1[7:0]=SEG_NUM1;
					8'd2:sta_p1[7:0]=SEG_NUM2;
					8'd3:sta_p1[7:0]=SEG_NUM3;
					8'd4:sta_p1[7:0]=SEG_NUM4;
					8'd5:sta_p1[7:0]=SEG_NUM5;
					8'd6:sta_p1[7:0]=SEG_NUM6;
					8'd7:sta_p1[7:0]=SEG_NUM7;
					8'd8:sta_p1[7:0]=SEG_NUM8;
					8'd9:sta_p1[7:0]=SEG_NUM9;
					default:sta_p1[7:0]=0;
				endcase
			case(sta_p2_in[3:0])
					8'd0:sta_p2[7:0]=SEG_NUM0;
					8'd1:sta_p2[7:0]=SEG_NUM1;
					8'd2:sta_p2[7:0]=SEG_NUM2;
					8'd3:sta_p2[7:0]=SEG_NUM3;
					8'd4:sta_p2[7:0]=SEG_NUM4;
					8'd5:sta_p2[7:0]=SEG_NUM5;
					8'd6:sta_p2[7:0]=SEG_NUM6;
					8'd7:sta_p2[7:0]=SEG_NUM7;
					8'd8:sta_p2[7:0]=SEG_NUM8;
					8'd9:sta_p2[7:0]=SEG_NUM9;
					default:sta_p2[7:0]=0;
				endcase
			if(pid_count==10'd1000)   
		   	begin
				   pid_count<=0;
					pid_lock<=0;
				end
			else
			   begin
					pid_count<=pid_count+1'b1;
					pid_lock<=1;
				end
		end	
	end		
endmodule
