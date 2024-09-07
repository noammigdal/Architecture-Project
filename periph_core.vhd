LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY periph_core IS
	PORT( 
		clock						  : IN 	STD_LOGIC;
		reset						  : IN 	STD_LOGIC;
		------------------------- CPU BUS -----------------
		MemReadBus					  : IN 	STD_LOGIC;
		MemWriteBus					  : IN 	STD_LOGIC;
		AddressBus					  : IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
		DataBus						  : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		-------------- CPU INTERRUPT SERVICE ROUTINE -------------
		INTR						  : OUT	STD_LOGIC;
		INTA						  : IN	STD_LOGIC;  
		GIE							  : IN	STD_LOGIC;
		------------------------- BASIC TIMER ---------------------
		PWMout						  : OUT STD_LOGIC;
		------------------------- GPIO --------------------
		KEY1, KEY2, KEY3			  : IN	STD_LOGIC;
		HEX0, HEX1, HEX2,HEX3, HEX4, HEX5	: OUT	STD_LOGIC_VECTOR(6 DOWNTO 0);
		LEDR			          	  : OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		Switches			          : IN	STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
END periph_core;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF periph_core IS
	SIGNAL BTIFG  		                    :	STD_LOGIC;
	SIGNAL DIVIFG							:	STD_LOGIC;
	--SIGNAL IntrTx, IntrRx					:	STD_LOGIC;
	--SIGNAL IFG_STATUS_ERROR               :   STD_LOGIC;
	SIGNAL	CLR_IRQ_OUT 					:	STD_LOGIC_VECTOR(6 DOWNTO 0);
	
	
BEGIN	
	
	GPIO: GPIO_TOP
	
		PORT MAP( 
		clock => clock,						 
		reset => reset,						  
		MemReadBus => MemReadBus,					 
		MemWriteBus => MemWriteBus,					  
		AddressBus => AddressBus,					  
		DataBus	=>	DataBus,				 
		HEX0 => HEX0,
		HEX1 => HEX1,
		HEX2 => HEX2,
		HEX3 => HEX3,
		HEX4 => HEX4,
		HEX5 => HEX5,
		LEDR  => LEDR,
		Switches =>	Switches				 
		);
	
	------------------------------------------------------

	BTTop: BT_Top

		PORT MAP(
		clock => clock,						
		reset => reset,						
		MemReadBus => MemReadBus,					
		MemWriteBus => MemWriteBus,						
		AddressBus => AddressBus,				
		DataBus	=>	DataBus,						
		BTIFG	=>	BTIFG,	
		clr_ifg => CLR_IRQ_OUT(2),		
		PWMout	=> 	PWMout			   
		);
		
	------------------------------------------------------
	
	DIVTop: DIV_Top

		PORT MAP(
		clock => clock,						
		reset => reset,
		MemReadBus => MemReadBus,					
		MemWriteBus => MemWriteBus,						
		AddressBus => AddressBus,				
		DataBus	=>	DataBus,						
		DIVIFG	=>	DIVIFG,
		clr_ifg	=> CLR_IRQ_OUT(6)
		);
		
				
	------------------------------------------------------
	
	IntrTop: Intr_Top
	
		PORT MAP( 
		clock => clock,	
		reset  => reset,				
		MemReadBus => MemReadBus,				
		MemWriteBus => MemWriteBus,
		AddressBus => AddressBus,	
		DataBus	=>	DataBus,
		KEY1 => KEY1,
		KEY2 => KEY2,
		KEY3 => KEY3,
		DIVIFG  => DIVIFG,
		BTIFG  => BTIFG,
		IntrTx => '0', -- IntrTx,
		IntrRx => '0', -- IntrRx, 
		IFG_STATUS_ERROR => '0', -- IFG_STATUS_ERROR,
		CLR_IRQ_OUT	 => CLR_IRQ_OUT,
		INTR =>	INTR,	
		INTA =>	INTA,
		GIE	 => GIE
		);
		
END structure;