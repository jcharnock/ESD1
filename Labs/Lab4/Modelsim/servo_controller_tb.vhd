LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use IEEE.numeric_std.all;

entity servo_controller_tb is
end servo_controller_tb;

architecture arch of servo_controller_tb is

component servo_controller IS
  PORT(CLOCK_50  : IN    std_logic;
	   reset     : IN    std_logic;
	   write     : IN    std_logic;
	   address   : IN    std_logic;
	   writedata : IN    std_logic_vector(31 downto 0);
       out_wave  : OUT   std_logic;
       irq       : OUT   std_logic
       );
END component;

constant period     : time := 20 ns;                                              
signal CLOCK_50_tb  : std_logic := '0';
signal reset_tb     : std_logic := '0';

signal write_tb     : std_logic := '0';
signal address_tb   : std_logic := '0';
signal writedata_tb : std_logic_vector(31 downto 0) := (others => '0');

signal out_wave_tb : std_logic := '0';
signal irq_tb     : std_logic := '0';

begin

-- clock process
clock: process
  begin
    CLOCK_50_tb <= not CLOCK_50_tb;
    wait for period/2;
end process; 
 
-- reset process
async_reset: process
  begin
    wait for 2 * period;
    reset_tb <= '1';
    wait;
end process; 

uut : servo_controller 
	port map (
		CLOCK_50  => CLOCK_50_tb,
		reset     => reset_tb,
		write     => write_tb,
		address   => address_tb,
		writedata => writedata_tb,
		out_wave  => out_wave_tb,
		irq       => irq_tb
	);
		
tb : process
	begin
		report "********* begin test *************";
			wait for 6000 ns;
			write_tb <= '1';
			writedata_tb <= X"00011B34"; --50000 for min pulse
			wait for 1000 ns;
			write_tb <= '0';
			wait for 6000 ns;
			write_tb <= '1';
			address_tb <= '1';
			writedata_tb <= X"00011B34"; --100000 for max pulse
		report "********* min and max written to register *************";	
			wait for 1000 ns;
			write_tb <= '0';
			wait for 6000 ns;
			write_tb <= '1';
			wait for 1000 ns;
			write_tb <= '0';
			wait for 6000 ns;
			write_tb <= '1';
			wait for 1000 ns;
			write_tb <= '0';
		report "********* end test *************";
			wait;
	end process;
end arch;
			