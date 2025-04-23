vlib work
vcom -93 -work work ../src/dff_test.vhd
vcom -93 -work work ../src/multiplier_inst.vhd
vcom -93 -work work ../src/filter.vhd
vcom -93 -work work ../src/filter_tb.vhd
vsim -voptargs=+acc filter_tb
do wave.do
run 66000 ns