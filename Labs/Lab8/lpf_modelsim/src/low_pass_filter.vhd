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
	data_out : out std_logic_vector(15 downto 0) --This is the filtered audio signal out, in 16 bit fixed point format
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
	
	component dff_test is
	port (
		clk : in std_logic;
		reset_n : in std_logic;
		data_in2 : in std_logic_vector(15 downto 0);
		filter_en : in std_logic;
		data_out2 : out std_logic_vector(15 downto 0)
	);
	end component;


   type sample_array is array (0 to 16) of std_logic_vector(15 downto 0);
   type coeff_array is array (0 to 16) of std_logic_vector(15 downto 0);
   type prod_array is array (0 to 16) of std_logic_vector (31 downto 0);
   signal product  : prod_array := (others => (others => '0'));
   signal sum      : signed(31 downto 0) := (others => '0');
   signal shift    : sample_array := (others => (others => '0'));

   signal samples   : sample_array := (others => (others => '0'));
	signal coefficents : coeff_array := (
		X"0052", --0.0025
		X"00BB", --0.0057
		X"01E2", --0.0147
		X"0408", --0.0315
		X"071B", --0.0555
		X"0AAD", --0.0834
		X"0E11", --0.1099
		X"1080", --0.1289
		X"1162", --0.1358
		X"1080", --0.1289
		X"0E11", --0.1099
		X"0AAD", --0.0834
		X"071B", --0.0555
		X"0408", --0.0315
		X"01E2", --0.0147
		X"00BB", --0.0057
		X"0052"  --0.0025
	);

begin
	
	samples(0) <= data_in;

	-- generate statement for 16 LPM_MULT components
	mult_hpf: for k in 0 to 15 generate
		mult_hpf : multiplier_inst 
		port map (
		 dataa => samples(k), 
		 datab => coefficents(k), 
		 result => product(k)
		 );
   end generate mult_hpf;
   
   -- generate statement for 16 shifter components
   flip_flop : for j in 0 to 15 generate
		flip_flop : dff_test
		port map (
		  clk => clk,
		  reset_n => reset_n,
		  data_in2 => samples(j),
		  filter_en => filter_en,
		  data_out2 => samples(j + 1)
		);
	end generate flip_flop;
	
	-- idea: raise flag when generate reaches 16 to prevent multiple drivers?
	-- current error is sum has multiple drivers
	sum <= signed(product(0)) + signed(product(1)) + signed(product(2)) + signed(product(3)) + signed(product(4)) + signed(product(5)) + signed(product(6)) + signed(product(7))
	+ signed(product(8)) + signed(product(9)) + signed(product(10)) + signed(product(11)) + signed(product(12)) + signed(product(13)) + signed(product(14)) + signed(product(15));
	
	data_out <= std_logic_vector(sum(30 downto 15));

	
	
end arch;