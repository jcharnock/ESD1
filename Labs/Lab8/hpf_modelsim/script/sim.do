vlib work
vcom -93 -work work ../src/dff.vhd
vcom -93 -work work ../src/multiplier_inst.vhd
vcom -93 -work work ../src/high_pass_filter.vhd
vcom -93 -work work ../src/high_pass_filter_tb.vhd
vsim -voptargs=+acc high_pass_filter_tb
do wave.do
run 22000 ns