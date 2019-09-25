module work_unity(data_changing,data_warn,ds_data,data_get_complete,p_para,i_para,d_para,heater_open,fan_open,work_c,high_len);
input data_changing;  
input [11:0]data_warn;		
input	[11:0]ds_data;  		
input data_get_complete;	
input [9:0]p_para;			
input [9:0]i_para;
input [9:0]d_para;
output reg heater_open;   
output reg fan_open;      
output reg work_c;       
output reg signed[15:0]high_len;	
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

always @(posedge data_get_complete)
begin
   if(!data_changing) 
	begin
      temp_cont;      
   end
	else					
	begin			
	    heater_open<=0;
		 contCMD<=0;
		 work_c<=0;
		 hter_error<=0;
		 hter_perror<=0;
		 hter_esum<=0;
		 hter_d<=0;
		 high_len<=0;
	end
end

reg signed[15:0]hter_error;   //误差
reg signed[15:0]hter_perror; 	//上一次误差
reg signed[15:0]hter_esum;    //误差积分和
reg signed[15:0]hter_d;

task heater_get;
begin
	hter_perror=hter_error;
	if(data_warn>ds_data)
		hter_error=data_warn-ds_data;
	else
	   begin
		    hter_error=ds_data-data_warn;
          hter_error=hter_error*(-1);			 
		end
	if(hter_error<0)
	   begin
	      high_len<=0;
	   end
	else if(hter_error>0)
	      high_len<=1000;
			else
				begin	
				if(hter_error>=2)
					begin
						hter_esum=hter_error+hter_esum;
						end
				hter_d=hter_error-hter_perror;
				high_len=hter_error*p_para+hter_esum*i_para/3+hter_d*d_para*100;//PWM波的高电平时长
				if(high_len>1000)
					begin
						high_len=15'd1000;
					end
				else if(high_len<0)
						begin	   
							high_len=15'd0;
						end	
			end
end
endtask

reg [3:0]contCMD;
reg [15:0]Count20000;
reg [11:0]Count1000;
reg [3:0]Count50;
reg [11:0]cont_fin;
reg [3:0]judge;

task temp_cont;
begin
      case(contCMD)
		state_0:
		begin
		   work_c<=0;
			fan_open<=0;
			if(data_warn>(ds_data+12'd10)||ds_data>(data_warn+12'd10)) contCMD<=state_1;
		end
		state_1:
		begin
		   work_c<=1;
		   if(ds_data==data_warn) contCMD<=state_2;
			heater_get;
		   if(ds_data>data_warn+1)
         begin		
 	   	   fan_open<=1;
				heater_open<=0;
         end
			else 
			    begin
			       fan_open<=0;
					 heater_open<=1;
			    end
		end
		state_2:
		begin
		   if(ds_data==data_warn)
			   begin
				   if(judge==16)
					   contCMD<=state_3;
					else
					   judge<=judge+1;
			   end
			else
			   begin
			      contCMD<=state_1;
			   end
		end
		state_3:
		begin
		   if(ds_data==data_warn)
			   begin
				   contCMD<=state_0;
					work_c<=0;
			   end
			else
			   begin
			      contCMD<=state_1;
			   end
		end
		endcase
end
endtask

endmodule 