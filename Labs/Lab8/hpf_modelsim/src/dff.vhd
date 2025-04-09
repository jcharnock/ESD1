library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity dff is
port (
	clk : in std_logic; -- CLOCK_50
	reset_n : in std_logic; -- active low reset
	data_in2 : in std_logic_vector(15 downto 0); --Audio sample, in 16 bit fixed point format (15 bits of assumed decimal)
	filter_en : in std_logic; --This is enables the internal registers and coincides with a new audio sample
	data_out2 : out std_logic_vector(15 downto 0) --This is the filtered audio signal out, in 16 bit fixed point format
);
end dff;

architecture arch of dff is
begin 
	Hpf : process (clk, reset_n, filter_en)
	begin
		if (reset_n = '0') then
			data_out2 <= (others => '0');
		elsif (rising_edge(clk)) then
			if (filter_en = '1') then
				data_out2 <= data_in2;
			end if;
		end if;
	end process;
end arch;