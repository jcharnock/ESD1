library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity filter_tb is
end filter_tb;

architecture arch_tb of filter_tb is

component audio_filter is
port (
	clk       : in std_logic; -- CLOCK_50
	write     : in std_logic;
	reset_n   : in std_logic; -- active low reset
	address   : in std_logic; --This is enables the internal registers and coincides with a new audio sample
	writedata : in std_logic_vector(15 downto 0); --Audio sample, in 16 bit fixed point format (15 bits of assumed decimal)
	readdata  : out std_logic_vector(15 downto 0) --This is the filtered audio signal out, in 16 bit fixed point format
);
end component;

constant period     : time := 20 ns;                                              
signal CLOCK_50_tb  : std_logic := '0';
signal reset_tb     : std_logic := '0';
signal write_tb     : std_logic := '0';
signal address_tb   : std_logic := '0';
signal data_in_tb   : std_logic_vector(15 downto 0) := (others => '0');
signal data_out_tb  : std_logic_vector(15 downto 0) := (others => '0');

type sample_array is array (0 to 39) of signed(15 downto 0);
signal audioSampleArray : sample_array;

begin 

clock: process
  begin
    CLOCK_50_tb <= not CLOCK_50_tb;
    wait for period/2;
end process;

uut : audio_filter 
	port map (
		clk               => CLOCK_50_tb,
		reset_n           => reset_tb,
		writedata         => data_in_tb,
		write             => write_tb,
		address           => address_tb,
		readdata		  => data_out_tb
	);

stimulus : process is
	file read_file : text open read_mode is "../src/one_cycle_200_8k.csv";
	file results_file : text open write_mode is "../src/output_waveform.csv";
	variable lineIn : line;
	variable lineOut : line;
	variable readValue : integer;
	variable writeValue : integer;
begin
	wait for 100 ns;
	reset_tb <= '1';
	-- Read data from file into an array
	for i in 0 to 39 loop
		readline(read_file, lineIn);
		read(lineIn, readValue);
		audioSampleArray(i) <= to_signed(readValue, 16);
		wait for 50 ns;
	end loop;
	file_close(read_file);
	
    ---- Apply the test data low pass through and put the result into an output file
	--data_in_tb <= X"0000";
	--address_tb <= '1';
	--wait for 20 ns;
	--address_tb <= '0';
	--wait for 20 ns;
	--
	--for i in 1 to 10 loop
	--	for j in 0 to 39 loop
	--	write_tb <= '1';
	--	data_in_tb <= std_logic_vector(audioSampleArray(j));
	--	wait for 20 ns;
	--	write_tb <= '0';
	--	writeValue := to_integer(signed(data_out_tb));
	--	write(lineOut, writeValue);
	--	writeline(results_file, lineOut);
	--	wait for 20 ns;
	--	end loop;
	--end loop;
	
	-- Apply the test data high pass through and put the result into an output file
	data_in_tb <= X"FFFF";
	address_tb <= '1';
	wait for 20 ns;
	address_tb <= '0';
	data_in_tb <= X"0000";
	wait for 20 ns;
	
	for i in 1 to 10 loop
		for j in 0 to 39 loop
		write_tb <= '1';
		data_in_tb <= std_logic_vector(audioSampleArray(j));
		wait for 20 ns;
		write_tb <= '0';
		writeValue := to_integer(signed(data_out_tb));
		write(lineOut, writeValue);
		writeline(results_file, lineOut);
		wait for 20 ns;
		end loop;
	end loop;
	
	file_close(results_file);
	wait for 100 ns;
-- last wait statement needs to be here to prevent the process
-- sequence from restarting at the beginning
wait;
end process stimulus;

end architecture;