
module nios_system (
	clk_clk,
	hex0_export,
	hex1_export,
	hex2_export,
	hex4_export,
	hex5_export,
	pushbutton_export,
	reset_reset_n,
	switches_export,
	out_wave_out_wave);	

	input		clk_clk;
	output	[6:0]	hex0_export;
	output	[6:0]	hex1_export;
	output	[6:0]	hex2_export;
	output	[6:0]	hex4_export;
	output	[6:0]	hex5_export;
	input	[3:0]	pushbutton_export;
	input		reset_reset_n;
	input	[7:0]	switches_export;
	output		out_wave_out_wave;
endmodule
