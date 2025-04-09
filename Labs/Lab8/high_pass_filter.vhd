library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity high_pass_filter is
port (
	clk : in std_logic; -- CLOCK_50
	reset_n : in std_logic; -- active low reset
	data_in : in std_logic_vector(15 downto 0); --Audio sample, in 16 bit fixed point format (15 bits of assumed decimal)
	filter_en : in std_logic; --This is enables the internal registers and coincides with a new audio sample
	data_out : out std_logic_vector(15 downto 0) --This is the filtered audio signal out, in 16 bit fixed point format
);
end high_pass_filter;

architecture arch of high_pass_filter is

	component multiplier_inst is 
	port (
		dataa		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		result	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
	end component;
	
	component dff is
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
	signal flag : std_logic := '0';

   signal samples   : sample_array := (others => (others => '0'));
	signal coefficents : coeff_array := (
		X"003E", -- 0.0019
		X"FF9A", -- -0.0031
		X"FE9E", -- -0.0108
		X"0000", -- 0
		X"0536", -- 0.0407
		X"05B2", -- 0.0445
		X"F5AC", -- -0.0807
		X"DAB7", -- -0.2913
		X"4C92", -- 0.5982
		X"DAB7", -- -0.2913
		X"F5AC", -- -0.0807
		X"05B2", -- 0.0445
		X"0536", -- 0.0407
		X"0000", -- 0
		X"FE9E", -- -0.0108
		X"FF9A", -- -0.0031
		X"003E"  -- 0.0019
	);

begin
	
	samples(0) <= data_in;

	-- generate statement for 16 LPM_MULT components
	mult_hpf: for k in 0 to 16 generate
		mult_hpf : multiplier_inst 
		port map (
		 dataa => samples(k), 
		 datab => coefficents(k), 
		 result => product(k)
		 );
   end generate mult_hpf;
   
   -- generate statement for 16 shifter components
   flip_flop : for j in 0 to 15 generate
		flip_flop : dff
		port map (
		  clk => clk,
		  reset_n => reset_n,
		  data_in2 => samples(j),
		  filter_en => filter_en,
		  data_out2 => shift(j + 1)
		);
	end generate flip_flop;
	
	-- idea: raise flag when generate reaches 16 to prevent multiple drivers?
	-- current error is sum has multiple drivers
	gen_add : for i in 0 to 16 generate
	begin
		sum <= sum + signed(product(i));
		check_out : process(i)
		begin
		if (i = 16) then
			flag <= '1';
		else
			flag <= '0';
		end if;
		end process;
	end generate gen_add;
	
	check_sum : process(flag)
	begin
		if (flag = '1') then
			data_out <= std_logic_vector(sum(30 downto 15));
		end if;
	end process;
	
	
end arch;