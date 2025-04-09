library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
signal writedata_tb : std_logic_vector(31 downto 0) :=  X"11111111";

signal readdata_tb  : std_logic_vector(31 downto 0) := (others => '0');
signal loop_count   : std_logic_vector(3 downto 0) := (others => '0');
signal add : unsigned(31 downto 0) :=  X"11111111";

type val_array is array (15 downto 0) of std_logic_vector(31 downto 0);
constant expected_vals : val_array := (
	X"11111111", --1
	X"21178111",
	X"21178175",
	X"311D8175",
	X"311DF1D9",
	X"411D62D9",
	X"411D623D",
	X"511D623D", --8
	X"512AD2A1",
	X"513143A1",
	X"51314305",	
	X"51374305",
	X"5137B369",
	X"51372369",
	X"513723CD",
	X"513723CD" 	
	);
	
	
	

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
		report "********* begin test: write to RAM *************";
		for j in 0 to 15 loop
			loop_count <= std_logic_vector(to_unsigned(j, 4));
			add <= unsigned(writedata_tb) + X"10067064";
			writedata_tb <= std_logic_vector(add);
			wait for 40 ns;
			for i in 0 to 4095 loop
				write_tb <= loop_count;
				address_tb <= std_logic_vector(to_unsigned(i, 12));
				wait for 20 ns;	
				if not (readdata_tb = expected_vals(j)) then
					assert (readdata_tb /= expected_vals(j)) report "RAM write error" severity error;
				end if;
				write_tb <= "1111";
			end loop;
		end loop;
			

			
		wait;
	end process;
end arch;
			