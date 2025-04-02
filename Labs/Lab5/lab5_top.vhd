library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- change entity and replacce nios system component as needed
ENTITY servo_custom is
  port (
    CLOCK_50  : in  std_logic;
    KEY       : in  std_logic_vector(3 downto 0);
    SW        : in  std_logic_vector(9 downto 0);
    HEX0      : out std_logic_vector(6 downto 0);
	 HEX1      : out std_logic_vector(6 downto 0);
	 HEX2      : out std_logic_vector(6 downto 0);
	 HEX4      : out std_logic_vector(6 downto 0);
	 HEX5      : out std_logic_vector(6 downto 0);
	 GPIO0     : out std_logic 
	 );
end entity servo_custom;

architecture arch of servo_custom is
  signal led0 : std_logic;
  signal cntr : std_logic_vector(25 downto 0);
  signal reset_n : std_logic;
  signal key0_d1 : std_logic_vector(3 downto 0);
  signal key0_d2 : std_logic_vector(3 downto 0);
  signal key0_d3 : std_logic_vector(3 downto 0);
  signal sw_d1 : std_logic_vector(9 downto 0);
  signal sw_d2 : std_logic_vector(9 downto 0);

  component nios_system is
		port (
			clk_clk              : in  std_logic                    := 'X';             -- clk
			reset_reset_n        : in  std_logic                    := 'X';             -- reset_n
			switches_export      : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
			pushbutton_export    : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			hex0_export          : out std_logic_vector(6 downto 0);                    -- export
			hex1_export          : out std_logic_vector(6 downto 0);                    -- export
			hex2_export          : out std_logic_vector(6 downto 0);                    -- export
			hex4_export          : out std_logic_vector(6 downto 0);                    -- export
			hex5_export          : out std_logic_vector(6 downto 0);                    -- export
			out_wave_out_wave    : out std_logic                                        -- out_wave
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
			clk_clk              => CLOCK_50,      --         clk.clk
			reset_reset_n        => reset_n,       --       reset.reset_n
			switches_export      => sw_d2(7 downto 0),         --    switches.export
			pushbutton_export    => key0_d3,       --  pushbutton.export
			hex0_export          => HEX0,          --        hex0.export
			hex1_export          => HEX1,          --        hex1.export
			hex2_export          => HEX2,          --        hex2.export
			hex4_export          => HEX4,          --        hex4.export
			hex5_export          => HEX5,          --        hex5.export
			out_wave_out_wave    => GPIO0          -- servo_motor.out_wave
		);
  
  end architecture;