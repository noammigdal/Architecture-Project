LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY project_Top IS
	PORT( 
		clk_i			  			   		: IN				STD_LOGIC;
		----------------------- Simulator --------------------------
		PC									: OUT   			STD_LOGIC_VECTOR(  9 DOWNTO 0 );
		ALU_result_out						: OUT 				STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		read_data_1_out						: OUT 				STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		read_data_2_out						: OUT 				STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		write_data_out						: OUT 				STD_LOGIC_VECTOR( 31 DOWNTO 0 );	
     	Instruction_out						: OUT 				STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Branch_out							: OUT 				STD_LOGIC ;
		Zero_out							: OUT 				STD_LOGIC ;
		Memwrite_out						: OUT 				STD_LOGIC ; 
		Regwrite_out						: OUT 				STD_LOGIC ;
		------------------------ BASIC TIMER -----------------------
		PWMout						   		: OUT 				STD_LOGIC;
		------------------------- GPIO -----------------------------
		KEY0, KEY1, KEY2, KEY3			    : IN				STD_LOGIC;
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5  : OUT				STD_LOGIC_VECTOR(6 DOWNTO 0);
		LEDR			          	   		: OUT				STD_LOGIC_VECTOR(7 DOWNTO 0);
		Switches			           		: IN				STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
END project_Top;
------------ ARCHITECTURE --------------------------------------------
ARCHITECTURE structure OF project_Top IS
	SIGNAL reset					  	  	: 					STD_LOGIC;   ---  not(key 0)
	SIGNAL MemReadBus,MemWriteBus		  	: 					STD_LOGIC;
	SIGNAL AddressBus					  	: 					STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL DataBus						  	: 					STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL INTR, INTA, GIE		  		  	: 					STD_LOGIC;
    SIGNAL pll_rst, clock					:					STD_LOGIC;       

BEGIN	
	reset <= NOT(KEY0);


	----------------------------------------------------------
							-- pll
	----------------------------------------------------------

	p0: PLL
	
	PORT MAP (
				refclk => clk_i,
				rst => pll_rst,
				outclk_0 => clock
	);
 pll_rst <= '0';	
 
	

	----------------------------------------------------------
							-- MIPS
	---------------------------------------------------------- 
	
	MIPS_Top: MIPS

		PORT MAP( 
		clock => clock,						 
		reset => reset,	
		PC => PC,
		ALU_result_out => ALU_result_out,
		read_data_1_out => read_data_1_out,
		read_data_2_out => read_data_2_out,
		write_data_out => write_data_out,
		Instruction_out => Instruction_out,
		Branch_out => Branch_out,
		Zero_out => Zero_out,
		Memwrite_out => Memwrite_out,
		Regwrite_out => Regwrite_out,
		MemReadBus => MemReadBus,					 
		MemWriteBus => MemWriteBus,					  
		AddressBus => AddressBus,					  
		DataBus	=>	DataBus,
		INTR => INTR,
		INTA => INTA,
		GIE => GIE
		);
	
	----------------------------------------------------------
							-- periph_core
	---------------------------------------------------------- 
	
	periphcore: periph_core

		PORT MAP(
		clock => clock,						
		reset => reset,						
		MemReadBus => MemReadBus,					
		MemWriteBus => MemWriteBus,						
		AddressBus => AddressBus(11 DOWNTO 0),				
		DataBus	=>	DataBus,
		INTR => INTR,
		INTA =>	INTA,
		GIE	=> GIE,
		PWMout => PWMout,
		KEY1 => KEY1,
		KEY2 => KEY2,
		KEY3 => KEY3,
		HEX0 => HEX0,
		HEX1 => HEX1,
		HEX2 => HEX2,
		HEX3 => HEX3,
		HEX4 => HEX4,
		HEX5 => HEX5,
		LEDR => LEDR,
		Switches => Switches
		);

	------------------------------------------------------
	
		
END structure;