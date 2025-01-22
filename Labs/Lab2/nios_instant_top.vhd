-- Lab 2 Top Level 
-- Instantiates NIOS system component.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- change entity and replacce nios system component as needed
ENTITY nios_instant_top is
  port (
    CLOCK_50  : in  std_logic;
    KEY       : in  std_logic_vector(3 downto 0);
    SW        : in  std_logic_vector(9 downto 0);
    HEX0      : out std_logic_vector(6 downto 0)
	 );
end entity nios_instant_top;

architecture arch of nios_instant_top is
  signal led0 : std_logic;
  signal cntr : std_logic_vector(25 downto 0);
  signal ledNios : std_logic_vector(7 downto 0);
  signal reset_n : std_logic;
  signal key0_d1 : std_logic_vector(3 downto 0);
  signal key0_d2 : std_logic_vector(3 downto 0);
  signal key0_d3 : std_logic_vector(3 downto 0);
  signal sw_d1 : std_logic_vector(9 downto 0);
  signal sw_d2 : std_logic_vector(9 downto 0);

 	component nios_system is
		port (
			clk_clk            : in  std_logic                    := 'X';             -- clk
			reset_reset_n      : in  std_logic                    := 'X';             -- reset_n
			hex0_export        : out std_logic_vector(6 downto 0);                    -- export
			pushbuttons_export : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			switches_export    : in  std_logic_vector(7 downto 0) := (others => 'X')  -- export
		);
	end component nios_system;
	
begin

	-- synchronizes the pushbutton inputs, position 0 is assigned to reset
	synchReset_proc : process (CLOCK_50) begin
		if (rising_edge(CLOCK_50)) then
				key0_d1 <= KEY;
				key0_d2 <= key0_d1;
				key0_d3 <= key0_d2;
		end if;
  end process synchReset_proc;
  reset_n <= key0_d3(0);
  
  -- switch synchronization process
  synchUserIn_proc : process (CLOCK_50) begin
		if (rising_edge(CLOCK_50)) then
			if (reset_n = '0') then
				cntr  <= "00" & x"000000";
				sw_d1 <= "00" & x"00";
				sw_d2 <= "00" & x"00";
			else
				cntr <= cntr + ("00" & x"000001");
				sw_d1 <= SW;
				sw_d2 <= sw_d1;
			end if;
		end if;
  end process synchUserIn_proc;
  

	u0 : component nios_system
		port map (
			clk_clk            => CLOCK_50,            --         clk.clk
			reset_reset_n      => reset_n,     			 --       reset.reset_n
			hex0_export        => HEX0,      		    --        hex0.export
			pushbuttons_export => KEY,   				    -- pushbuttons.export
			switches_export    => sw_d2(7 downto 0)    --    switches.export
		);


end arch;