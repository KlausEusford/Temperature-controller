module ds18b20_test(clk,icdata,data,Flag_CmdSET);
input clk;
inout reg icdata;		
output	reg [11:0]data;
output   reg Flag_CmdSET;
reg	[19:0]tempre_temp;
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
parameter state_10  = 10;
parameter state_11  = 11;
parameter state_12  = 12;
parameter state_13  = 13;
parameter state_14  = 14;
parameter state_15  = 15;
parameter state_16  = 16;
parameter state_17  = 17;
always@(posedge clk )
begin
	CmdSETDS18B20;									
end

reg Flag_Rst;         		
reg [4:0] Rststate;       
reg [10:0] CountRstStep;   

task Rst_DS18B20;				
	begin
	 case(Rststate)
	 state_0 :          
			 begin
			  Flag_Rst <= 0;       
			  icdata <= 1;       
			  CountRstStep <= 0;		  
			  Rststate <= state_1;
			 end 
	 state_1 :
			 begin
			  icdata <= 0;       
			  if(CountRstStep > 600)     
				  begin
					CountRstStep <= 0;    
					Rststate <= state_2;    
				    icdata <= 1;      
				  end 
			  else 
				  begin   
					CountRstStep <= CountRstStep + 1'b1; 
					Rststate <= state_1;   
				  end
			 end 
	 state_2 :         
			 begin
				  if(CountRstStep > 60)    
					  begin
						CountRstStep <= 0;    
						Rststate <= state_3;
					  end
				  else
					  begin
						CountRstStep <= CountRstStep +1'b1;
						Rststate <= state_2;   
					  end  
			 end
	 state_3 :
			 begin
			  icdata <= 1'bz;       
			  Rststate <= state_4;
			 end
	 state_4 :
			 begin
				  if(CountRstStep > 6) 
					  begin
						CountRstStep <= 0;   
						Rststate <= state_5;
					  end
				  else
					  begin
						CountRstStep <= CountRstStep +1'b1;
						Rststate <= state_4; 
					  end  
			 end
	 state_5 :
			 begin
				  if(icdata == 1'b0)     
						  begin
							CountRstStep <= 0;
							Rststate <= state_6;    
						  end
				  else
						begin
						CountRstStep <= 0;
						Rststate <= state_9;   
						end
						 
			 end
	 state_6 :
		begin
			if(CountRstStep == 240)			
				  begin
					CountRstStep <= 0;
					Rststate <= state_7;  
				  end
			  else
				  begin
					CountRstStep <= CountRstStep + 1'b1;
					Rststate <= state_6;  
				  end
		end
	 state_7 :
			 begin
			  if(icdata == 1'b1)
				  begin
					Rststate <= state_8;  
				  end
			  else
				  begin
					Rststate <= state_0;  
				  end
			 end 
	 state_8 :
			 begin
			  Flag_Rst <= 1;      
			  CountRstStep <= 0;
			  icdata <= 1'b1;
			  Rststate <= state_0;     
			 end
			 
	state_9 :
			 begin
				if(CountRstStep > 300)
					begin
					 CountRstStep <= 0;
					 Rststate <= state_0;
					end
				else
					begin
					 CountRstStep <= CountRstStep + 1'b1;
					 Rststate <= state_9;
					end 
			end
			
	 default :
			 begin
			  CountRstStep <= 0;
			  Rststate <= state_0;      
			 end 
	 endcase
	end
endtask 






reg[4:0] i;     				
reg Flag_Write;       		
reg[4:0] WrState;       	
initial WrState=5'b00000;

task Write_DS18B20;			
	input [7:0] dcmd;       
	reg	[7:0] indcmd;
	
	begin	
		 case(WrState)
			 state_0 :
				 begin
					Flag_Write <= 0;      
					WrState <= state_1; 
					indcmd <= dcmd;
					icdata <= 1'b1;	
					i <= 0; 
				 end
			 state_1 :
				 begin 
					if(i < 8)
						begin
							wBit_DS18B20(dcmd[i]); 
							if(Flag_wBit)  
								begin
								 i <= i + 1'b1;      
								end
							WrState <= state_1;    
					  end
				  else         
						begin
						WrState <= state_2;    
						i <= 5'd0;
						end 
					
				 end
			 state_2 :
				begin
				icdata<=1'b1;
				WrState <= state_3;
				end
			 state_3 :
				begin
				WrState <= state_4;
				end
			state_4:
				 begin
				  Flag_Write <= 1'b1;      
				  indcmd <= 0;
				  WrState <= state_0;
				 end
			 default :
				 begin
					Flag_Write <= 1'b0;
					WrState<=state_0;
					Flag_Write <= 1'b0;
				 end
		 endcase
	end

endtask 
 
reg Flag_wBit;         		
reg[4:0] WriteBitstate;    
reg[7:0] CountWbitStep;    

task wBit_DS18B20;			
input wiBit;          
	begin 
		 case(WriteBitstate)
		 state_0 :
			 begin
			  Flag_wBit <= 1'b0;      
			  icdata <= 1'b0;       			  
			  CountWbitStep <= 8'd0;
			  WriteBitstate <= state_1;
			 end 
		 state_1 :
			 begin
			  if(CountWbitStep>15)
				begin
				  CountWbitStep<=8'd0;
				  WriteBitstate <= state_2;
				end
			  else
				begin
					CountWbitStep<=CountWbitStep+1'b1;
					WriteBitstate <= state_1;
				end
			 end 
		 state_2 :
			 begin
				if(wiBit)
					begin
					icdata <= 1;
					WriteBitstate <= state_3;
					end
				else
					begin
					icdata <= 0;
					WriteBitstate <= state_3;
					end
			 end
		 state_3 :
				begin
				  if(CountWbitStep >= 60)     
					  begin
						CountWbitStep <= 0;
						WriteBitstate <= state_4;
					  end
				  else
					  begin
						CountWbitStep <= CountWbitStep + 1'b1; 
						WriteBitstate <= state_3;
					  end				  
				end 
		 state_4 :
			 begin
			 icdata <= 1;
			 WriteBitstate <= state_5;
			 end
		 state_5 :
			 begin
			  if(CountWbitStep >= 3)     
				  begin
					CountWbitStep <= 0;
					WriteBitstate <= state_6;
				  end
			  else
				  begin
					CountWbitStep <= CountWbitStep + 1'b1;
					WriteBitstate <= state_5;
				  end
			 end 
		 state_6 :         
			 begin
			  Flag_wBit <= 1;    
			  CountWbitStep <= 0;
			  WriteBitstate <= state_0;

			 end
		 default :
			 begin
			  Flag_wBit <= 0;
			  CountWbitStep <= 0;
			  WriteBitstate <= state_0; 
			 end 
		endcase
	end
endtask




reg[3:0] j;
reg[7:0] ResultDS18B20; 	
reg Flag_Read;         		
reg [15:0] Readstate;      

task Read_DS18B20;					
	begin
		 case(Readstate)
			 state_0 :
				 begin
				  Flag_Read <= 0;      
				  Readstate <= state_1;
				  j <= 0;
				 end
			 state_1 :
				 begin
					  rBit_DS18B20;
					  if(Flag_rBit)
						  begin
								if(temp)
								begin
								ResultDS18B20 = ResultDS18B20 | 8'b10000000;
								end
								if(j < 7)
									begin
									 ResultDS18B20 = ResultDS18B20 >> 1; 
									 j <= j + 1'b1;
									 Readstate <= state_1;
									end 
								else
									begin
									 Readstate <= state_2;   
									 
									 j <= 0;
									end   
						  end
					  else Readstate <= state_1;  
				 end
			 state_2 : 
				 begin
				  Flag_Read <= 1;       
				  Readstate <= state_0;
				 end
			 default : 
				 begin
				  Flag_Read <= 0;
				  Readstate <= state_0;
				 end
		 endcase
	end 
endtask  

 

 
reg Flag_rBit,temp;       
reg[15:0] ReadBitstate;   
reg[15:0] CountRbitStep;    

task rBit_DS18B20;			
	begin
		 case(ReadBitstate)
				 state_0 :
					 begin
					  Flag_rBit <= 1'b0;      
					  icdata <= 1'b0;      
					  CountRbitStep <= 16'd0;
					  ReadBitstate <= state_1;
					 end
				 state_1 :
					 begin
						if(CountRbitStep >= 2)   
							begin
							icdata <= 1'b1;     
							CountRbitStep <= 0;		
							ReadBitstate <= state_2;			
							end
						else
							begin
							CountRbitStep <= CountRbitStep + 1'b1;	
							ReadBitstate <= state_1;
							end  
					 end
				state_2 :
					 begin
					 if(CountRbitStep >= 4)     
							begin	
							icdata <= 1'bz;     
							CountRbitStep <= 16'd0; 			
							ReadBitstate <= state_3;
							end
						else
							begin
							CountRbitStep <= CountRbitStep + 1'b1;		
							ReadBitstate <= state_2;
							end  
					 end
				state_3 :
					 begin
						  if(CountRbitStep >= 2)     
							  begin
							  if(icdata)				
								begin
									temp <= 1'b1;    
									data=data+1'b1;	
									end
								else 
									begin
									temp <= 1'b0;      
									
								end
								
								CountRbitStep <= 16'd0;
								ReadBitstate <= state_4;
							  end
						  else
								  begin
									CountRbitStep <= CountRbitStep + 1'b1;		
									ReadBitstate <= state_3;   
								  end
					 end
				state_4 :
					 begin
					  if(CountRbitStep >= 60)     
						  begin
							CountRbitStep <= 16'd0;
							ReadBitstate <= state_5; 
						  end
					  else
						  begin
							CountRbitStep <= CountRbitStep + 1'b1;
							ReadBitstate <= state_4; 
						  end     
					 end
				state_5 :
					 begin
					  icdata<=1'b1;            
					  Flag_rBit <= 1'b1;       
					  CountRbitStep <= 16'd0;
					  ReadBitstate <= state_0; 
					 end
				default :
					 begin
					  Flag_rBit <= 1'b0;
					  CountRbitStep <= 16'd0;
					  ReadBitstate <= state_0;  
					 end
		 endcase
	end 
endtask 





reg [15:0] CmdSETstate;
reg [15:0] Count65535;
reg [3:0] Count12;
reg [7:0] Resultl,Resulth;
reg	[15:0]Result_all;
initial CmdSETstate = 16'b0000000000000000;

task CmdSETDS18B20;			
	begin
		 case(CmdSETstate)			 			 
		 state_0 :
			 begin
			  Flag_CmdSET = 0;
			  Rst_DS18B20;
			  if(!Flag_Rst)	  
				  begin
				  CmdSETstate <= state_0;
				  end			  
			  else 
				begin
				CmdSETstate <= state_1;
				end
			 end
		 state_1 :
			 begin
			  Write_DS18B20(8'hCC);
			  if(!Flag_Write)CmdSETstate <= state_1;
			  else CmdSETstate <= state_2;
			 end
		 state_2 : 
			 begin
			  Write_DS18B20(8'h44);
			  if(!Flag_Write)CmdSETstate <= state_2;
			  else CmdSETstate <= state_3;
			 end
		 state_3 :														
		 begin														
			  if(Count65535 == 65535)									
				  begin
					Count65535 <= 0;
					CmdSETstate <= state_4;
				  end
			  else
				  begin
					Count65535 <= Count65535 + 1'b1;
					CmdSETstate <= state_3;
				  end    
			 end
		 state_4 :
			 begin
			  if(Count12 == 13)
				  begin
					Count12 <= 0;
					CmdSETstate <= state_5;
				  end
			  else
			  begin
				Count12 <= Count12 + 1'b1;
				CmdSETstate <= state_3;
			  end   
			 end  
		 state_5 :
			 begin
				Rst_DS18B20;
				if(!Flag_Rst)
					CmdSETstate <= state_5;
				else 
					begin
					CmdSETstate <= state_6;
					end
			 end		 
		 state_6 :
			 begin
			  Write_DS18B20(8'hcc);
			  if(!Flag_Write)CmdSETstate <= state_6;
			  else CmdSETstate <= state_7;
			 end 
		 state_7 : 
			 begin
				Write_DS18B20(8'hbe);
			  if(!Flag_Write)CmdSETstate <= state_7;
			  else CmdSETstate <= state_8;
			 end 
		 state_8 :
			 begin		
			  Read_DS18B20;
			  if(!Flag_Read)CmdSETstate <= state_8;
			  else
				  begin
					Resultl = ResultDS18B20;
				   ResultDS18B20 <= 8'b00000000;
					CmdSETstate <= state_9;
				  end 
			 end  
		 state_9 :
			 begin
			  Read_DS18B20;
			  if(!Flag_Read)CmdSETstate <= state_9;
			  else
			  begin
				Resulth = ResultDS18B20;
				ResultDS18B20 <= 8'b00000000;
				CmdSETstate <= state_10;
			  end 

			 end  
		 state_10 :
			 begin
			  Result_all=Resulth;
			  Result_all=Result_all<<8;
			  Result_all=Result_all|Resultl;
			  tempre_temp=Result_all;
			  tempre_temp=tempre_temp*10;		
			  data<=tempre_temp/16;
			  CmdSETstate <= state_11;
			 end 
		 state_11 : 
			 begin
			  Flag_CmdSET <= 1;
			  CmdSETstate <= state_0;
			 end
		 default :
			 begin
			  Flag_CmdSET = 0;
			  CmdSETstate <= state_0; 
			 end
		 endcase
	end
endtask 

endmodule 


