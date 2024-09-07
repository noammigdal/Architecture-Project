LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;

-------------- ENTITY --------------------
ENTITY DIV_registers IS
	PORT( 
		MemRead		: IN	STD_LOGIC;
		clock		: IN 	STD_LOGIC;
		reset		: IN 	STD_LOGIC;
		MemWrite	: IN	STD_LOGIC;
		CS_dividend,CS_divisor,CS_quotient,CS_remainder 	: IN 	STD_LOGIC;
		Data		: INOUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		dividend    : OUT  STD_LOGIC_VECTOR(31 downto 0); -- 32-bit dividend
        divisor     : OUT  STD_LOGIC_VECTOR(31 downto 0); -- 32-bit divisor
        quotient    : IN STD_LOGIC_VECTOR(31 downto 0); -- 32-bit quotient
        remainder   : IN STD_LOGIC_VECTOR(31 downto 0);  -- 32-bit remainder
		start       : OUT  STD_LOGIC;
		DIVIFG      : OUT  STD_LOGIC;
		clr_ifg		: IN STD_LOGIC;
		done        : IN STD_LOGIC
		);
END DIV_registers;

------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF DIV_registers IS
	SIGNAL D_Latch_dividend 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL D_Latch_divisor  	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL D_Latch_quotient 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL D_Latch_remainder	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL COUNTER_start     : INTEGER := 0;
	SIGNAL start_temp        : STD_LOGIC := '0';

BEGIN
	PROCESS(clock, reset)
	BEGIN
		IF (reset = '1') THEN
			D_Latch_dividend  <= (others => '0');
			D_Latch_divisor   <= (others => '0');
			D_Latch_quotient  <= (others => '0');
			D_Latch_remainder <= (others => '0');
			start <= '0';
			COUNTER_start <= 0;
			start_temp <= '0';
			DIVIFG <= '0';
		ELSIF (rising_edge(clock)) THEN
			IF (MemWrite = '1' AND CS_dividend = '1') THEN
				D_Latch_dividend <= Data;	
			ELSIF (MemWrite = '1' AND CS_divisor = '1') THEN
				D_Latch_divisor <= Data;
				start_temp <= '1'; -- Trigger the start signal
			ELSIF (MemWrite = '1' AND CS_quotient = '1') THEN
				D_Latch_quotient <= Data;
			ELSIF (MemWrite = '1' AND CS_remainder = '1') THEN
				D_Latch_remainder <= Data;	
			ELSIF done = '1' THEN
				D_Latch_quotient <= quotient;
				D_Latch_remainder <= remainder;
				DIVIFG <= '1';
			ELSIF (clr_ifg = '0') THEN
				DIVIFG <= '0';
			END IF;

			-- Handle the start signal
			IF start_temp = '1' THEN
				IF COUNTER_start < 2 THEN
					COUNTER_start <= COUNTER_start + 1;
					start <= '1';
				ELSE
					start <= '0';
					COUNTER_start <= 0; -- Reset counter
					start_temp <= '0'; -- Reset temporary start
				END IF;
			ELSE
				start <= '0';
			END IF;
		END IF;
	END PROCESS;

	Data <=	D_Latch_dividend  WHEN (MemRead = '1' AND CS_dividend  = '1') 	ELSE 
			D_Latch_divisor   WHEN (MemRead = '1' AND CS_divisor   = '1') 	ELSE 
			D_Latch_quotient  WHEN (MemRead = '1' AND CS_quotient  = '1') 	ELSE 
			D_Latch_remainder WHEN (MemRead = '1' AND CS_remainder = '1') 	ELSE 
			(others => 'Z'); 
			
	dividend  <= D_Latch_dividend ; 
	divisor   <= D_Latch_divisor  ;
	
END structure;
