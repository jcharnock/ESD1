LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use IEEE.numeric_std.all;

entity servo_controller_top is
	port ( CLOCK_50_top  : in std_logic;
			 reset_top     : in std_logic;
			 out_wave_top  : out std_logic;
			 irq_top       : out std_logic );
end servo_controller_top;

architecture arch of servo_controller_top is

	component servo_controller IS
		PORT(CLOCK_50  : IN    std_logic;
			reset      : IN    std_logic;
			write      : IN    std_logic;
			address    : IN    std_logic;
			writedata  : IN    std_logic_vector(31 downto 0);
			out_wave   : OUT   std_logic;
			irq        : OUT   std_logic
			);
	END component;
	
	signal address_top   : std_logic := '0';
	signal write_top     : std_logic := '0';
	signal writedata_top : std_logic_vector(31 downto 0) := (others => '0');
	
begin 

	funct_unit : servo_controller
	port map (
		CLOCK_50  => CLOCK_50_top,
		reset     => reset_top,
		write     => write_top,
		address   => address_top,
		writedata => writedata_top,
		out_wave  => out_wave_top,
		irq       => irq_top
	);

	write_top <= '1';
	address_top <= '0';
	writedata_top <= X"0000C350";
	
	
end arch;
