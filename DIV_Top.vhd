LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY DIV_Top IS
	PORT( 
		clock						  : IN 	STD_LOGIC;
		reset						  : IN 	STD_LOGIC;
		MemReadBus					  : IN 	STD_LOGIC;
		MemWriteBus					  : IN 	STD_LOGIC;
		AddressBus					  : IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
		DataBus						  : INOUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
		DIVIFG						  : OUT 	STD_LOGIC;
		clr_ifg     				  : IN 	STD_LOGIC
		);
END DIV_Top;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF DIV_Top IS
	---- CONTROL SIGNALS ----
	SIGNAL CS_dividend,CS_divisor,CS_quotient,CS_remainder      :   STD_LOGIC; 
	SIGNAL dividend,divisor,quotient,remainder      			:   STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL start,done       									:   STD_LOGIC;

BEGIN	

DIVAddr_Decoder: DIV_Addr_Decoder 
	PORT MAP(
		reset       => reset, 												
		AddressBus  => AddressBus,											
		CS_dividend => CS_dividend,
		CS_divisor  => CS_divisor,
		CS_quotient => CS_quotient,
		CS_remainder=> CS_remainder
		);

DIVregisters: DIV_registers  
	PORT MAP( 
		MemRead => MemReadBus, 
		clock => clock, 
		reset => reset, 
		MemWrite => MemWriteBus,
		CS_dividend => CS_dividend,
		CS_divisor  => CS_divisor,
		CS_quotient => CS_quotient,
		CS_remainder=> CS_remainder,
		Data => DataBus,
		dividend => dividend,
        divisor => divisor,
        quotient => quotient,
        remainder => remainder,
		start => start,
		DIVIFG => DIVIFG,
		clr_ifg => clr_ifg,
		done => done     
		);
	
	
DIVoperation: DIV_operation
    Port MAP (
        clk => clock,
        rst => reset, 
        start => start,
        dividend => dividend,
        divisor => divisor,
        quotient => quotient,
        remainder => remainder,
        done => done
		);
		
END structure;