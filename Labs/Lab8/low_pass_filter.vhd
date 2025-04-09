library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity low_pass_filter is
port (
	clk : in std_logic; -- CLOCK_50
	reset_n : in std_logic; -- active low reset
	data_in : in std_logic_vector(15 downto 0); --Audio sample, in 16 bit fixed point format (15 bits of assumed decimal)
	filter_en : in std_logic; --This is enables the internal registers and coincides with a new audio sample
	data_out : out std_logic_vector(15 downto 0) – This is the filtered audio signal out, in 16 bit fixed point format
);
end low_pass_filter;

architecture arch of low_pass_filter is

	component multiplier_inst is 
	port (
		dataa		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		result	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
	end component;


	type sample_array is array (0 to 16) of signed(15 downto 0);
   type coeff_array is array (0 to 16) of std_logic_vector(15 downto 0);
	signal product  : array (0 to 16) of signed(31 downto 0);
   signal sum      : signed(31 downto 0);
   signal result   : signed(15 downto 0);

   signal samples   : sample_array := (others => (others => '0'));
	signal coefficents : coeff_array := (
		X"0052", --0.0025
		X"00BB", --0.0057
		X"01E2", --0.0147
		X"0409", --0.0315
		X"071C", --0.0555
		X"0AAD", --0.0834
		X"0E14", --0.1099
		X"107F", --0.1289
		X"1151", --0.1358
		X"107F", --0.1289
		X"0E14", --0.1099
		X"0AAD", --0.0834
		X"071C", --0.0555
		X"0409", --0.0315
		X"01E2", --0.0147
		X"00BB", --0.0057
		X"0052"  --0.0025
	)

begin

	-- generate statement for 16 LPM_MULT components
	gen_mult_lpf: for k in 0 to 16 generate
		mult_lpf : multiplier_inst port map
        (dataa(samples(k)), datab(signed(coefficents(k))), product(k));
   end generate gen_mult;

	lpf : process (clk, reset_n)
	begin
	
		if (reset_n = '0') then
			-- reset data_out, samples, sum, and res
			data_out <= (others => '0');
			samples <= (others => (others => '0'));
			result <= (others => '0');
			data_out <= (others => '0');
			
		elsif (rising_edge(clk)) then
			if (filter_en = '1') then
				-- shift samples array w/ for loop to make room for new sample
				for i in 16 downto 1 loop
					samples(i) <= samples(i - 1);
				end loop;
				samples(0) <= signed(data_in);
				
				-- reset sum, then add to sum from products of LPM
				sum <= (others => '0');
				for j in 0 to 16 loop
					sum <= sum + product(j);
				end loop;
				
				-- send result out here & cast to vector
				result <= sum(30 downto 15); 
				data_out <= std_logic_vector(result);
				
			end if;
		end if;
	end process;
end arch;
