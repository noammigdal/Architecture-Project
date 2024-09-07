--------------- Input Peripheral Module 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY BT_Top IS
	PORT( 
		clock						  : IN 	STD_LOGIC;
		reset						  : IN 	STD_LOGIC;
		MemReadBus					  : IN 	STD_LOGIC;
		MemWriteBus					  : IN 	STD_LOGIC;
		AddressBus					  : IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
		DataBus						  : INOUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		BTIFG						  : OUT 	STD_LOGIC;
		clr_ifg     				  : IN 	STD_LOGIC;
		PWMout					   	  : OUT	STD_LOGIC
		);
END BT_Top;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF BT_Top IS
	---- CONTROL SIGNALS ----
	SIGNAL CS_BTCTL, CS_BTCNT, CS_BTCCR0, CS_BTCCR1, BTCNT_wr : STD_LOGIC; 
	SIGNAL BTCTL : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL BTCNT, BTCNT_INT, BTCCR0, BTCCR1 :STD_LOGIC_VECTOR(31 DOWNTO 0); 
BEGIN	

BTAddr_Decoder: BT_Addr_Decoder

	PORT MAP( 
		reset => reset, 									
		AddressBus => AddressBus,
		CS_BTCTL => CS_BTCTL,
		CS_BTCNT => CS_BTCNT,
		CS_BTCCR0 => CS_BTCCR0,
		CS_BTCCR1 => CS_BTCCR1
		);
	
BTregisters: BT_registers  

	PORT MAP( 
		MemRead => MemReadBus,         		
		clock => clock,             		
		reset => reset,           		
		clr_ifg => clr_ifg,           
		MemWrite => MemWriteBus,
		CS_BTCTL => CS_BTCTL,
		CS_BTCNT => CS_BTCNT,
		CS_BTCCR0 => CS_BTCCR0,
		CS_BTCCR1 => CS_BTCCR1,
		Data => DataBus,		
		BTCTL => BTCTL, 
		BTCNT => BTCNT,	
		BTCNT_wr => BTCNT_wr,
		BTCNT_INT => BTCNT_INT,
		BTCCR0 => BTCCR0, 
		BTCCR1 => BTCCR1
		);

BTcore: BT_core
	PORT MAP( 
		MCLK => clock,
		reset => reset,	
		clr_ifg => clr_ifg, 
		BTCTL => BTCTL, 
		BTCNT => BTCNT,
		BTCNT_wr => BTCNT_wr,
		BTCCR0 => BTCCR0,
		BTCCR1 => BTCCR1,
		BTCNT_INT => BTCNT_INT,   
		BTIFG => BTIFG,	
		PWMout => PWMout
		);
		

END structure;