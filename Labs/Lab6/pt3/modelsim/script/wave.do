onerror {resume}
radix define States {
 "7'b1000000" "0" -color "yellow",
 "7'b1111001" "1" -color "yellow",
 "7'b0100100" "2" -color "yellow",
 "7'b0110000" "3" -color "yellow",
 "7'b0011001" "4" -color "yellow",
 "7'b0010010" "5" -color "yellow",
 "7'b0000010" "6" -color "yellow",
 "7'b1111000" "7" -color "yellow",
 "7'b0000000" "8" -color "yellow",
 "7'b0011000" "9" -color "yellow",
 -default default
}
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /raminfr_be_tb/CLOCK_50_tb
add wave -noupdate /raminfr_be_tb/reset_tb
add wave -noupdate -radix Binary /raminfr_be_tb/write_tb
add wave -noupdate -radix Unsigned /raminfr_be_tb/writedata_tb
add wave -noupdate -radix Unsigned /raminfr_be_tb/address_tb
add wave -noupdate -radix Unsigned /raminfr_be_tb/readdata_tb
add wave -noupdate /raminfr_be_tb/uut/RAM_A
add wave -noupdate /raminfr_be_tb/uut/RAM_B
add wave -noupdate /raminfr_be_tb/uut/RAM_C
add wave -noupdate /raminfr_be_tb/uut/RAM_D


radix update 
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {417112 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 177
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {400250 ps} {505250 ps}