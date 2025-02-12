
module nios_system (
	clk_clk,
	reset_reset_n,
	leds_export,
	hex0_export,
	switches_export,
	pushbuttons_export);	

	input		clk_clk;
	input		reset_reset_n;
	output	[7:0]	leds_export;
	output	[6:0]	hex0_export;
	input	[7:0]	switches_export;
	input	[3:0]	pushbuttons_export;
endmodule
