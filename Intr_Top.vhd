LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY Intr_Top IS
	PORT( 
		clock						  : IN 	STD_LOGIC;
		reset						  : IN 	STD_LOGIC;
		MemReadBus					  : IN 	STD_LOGIC;
		MemWriteBus					  : IN 	STD_LOGIC;
		AddressBus					  : IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
		DataBus						  : INOUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		--------------- INTERRUPT SOURCES ----------
		KEY1, KEY2, KEY3              : IN 	STD_LOGIC;
		DIVIFG, BTIFG, IntrTx, IntrRx : IN 	STD_LOGIC;
		IFG_STATUS_ERROR              : IN STD_LOGIC;
		------------------- INTERRUPT INDICATION ------
		CLR_IRQ_OUT	: OUT	STD_LOGIC_VECTOR(6 DOWNTO 0);
		---------------CPU INTERFACE ---------------
		INTR						  : OUT	STD_LOGIC;
		INTA						  : IN	STD_LOGIC;
		GIE			                  : IN	STD_LOGIC

		);
END Intr_Top;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF Intr_Top IS
	---- CONTROL SIGNALS ----
SIGNAL CS_IE ,CS_IFG,CS_TYPE       		: 	STD_LOGIC;
SIGNAL IntrSrc : STD_LOGIC_VECTOR(6 DOWNTO 0);


BEGIN	

IntrAddr_Decoder: Intr_Addr_Decoder
	PORT MAP( 
		reset  => reset,				
		AddressBus => AddressBus,									
		CS_IE => CS_IE,
		CS_IFG => CS_IFG,
		CS_TYPE => CS_TYPE      
		);
		
		
Intrregisters: Intr_registers  

	PORT MAP( 
		MemRead => MemReadBus, 
		clock => clock,  
		reset => reset, 
		MemWrite => MemWriteBus,
		CS_IE => CS_IE,
		CS_IFG => CS_IFG,
		CS_TYPE => CS_TYPE,  
		Data => DataBus,
		IntrSrc => IntrSrc,		
		INTR => INTR, 		
		INTA => INTA, 		
		CLR_IRQ_OUT =>	CLR_IRQ_OUT,
		IFG_STATUS_ERROR => IFG_STATUS_ERROR,
		GIE	=>	GIE
		);
				
	IntrSrc	<= DIVIFG & (NOT KEY3) & (NOT KEY2) & (NOT KEY1) & BTIFG & IntrTx & IntrRx;
	


END structure;