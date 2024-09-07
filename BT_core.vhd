--------------- Basic Timer Module 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY BT_core IS
	PORT( 
		MCLK	: IN 	STD_LOGIC;
		reset	: IN 	STD_LOGIC;
		BTCTL	: IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
		BTCNT 	: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		BTCNT_wr: IN	STD_LOGIC;
		BTCCR0	: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		BTCCR1	: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		clr_ifg : IN 	STD_LOGIC;
		BTCNT_INT:OUT   STD_LOGIC_VECTOR(31 DOWNTO 0);
		BTIFG	: OUT 	STD_LOGIC;
		PWMout	: OUT	STD_LOGIC
		);
END BT_core ;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF BT_core  IS
	SIGNAL BT_CLK		: STD_LOGIC;
	SIGNAL CLK_CNT	    : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL BTCNT_temp	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	ALIAS BTIPx		IS BTCTL(2 DOWNTO 0);
	ALIAS BTSSEL	IS BTCTL(4 DOWNTO 3);
	ALIAS BTHOLD	IS BTCTL(5);
	ALIAS BTOUTEN	IS BTCTL(6);
	ALIAS BTOUTMD	IS BTCTL(7);

	
BEGIN

	PROCESS (MCLK,reset,BTSSEL) BEGIN
		IF reset = '1' THEN
			CLK_CNT <= "000";
		ELSIF (rising_edge(MCLK)) THEN
				CLK_CNT <= CLK_CNT + '1';
		END IF;

	END PROCESS;

	BT_CLK	<= MCLK WHEN (BTSSEL = "00") ELSE
		  CLK_CNT(0) WHEN (BTSSEL = "01") ELSE
		  CLK_CNT(1) WHEN (BTSSEL = "10") ELSE
		  CLK_CNT(2) WHEN (BTSSEL = "11");  
	
	
	PROCESS (BT_CLK,reset,BTIPx,clr_ifg)
	BEGIN
		IF (reset = '1' OR clr_ifg = '0') THEN
			BTCNT_temp <= X"00000000";
		ELSIF (rising_edge(BT_CLK))  THEN
			IF (BTCNT_wr = '1') THEN	
					BTCNT_temp <= BTCNT;
					
			ELSIF (BTHOLD = '0') THEN
					BTCNT_temp <= BTCNT_temp + '1';
			
			END IF;	
		END IF;

	END PROCESS;
	
	WITH BTIPx SELECT BTIFG <= 
		BTCNT_temp(25)	WHEN	"111",
		BTCNT_temp(23) 	WHEN	"110",
		BTCNT_temp(19) 	WHEN	"101",
		BTCNT_temp(15) 	WHEN	"100",
		BTCNT_temp(11) 	WHEN	"011",
		BTCNT_temp(7) 	WHEN	"010",
		BTCNT_temp(3) 	WHEN	"001", 
		BTCNT_temp(0) 	WHEN	"000",
		'0'		WHEN	OTHERS; 
	
	BTCNT_INT <= BTCNT_temp;
		
	
PWM: PWM_counter
	PORT MAP(	clk		 => BT_CLK,
				ena 	 => BTOUTEN,
				rst		 => reset,
				PWM_MODE => BTOUTMD,
				BTCL0	 => BTCCR0,
				BTCL1	 => BTCCR1,
				PWM_o	 => PWMout
			);
		
END structure;