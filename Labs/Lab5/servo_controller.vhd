LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use IEEE.numeric_std.all;

ENTITY servo_controller IS
  PORT(clk        : IN    std_logic;
	   reset_n    : IN    std_logic;
	   write      : IN    std_logic;
	   address    : IN    std_logic;
	   writedata  : IN    std_logic_vector(31 downto 0);
       out_wave   : OUT   std_logic;
       irq        : OUT   std_logic
       );
END servo_controller;

architecture arch of servo_controller IS

	-- minimum angle of 45 degrees (min pulse width of 1 ms) - 50000
	constant min_angle_count : unsigned(31 downto 0) := X"0000C350";
	-- maximum angle of 135 degrees (max pulse width of 2 ms) - 100000
	constant max_angle_count : unsigned(31 downto 0) := X"000186A0";
	-- median angle count of 90 degrees (pulse width of 1.5 ms)
	constant med_angle_count : unsigned(31 downto 0) := X"00011B34";
	constant max_period : unsigned(31 downto 0) := X"000F4240";
	signal period_count : unsigned(31 downto 0) := (others => '0');
	signal angle_count  : unsigned(31 downto 0) := X"00011B34";
	
	-- ram_type is a 2-dimensional array or inferred ram.  
	-- It stores eight 32-bit values
	TYPE ram_type IS ARRAY (1 DOWNTO 0) OF unsigned (31 DOWNTO 0);
	SIGNAL Registers : ram_type; 
	
	-- state signals
	type state_type is (sweep_r, int_r, sweep_l, int_l);
	signal current_state, next_state : state_type;
	
	
begin

	-- period counter 
	pd_counter : process (clk, reset_n)
	BEGIN
		if (reset_n = '0') then
			period_count <= (others => '0');
		elsif (rising_edge(clk)) then
			-- count to 1 million for the total period of the servo (20 ms)
			if (period_count = max_period) then
				period_count <= (others => '0');
			else
				period_count <= period_count + 1;
			end if;
		end if;
	end process;

	-- state synchronizer for FSM
	FSM_synch : process(clk, reset_n)
	begin
		if (reset_n = '0') then
			current_state <= sweep_r;
		elsif (rising_edge(clk)) then
			current_state <= next_state;
		end if;
	end process;
	
	-- fsm for servo behavior
	state : process(current_state, write, angle_count, Registers)
	begin
		next_state <= current_state;
		case (current_state) is
			when sweep_r =>
				-- if reaching max angle then change to int_r
				-- else stay at sweep_r
				if (Registers(1) < angle_count) then
					next_state <= int_r;
				else
					next_state <= sweep_r;
				end if;
			when int_r =>
				-- if data registers are written to change to sweep_l
				-- else stay at int_r
				if (write = '1') then
					next_state <= sweep_l;
				else 
					next_state <= int_r;
				end if;
			when sweep_l =>
				-- if reaching max angle then change to int_l
				-- else stay at sweep_l
				if (angle_count < Registers(0)) then
					next_state <= int_l;
				else
					next_state <= sweep_l;
				end if;
			when int_l =>
				-- if data registers are written to change to sweep_r
				-- else stay at int_l
				if (write = '1') then
					next_state <= sweep_r;
				else
					next_state <= int_l;
				end if;
			when others =>
				next_state <= sweep_r;
		end case;
	end process;
	
	-- pulse controller
	-- plus 10k if state is sweep left, minus 10k if state is sweep right
	angle_logic : process (clk, reset_n, period_count, next_state)
	BEGIN
		if (reset_n = '0') then
			angle_count <= med_angle_count;
		elsif (rising_edge(clk)) then
			if (period_count = max_period) then
				case (next_state) is 
					when sweep_r =>
						angle_count <= angle_count + 500;
					when sweep_l =>
						angle_count <= angle_count - 500;
					when others =>
						angle_count <= angle_count;
				end case;
			end if;
		end if;
	end process;
	
	-- implement register logic - may depend on write being 1 / interrupt logic firing?
	register_logic : process (clk, reset_n, write, address, writedata, next_state) 
	BEGIN
		IF (reset_n = '0') THEN
			Registers(1) <= max_angle_count;
			Registers(0) <= min_angle_count;
		ELSIF (rising_edge(clk)) THEN
			IF (write = '1') THEN
				if (address = '0') then
					Registers(0) <= unsigned(writedata);
				else
					Registers(1) <= unsigned(writedata);
				end if;
        --when write enable is active, the ram location at the given address
        --is loaded with the input data
      END IF;
    END IF;
	end process;

	-- irq logic fires when the interrupt logic fires?
	-- may depend on state, check reset and current state?
	interrupts : PROCESS(next_state)
	BEGIN
		case (next_state) IS
			when int_r =>
				irq <= '1';
			when int_l =>
				irq <= '1';
			when others =>
				irq <= '0';
		end case;
	END PROCESS;
	
	out_wave_logic : process (angle_count, period_count)
	BEGIN
		if (period_count <= angle_count) then 
			out_wave <= '1';
		else
			out_wave <= '0';
		end if;
	end PROCESS;

end architecture;
