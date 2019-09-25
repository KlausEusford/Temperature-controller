module Tempreture(clk,rst,ds,led,cs,key1,key2,key3,key_p,key_i,key_d,static_p1,static_p2,work_status,show_flag_wire,heater_status,fan_status,heater_control,loopfin);
input		key1,key2,key3,key_p,key_i,key_d;
input		rst;
input		clk;
inout		ds;
output	[3:0]cs;
output	[7:0]led;
output   [7:0]static_p1;
output   [7:0]static_p2;
output   work_status;    
output   show_flag_wire;   
output   heater_status;    
output   fan_status;		  
output  heater_control;     
output loopfin;
wire clk_1ms_wire;
wire clk_1s_wire;
wire clk_1us_wire;
wire [11:0]temp_data;
wire	[11:0]data_warn_wire;
wire	[2:0]flash_flag_wire;
wire key1_wire;
wire key2_wire;
wire key3_wire;
wire [15:0]mid_point;
wire [6:0]P_PARA;
wire [6:0]I_PARA;
wire [6:0]D_PARA;
wire [1:0]pid_show_wire;
wire pid_lock_wire;
clk_1s U0(
			.clk(clk),
			.rst(rst),
			.CP(clk_1s_wire)
			);
			
clk_1us U1(
			.clk(clk),
			.rst(rst),
			.CP(clk_1us_wire)//clk_1us_wire
			);
						
clk_1ms U2(
			.clk(clk),
			.rst(rst),
			.CP(clk_1ms_wire)//clk_1ms_wire
			);	
			
ds18b20_test U3(	
				//.nReset(rst),
				.clk(clk_1us_wire),
				.icdata(ds),
				.data(temp_data),
				.Flag_CmdSET(loopfin)
				);	
				
key_rc	U4(						
			.clk(clk_1ms_wire),
			.key1(key1),
			.key2(key2),
			.key3(key3),
			.key1_out(key1_wire),
			.key2_out(key2_wire),
			.key3_out(key3_wire)
			);
			
data_change	U5(
				.key1_in(key1_wire),
				.key2_in(key2_wire),
				.key3_in(key3_wire),
				.data_warn(data_warn_wire),
				.show_flag(show_flag_wire),
				.flash_flag(flash_flag_wire)
				);	
				
led_show	U6(
			.flash_flag(flash_flag_wire),
			.show_flag(show_flag_wire),
			.clk_1ms(clk_1ms_wire),
			.cs(cs),
			.data_warn(data_warn_wire),
			.data_show(temp_data),
			.data(led),
			.sta_p1(static_p1),
			.sta_p2(static_p2),
			.p_data(P_PARA),
			.i_data(I_PARA),
			.d_data(D_PARA),
         .pid_show(pid_show_wire),
			.pid_lock(pid_lock_wire)
			);

work_unity U7(
			.data_changing(show_flag_wire),
			.data_warn(data_warn_wire),
			.ds_data(temp_data),
			.data_get_complete(loopfin),
			.p_para(P_PARA),
			.i_para(I_PARA),
			.d_para(D_PARA),
			.heater_open(heater_status),
			.fan_open(fan_status),
			.work_c(work_status),
			.high_len(mid_point)
			);		
			
heatercontrol U8(
         .clk(clk_1us_wire),
			.heater_open(heater_status),
			.high_len(mid_point),
			.heater_con(heater_control)
			);
			
pid_parameter U9(
			.clk(clk_1ms_wire),
			.change_p(show_flag_wire),
			.k_p(key_p),
			.k_i(key_i),
			.k_d(key_d),
			.p_pa(P_PARA),
			.i_pa(I_PARA),
			.d_pa(D_PARA),
         .pid_show(pid_show_wire)	
			);
endmodule 