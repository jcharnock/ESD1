LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use IEEE.numeric_std.all;

entity raminfr_be_tb is
end raminfr_be_tb;

architecture arch of raminfr_be_tb is

component raminfr_be IS
PORT(
	clk : IN std_logic;
	reset_n : IN std_logic;
	writebyteenable_n : IN std_logic_vector (3 DOWNTO 0);
	address : IN std_logic_vector(11 DOWNTO 0);
	writedata : IN std_logic_vector(31 DOWNTO 0);
	--
	readdata : OUT std_logic_vector(31 DOWNTO 0)
);
END component;

constant period     : time := 20 ns;                                              
signal CLOCK_50_tb  : std_logic := '0';
signal reset_tb     : std_logic := '0';

signal write_tb     : std_logic_vector(3 DOWNTO 0) := (others => '1');
signal address_tb   : std_logic_vector(11 downto 0) := (others => '0');
signal writedata_tb : std_logic_vector(31 downto 0) := (others => '0');

signal readdata_tb  : std_logic_vector(31 downto 0) := (others => '0');

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

uut : raminfr_be 
	port map (
		clk               => CLOCK_50_tb,
		reset_n           => reset_tb,
		writebyteenable_n => write_tb,
		address           => address_tb,
		writedata         => writedata_tb,
		readdata          => readdata_tb
	);
		
tb : process
	begin
		report "********* begin test: write to RAM_D *************";
			wait for 600 ns;
			write_tb(0) <= '0';
			writedata_tb <= X"00011B34";
			wait for 100 ns;
			write_tb(0) <= '1';
		report "********* write to RAM_C *************";	
			wait for 600 ns;
			write_tb(1) <= '0';
			address_tb <= "000000001010";
			writedata_tb <= X"00000909";
			wait for 100 ns;			
			write_tb(1) <= '1';
			wait;
		report "********* write to RAM_B and RAM_A *************";	
			wait for 600 ns;
			write_tb <= "0011";
			address_tb <= "000000010010";
			writedata_tb <= X"00000606";
			wait for 100 ns;			
			write_tb <= "1111";
		report "********* write to all *************";	
			wait for 600 ns;
			write_tb <= "0000";
			address_tb <= "000000010010";
			writedata_tb <= X"00000777";
			wait for 100 ns;			
			write_tb <= "1111";	
			wait;
	end process;
end arch;
			