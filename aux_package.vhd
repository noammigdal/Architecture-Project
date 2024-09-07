LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

package aux_package is
    --------------------------------------------------------
    -- Component Declarations
    --------------------------------------------------------
Component GPIO_Top IS
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
END Component;

Component HexDecode IS
  PORT    (Binary_vec: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		  HEX_out: OUT STD_LOGIC_VECTOR(6 downto 0));
END Component;

Component SevenSegDecoder IS
  GENERIC (SegmentSize	: integer := 7);
  PORT (data		: in STD_LOGIC_VECTOR (3 DOWNTO 0);
		seg   		: out STD_LOGIC_VECTOR (SegmentSize-1 downto 0));
END Component;

Component GPIO_Addr_Decoder IS
	PORT( 
		reset 												: IN	STD_LOGIC;
		AddressBus											: IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
		CS_HEX0,CS_HEX1,CS_HEX2,CS_HEX3,CS_HEX4,CS_HEX5		: OUT 	STD_LOGIC;
		CS_LEDR,CS_SW										: OUT 	STD_LOGIC
		);
END Component;

Component GPIO_HEX IS

	PORT( 
		MemRead		: IN	STD_LOGIC;
		clock		: IN 	STD_LOGIC;
		reset		: IN 	STD_LOGIC;
		MemWrite	: IN	STD_LOGIC;
		ChipSelect	: IN 	STD_LOGIC;
		Data		: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		GPOutput	: OUT	STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
END Component;

Component GPIO_LEDR IS

	PORT( 
		MemRead		: IN	STD_LOGIC;
		clock		: IN 	STD_LOGIC;
		reset		: IN 	STD_LOGIC;
		MemWrite	: IN	STD_LOGIC;
		ChipSelect	: IN 	STD_LOGIC;
		Data		: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		GPOutput	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
END Component;

Component GPIO_SW IS
	PORT( 
		MemRead		: IN	STD_LOGIC;
		ChipSelect	: IN 	STD_LOGIC;
		GPInput		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		Data		: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
END Component;



------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
  



Component BT_Top IS
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
END Component;

Component BT_Addr_Decoder IS
	PORT( 
		reset 												: IN	STD_LOGIC;
		AddressBus											: IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
		CS_BTCTL ,CS_BTCNT,CS_BTCCR0,CS_BTCCR1       		: OUT 	STD_LOGIC
		);
END Component;

Component BT_core IS
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
END Component;

Component BT_registers IS
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
END Component;

Component PWM_counter is 
    
	port (
	clk, ena,rst ,PWM_MODE: in std_logic;	
	BTCL0,BTCL1: in std_logic_vector (31 downto 0);
	PWM_o: out std_logic 
	);
end Component;



------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------



Component DIV_Top IS
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
END Component;


Component DIV_Addr_Decoder IS
	PORT( 
		reset 												: IN	STD_LOGIC;
		AddressBus											: IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
		CS_dividend,CS_divisor,CS_quotient,CS_remainder  	: OUT 	STD_LOGIC
		);
END Component;

Component DIV_operation is
    Port (
        clk        : IN  STD_LOGIC;
        rst        : IN  STD_LOGIC;
        start      : IN  STD_LOGIC;
        dividend   : IN  STD_LOGIC_VECTOR(31 downto 0); -- 32-bit dividend
        divisor    : IN  STD_LOGIC_VECTOR(31 downto 0); -- 32-bit divisor
        quotient   : OUT STD_LOGIC_VECTOR(31 downto 0); -- 32-bit quotient
        remainder  : OUT STD_LOGIC_VECTOR(31 downto 0); -- 32-bit remainder
        done       : OUT STD_LOGIC
    );
END Component;

Component DIV_registers IS
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
END Component;





------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------



Component Intr_Top IS
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
END Component;

Component Intr_Addr_Decoder IS
	PORT( 
		reset 												: IN	STD_LOGIC;
		AddressBus											: IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
		CS_IE ,CS_IFG,CS_TYPE       		                : OUT 	STD_LOGIC
		);
END Component;

Component Intr_registers IS

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
END Component;

 
 


------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------


 
 
Component MIPS IS
	GENERIC (	MemWidth	: INTEGER := 10;
				SIM 		: BOOLEAN := FALSE);
	PORT(
		clock						  	: IN 				STD_LOGIC;
		reset						  	: IN 				STD_LOGIC;
		-- Output for Simulator: --------------------------------------------------------------
		PC								: OUT   			STD_LOGIC_VECTOR(  9 DOWNTO 0 );
		ALU_result_out					: OUT 				STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		read_data_1_out					: OUT 				STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		read_data_2_out					: OUT 				STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		write_data_out					: OUT 				STD_LOGIC_VECTOR( 31 DOWNTO 0 );	
   	  	Instruction_out					: OUT 				STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Branch_out						: OUT 				STD_LOGIC ;
		Zero_out						: OUT 				STD_LOGIC ;
		Memwrite_out					: OUT 				STD_LOGIC ; 
		Regwrite_out					: OUT 				STD_LOGIC ;
		-- Output for Periph: ------------------------------------------------------------------
		MemReadBus					  	: OUT 				STD_LOGIC;
		MemWriteBus					  	: OUT 				STD_LOGIC;
		AddressBus					  	: OUT				STD_LOGIC_VECTOR(31 DOWNTO 0);
		DataBus						  	: INOUT				STD_LOGIC_VECTOR(31 DOWNTO 0);
		INTR						  	: IN 				STD_LOGIC;
		INTA     				  	  	: OUT 				STD_LOGIC;
		GIE					   	      	: OUT				STD_LOGIC
		);

END Component;


------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------

Component periph_core IS
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
END Component;

------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------


COMPONENT PLL IS
	port(
		refclk   : in  std_logic := '0'; --  refclk.clk
		rst      : in  std_logic := '0'; --   reset.reset
		outclk_0 : out std_logic         -- outclk0.clk
	);
END COMPONENT;


------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------

end aux_package;
 