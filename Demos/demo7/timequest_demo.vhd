library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity timequest_demo is
port ( clk   : in std_logic;
	   A      : in std_logic_vector (15 downto 0);
	   B      : in std_logic_vector (15 downto 0);  
	   result : out std_logic_vector(16 downto 0)
	 );
end timequest_demo;

architecture arch of timequest_demo is

	signal A_d1, A_d2, A_d3 : std_logic_vector(15 downto 0);
	signal B_d1, B_d2, B_d3 : std_logic_vector(15 downto 0);
	signal Res_d1, Res_d2, Res_d3 : std_logic_vector(16 downto 0);
	signal add_sig : std_logic_vector(16 downto 0);

begin

  synchA_proc : process (clk) begin
		if (rising_edge(clk)) then
				A_d1 <= A;
		end if;
  end process synchA_proc;

  synchB_proc : process (clk) begin
		if (rising_edge(clk)) then
				B_d1 <= B;
		end if;
  end process synchB_proc;
  
  add_sig  <= std_logic_vector(unsigned('0' & A_d1) + unsigned('0' & B_d1));
	
  synchOut_proc : process (clk) begin
		if (rising_edge(clk)) then
				Res_d1 <= add_sig;
		end if;
  end process synchOut_proc;
  
  result <= Res_d1;
  
end arch;
