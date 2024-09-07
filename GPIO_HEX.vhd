--------------- Output Peripheral Module 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY GPIO_HEX IS

	PORT( 
		MemRead		: IN	STD_LOGIC;
		clock		: IN 	STD_LOGIC;
		reset		: IN 	STD_LOGIC;
		MemWrite	: IN	STD_LOGIC;
		ChipSelect	: IN 	STD_LOGIC;
		Data		: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		GPOutput	: OUT	STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
END GPIO_HEX;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF GPIO_HEX IS
	SIGNAL D_Latch_out	: STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	PROCESS(clock,reset)
	BEGIN
	IF (reset = '1') THEN
		D_Latch_out	<= X"00";
	ELSIF (rising_edge(clock)) THEN
		IF (MemWrite = '1' AND ChipSelect = '1') THEN
			D_Latch_out <= Data;
		END IF;
	END IF;
END PROCESS;

	Data	<=	D_Latch_out WHEN (MemRead = '1' AND ChipSelect = '1') 	ELSE (others => 'Z'); 
	HEX: HexDecode PORT MAP (Binary_vec => D_Latch_out(3 DOWNTO 0),
						HEX_out => GPOutput);
	
END structure;