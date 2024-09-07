--------------- Input Peripheral Module 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY GPIO_Top IS

	PORT( 
		clock						  : IN 	STD_LOGIC;
		reset						  : IN 	STD_LOGIC;
		MemReadBus					  : IN 	STD_LOGIC;
		MemWriteBus					  : IN 	STD_LOGIC;
		AddressBus					  : IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
		DataBus						  : INOUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : OUT	STD_LOGIC_VECTOR(6 DOWNTO 0);
		LEDR						  : OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		Switches					  : IN	STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
END GPIO_Top;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF GPIO_Top IS
	---- CONTROL SIGNALS ----
	SIGNAL CS_LEDR,CS_HEX0,CS_HEX1,CS_HEX2,CS_HEX3,CS_HEX4,CS_HEX5,CS_SW	: STD_LOGIC;
	
	
BEGIN	

GPIO_DECODER: 	GPIO_Addr_Decoder 
	PORT MAP(	reset		=> reset,
				AddressBus => AddressBus,
				CS_HEX0 => CS_HEX0,
				CS_HEX1 => CS_HEX1,
				CS_HEX2 => CS_HEX2,
				CS_HEX3 => CS_HEX3,
				CS_HEX4 => CS_HEX4,
				CS_HEX5 => CS_HEX5,
				CS_LEDR => CS_LEDR,
				CS_SW   => CS_SW								
			);



LEDR1:	GPIO_LEDR
	PORT MAP(	MemRead		=> MemReadBus,
				clock 		=> clock,
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				ChipSelect	=> CS_LEDR,
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> LEDR
			);
	
	
HEX0_symbol:	GPIO_HEX
	PORT MAP(	MemRead		=> MemReadBus,
				clock 		=> clock,	
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				ChipSelect	=> CS_HEX0,
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> HEX0
			);
			
HEX1_symbol:	GPIO_HEX
	PORT MAP(	MemRead		=> MemReadBus,
				clock 		=> clock,
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				ChipSelect	=> CS_HEX1,
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> HEX1
			);
	
HEX2_symbol:	GPIO_HEX
	PORT MAP(	MemRead		=> MemReadBus,
				clock 		=> clock,
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				ChipSelect	=> CS_HEX2,
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> HEX2
			);
	
HEX3_symbol:	GPIO_HEX
	PORT MAP(	MemRead		=> MemReadBus,
				clock 		=> clock,
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				ChipSelect	=> CS_HEX3,
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> HEX3
			);
			
HEX4_symbol:	GPIO_HEX
	PORT MAP(	MemRead		=> MemReadBus,
				clock 		=> clock,
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				ChipSelect	=> CS_HEX4,
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> HEX4
			);
			
HEX5_symbol:	GPIO_HEX
	PORT MAP(	MemRead		=> MemReadBus,
				clock 		=> clock,
				reset		=> reset,
				MemWrite	=> MemWriteBus,
				ChipSelect	=> CS_HEX5,
				Data		=> DataBus(7 DOWNTO 0),
				GPOutput	=> HEX5
			);
	
SWITCH_symbol:		GPIO_SW
	PORT MAP(	MemRead		=> MemReadBus,
				ChipSelect	=> CS_SW,
				Data		=> DataBus(7 DOWNTO 0),
				GPInput		=> Switches
			);

END structure;