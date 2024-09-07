LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY BT_registers IS

	PORT( 
		MemRead		: IN	STD_LOGIC;
		clock		: IN 	STD_LOGIC;
		reset		: IN 	STD_LOGIC;
		clr_ifg     : IN 	STD_LOGIC;
		MemWrite	: IN	STD_LOGIC;
		CS_BTCTL,CS_BTCNT,CS_BTCCR0,CS_BTCCR1	: IN 	STD_LOGIC;
		Data		: INOUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		BTCTL		: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		BTCNT		: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		BTCNT_wr	: OUT	STD_LOGIC;
		BTCNT_INT   : IN    STD_LOGIC_VECTOR(31 DOWNTO 0);
		BTCCR0		: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		BTCCR1		: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
END BT_registers;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF BT_registers IS
	SIGNAL D_Latch_BTCTL	: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL D_Latch_BTCNT	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL D_Latch_BTCCR0	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL D_Latch_BTCCR1	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	
BEGIN
	PROCESS(clock,reset)
	BEGIN
	IF (reset = '1') THEN
		D_Latch_BTCTL  <= X"20";
		D_Latch_BTCCR0 <= X"00000000";
		D_Latch_BTCCR1 <= X"00000000";
		
	ELSIF (rising_edge(clock)) THEN
		IF (MemWrite = '1' AND CS_BTCTL = '1') THEN
			D_Latch_BTCTL <= Data(7 DOWNTO 0);
		ELSIF (MemWrite = '1' AND CS_BTCCR0 = '1') THEN
			D_Latch_BTCCR0 <= Data;
		ELSIF (MemWrite = '1' AND CS_BTCCR1 = '1') THEN
			D_Latch_BTCCR1 <= Data;	
		END IF;
	END IF;
	END PROCESS;
	
	
	PROCESS(clock, reset, clr_ifg)
	BEGIN
	IF (reset = '1' OR clr_ifg = '0') THEN
		D_Latch_BTCNT  <= X"00000000";
		
	ELSIF (rising_edge(clock)) THEN
		IF (MemWrite = '1' AND CS_BTCNT = '1') THEN
			D_Latch_BTCNT <= Data;
		ELSE D_Latch_BTCNT <=	BTCNT_INT;
		
		END IF;
	END IF;
	
END PROCESS;

	Data	<=	X"000000"&D_Latch_BTCTL WHEN (MemRead = '1' AND CS_BTCTL = '1') 	ELSE 
				D_Latch_BTCNT WHEN (MemRead = '1' AND CS_BTCNT = '1') 	ELSE 
				D_Latch_BTCCR0 WHEN (MemRead = '1' AND CS_BTCCR0 = '1') 	ELSE 
				D_Latch_BTCCR1 WHEN (MemRead = '1' AND CS_BTCCR1 = '1') 	ELSE 
				(others => 'Z'); 
				
				
	BTCTL <= D_Latch_BTCTL; 
	BTCNT <= D_Latch_BTCNT;
	BTCNT_wr <= '1' WHEN (MemWrite = '1' AND CS_BTCNT = '1') ELSE '0'; 
	BTCCR0 <= D_Latch_BTCCR0;
	BTCCR1 <= D_Latch_BTCCR1;

	
END structure;