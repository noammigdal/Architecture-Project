

--------------- Output Peripheral Module 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY Intr_registers IS

	PORT( 
		MemRead		: IN	STD_LOGIC;
		clock		: IN 	STD_LOGIC;
		reset		: IN 	STD_LOGIC;
		MemWrite	: IN	STD_LOGIC;
		CS_IE ,CS_IFG,CS_TYPE 	: IN 	STD_LOGIC;
		Data		: INOUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		IntrSrc		: IN	STD_LOGIC_VECTOR(6 DOWNTO 0);
		INTR		: OUT	STD_LOGIC;
		INTA		: IN	STD_LOGIC;
		CLR_IRQ_OUT	: OUT	STD_LOGIC_VECTOR(6 DOWNTO 0);
		IFG_STATUS_ERROR : IN STD_LOGIC;
		GIE			: IN	STD_LOGIC
				);
END Intr_registers;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF Intr_registers IS
	SIGNAL D_Latch_IE	: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL D_Latch_IFG	: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL D_Latch_TYPE	: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL IE_reg		: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL IFG_reg		: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL TYPE_reg	    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL IRQ	    	: STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL CLR_IRQ		: STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL IRQ_STATUS   : STD_LOGIC;
	SIGNAL CLR_IRQ_STATUS : STD_LOGIC;
	SIGNAL INTA_Delayed : STD_LOGIC;
	
BEGIN
	PROCESS(clock,reset)
	BEGIN
	IF (reset = '1') THEN
		D_Latch_IE  <= X"00";
		D_Latch_IFG  <= X"00";
		
	ELSIF (rising_edge(clock)) THEN
		IF (MemWrite = '1' AND CS_IE = '1') THEN
			D_Latch_IE <= '0' & Data(6 DOWNTO 0);
		ELSIF (MemWrite = '1' AND CS_IFG = '1') THEN
			D_Latch_IFG <= '0' & Data(6 DOWNTO 0);
		ELSE D_Latch_IFG <= '0' & (IRQ AND IE_reg(6 DOWNTO 0));
		END IF;
	END IF;
	END PROCESS;

	Data	<=	X"000000"&IE_reg WHEN (MemRead = '1' AND CS_IE = '1') ELSE 
				X"000000"&IFG_reg WHEN (MemRead = '1' AND CS_IFG = '1') 	ELSE
				X"000000"&TYPE_reg WHEN (MemRead = '1' AND CS_TYPE = '1') OR (INTA = '0' AND MemRead = '0')	ELSE 
				(others => 'Z'); 
				
				
	IE_reg <= D_Latch_IE; 
	IFG_reg <= D_Latch_IFG; 
	TYPE_reg	<= 	X"00" WHEN reset  = '1' ELSE -- main
					X"04" WHEN (IRQ_STATUS = '1' AND IE_reg(0) = '1') ELSE  -- Uart Status Error
					X"08" WHEN IFG_reg(0) = '1' ELSE  	-- Uart RX
					X"0C" WHEN IFG_reg(1) = '1' ELSE  	-- Uart TX
					X"10" WHEN IFG_reg(2) = '1' ELSE  	-- Basic timer
					X"14" WHEN IFG_reg(3) = '1' ELSE  	-- KEY1
					X"18" WHEN IFG_reg(4) = '1' ELSE	-- KEY2
					X"1C" WHEN IFG_reg(5) = '1' ELSE	-- KEY3
					X"20" WHEN IFG_reg(6) = '1' ELSE	-- DIVIDER
			(OTHERS => 'Z');
	

				
PROCESS (clock, IFG_reg) BEGIN 
	IF (rising_edge(CLOCK))     THEN
		IF     (IFG_reg(0) = '1' OR
				IFG_reg(1) = '1' OR
				IFG_reg(2) = '1' OR	
				IFG_reg(3) = '1' OR 
				IFG_reg(4) = '1' OR 
				IFG_reg(5) = '1' OR 
				IFG_reg(6) = '1') THEN
			INTR <= GIE;
		ELSE 
			INTR <= '0';
		END IF;
	END IF;
END PROCESS;


------------ UART STATUS ---------------
PROCESS (clock, reset, CLR_IRQ_STATUS, IFG_STATUS_ERROR)
BEGIN
	IF (reset = '1') THEN
		IRQ_STATUS <= '0';
	ELSIF CLR_IRQ_STATUS = '0' THEN
		IRQ_STATUS <= '0';
	ELSIF (rising_edge(clock)) THEN
		IF IFG_STATUS_ERROR = '1' THEN 
		IRQ_STATUS <= '1';
		END IF;	
	END IF;
END PROCESS;

------------ RX ---------------
PROCESS (clock, reset, CLR_IRQ(0), IntrSrc(0))
BEGIN
	IF (reset = '1') THEN
		IRQ(0) <= '0';
	ELSIF CLR_IRQ(0) = '0' THEN
		IRQ(0) <= '0';
	ELSIF (rising_edge(clock)) THEN
		IF IntrSrc(0) = '1' THEN 
		IRQ(0) <= '1';
		END IF;
	END IF;
END PROCESS;
------------ TX ---------------
PROCESS (clock, reset, CLR_IRQ(1), IntrSrc(1))
BEGIN
	IF (reset = '1') THEN
		IRQ(1) <= '0';
	ELSIF CLR_IRQ(1) = '0' THEN
		IRQ(1) <= '0';
	ELSIF (rising_edge(clock)) THEN
		IF IntrSrc(1) = '1' THEN 
		IRQ(1) <= '1';
		END IF;
	END IF;
END PROCESS;
------------ BTIMER ---------------
PROCESS (clock, reset, CLR_IRQ(2), IntrSrc(2))
BEGIN
	IF (reset = '1') THEN
		IRQ(2) <= '0';
	ELSIF CLR_IRQ(2) = '0' THEN
		IRQ(2) <= '0';
	ELSIF (rising_edge(clock)) THEN
		IF IntrSrc(2) = '1' THEN 
		IRQ(2) <= '1';
		END IF;
	END IF;
END PROCESS;
------------ KEY1 ---------------
PROCESS (clock, reset, CLR_IRQ(3), IntrSrc(3))
BEGIN
	IF (reset = '1') THEN
		IRQ(3) <= '0';
	ELSIF CLR_IRQ(3) = '0' THEN
		IRQ(3) <= '0';
	ELSIF (rising_edge(clock)) THEN
		IF IntrSrc(3) = '1' THEN 
		IRQ(3) <= '1';
		END IF;
	END IF;
END PROCESS;
------------ KEY2 ---------------
PROCESS (clock, reset, CLR_IRQ(4), IntrSrc(4))
BEGIN
	IF (reset = '1') THEN
		IRQ(4) <= '0';
	ELSIF CLR_IRQ(4) = '0' THEN
		IRQ(4) <= '0';
	ELSIF (rising_edge(clock)) THEN
		IF IntrSrc(4) = '1' THEN 
		IRQ(4) <= '1';
		END IF;
	END IF;
END PROCESS;
------------ KEY3 ---------------
PROCESS (clock, reset, CLR_IRQ(5), IntrSrc(5))
BEGIN
	IF (reset = '1') THEN
		IRQ(5) <= '0';
	ELSIF CLR_IRQ(5) = '0' THEN
		IRQ(5) <= '0';
	ELSIF (rising_edge(clock)) THEN
		IF IntrSrc(5) = '1' THEN 
		IRQ(5) <= '1';
		END IF;
	END IF;	
END PROCESS;
------------ DIVIDER ---------------
PROCESS (clock, reset, CLR_IRQ(6), IntrSrc(6))
BEGIN
	IF (reset = '1') THEN
		IRQ(6) <= '0';
	ELSIF CLR_IRQ(6) = '0' THEN
		IRQ(6) <= '0';
	ELSIF (rising_edge(clock)) THEN
		IF IntrSrc(6) = '1' THEN 
		IRQ(6) <= '1';
		END IF;
	END IF;	
END PROCESS;


PROCESS (clock,reset) BEGIN
	IF (reset = '1') THEN
		INTA_Delayed <= '1'; -- INTA is active low
	ELSIF (rising_edge(clock)) THEN
		INTA_Delayed <= INTA;
	END IF;
END PROCESS;

-- Clear IRQ After Interrupt Ack recv (1 clock after)
CLR_IRQ(0) 		<= '0' WHEN (TYPE_reg = X"08" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';
CLR_IRQ(1) 		<= '0' WHEN (TYPE_reg = X"0C" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';
CLR_IRQ(2) 		<= '0' WHEN (TYPE_reg = X"10" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';
CLR_IRQ(3) 		<= '0' WHEN (TYPE_reg = X"14" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';
CLR_IRQ(4) 		<= '0' WHEN (TYPE_reg = X"18" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';
CLR_IRQ(5) 		<= '0' WHEN (TYPE_reg = X"1C" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';
CLR_IRQ(6) 		<= '0' WHEN (TYPE_reg = X"20" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';
CLR_IRQ_STATUS  <= '0' WHEN (TYPE_reg = X"04" AND INTA = '1' AND INTA_Delayed = '0') ELSE '1';


CLR_IRQ_OUT <= CLR_IRQ;







	
END structure;