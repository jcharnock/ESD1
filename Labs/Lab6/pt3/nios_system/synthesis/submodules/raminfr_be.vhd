LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY raminfr_be IS
PORT(
	clk : IN std_logic;
	reset_n : IN std_logic;
	writebyteenable_n : IN std_logic_vector (3 DOWNTO 0);
	address : IN std_logic_vector(11 DOWNTO 0);
	writedata : IN std_logic_vector(31 DOWNTO 0);
	--
	readdata : OUT std_logic_vector(31 DOWNTO 0)
);
END ENTITY raminfr_be;

ARCHITECTURE rtl OF raminfr_be IS
	TYPE ram_type IS ARRAY (4095 DOWNTO 0) OF std_logic_vector (7 DOWNTO 0);
	SIGNAL RAM_A : ram_type := (OTHERS => (OTHERS => '0')); -- highest (bit 3)
	SIGNAL RAM_B : ram_type := (OTHERS => (OTHERS => '0'));
	SIGNAL RAM_C : ram_type := (OTHERS => (OTHERS => '0')); 
	SIGNAL RAM_D : ram_type := (OTHERS => (OTHERS => '0')); -- lowest (bit 0)
	SIGNAL read_addr : std_logic_vector(11 DOWNTO 0);
BEGIN
	RamBlock : PROCESS(clk)
	BEGIN
		IF (clk'event AND clk = '1') THEN
			IF (reset_n = '0') THEN
				read_addr <= (OTHERS => '0');
			ELSE 
				IF (writebyteenable_n(0) = '0') THEN
					RAM_D(conv_integer(address)) <= writedata(7 DOWNTO 0);
				END IF;
				IF (writebyteenable_n(1) = '0') THEN
					RAM_C(conv_integer(address)) <= writedata(15 DOWNTO 8);
				END IF;
				IF (writebyteenable_n(2) = '0') THEN
					RAM_B(conv_integer(address)) <= writedata(23 DOWNTO 16);
				END IF;
				IF (writebyteenable_n(3) = '0') THEN
					RAM_A(conv_integer(address)) <= writedata(31 DOWNTO 24);
				END IF;
			END IF;
		read_addr <= address;
		END IF;
	END PROCESS RamBlock;
	readdata <= RAM_A(conv_integer(read_addr)) & RAM_B(conv_integer(read_addr)) & RAM_C(conv_integer(read_addr)) & RAM_D(conv_integer(read_addr));
END ARCHITECTURE rtl;