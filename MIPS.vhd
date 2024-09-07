LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.all;
  
ENTITY MIPS IS
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

END MIPS;

ARCHITECTURE structure OF MIPS IS
	
	COMPONENT Ifetch
	GENERIC (	 MemWidth		: INTEGER;
				 SIM 			: BOOLEAN);
		PORT(	
			Instruction 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	PC_plus_4_out 		: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	Add_result 			: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			JumpAddr 			: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			next_PC_for_jr		: OUT 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	Branch 				: IN 	STD_LOGIC;
			bne					: IN 	STD_LOGIC;
			Jump 				: IN 	STD_LOGIC;
			Zero				: IN 	STD_LOGIC;
			PC_STOP				: IN 	STD_LOGIC;
			EN_PC_ISR			: IN 	STD_LOGIC;
			PC_ISR				: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0);
      		PC_out 				: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	clock, reset 		: IN 	STD_LOGIC
			);
	END COMPONENT; 

	COMPONENT Idecode
 	     	  	  PORT(	read_data_1		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );  
			read_data_2		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Instruction 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALU_result		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			RegWrite 		: IN 	STD_LOGIC;
			jal 			: IN 	STD_LOGIC;
			INTA			: IN 	STD_LOGIC;
			INTR			: IN 	STD_LOGIC;
			GIE				: OUT 	STD_LOGIC;
			MemtoReg 		: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			RegDst 			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			PC_plus_4_out   : IN    STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			next_PC_for_jr	: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			Sign_extend 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			clock,reset		: IN 	STD_LOGIC
			);
	END COMPONENT;

	COMPONENT control
	        PORT( 	
	Opcode 		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	Funct		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	RegDst 		: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	ALUSrc 		: OUT 	STD_LOGIC;
	MemtoReg 	: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	RegWrite 	: OUT 	STD_LOGIC;
	MemRead 	: OUT 	STD_LOGIC;
	MemWrite 	: OUT 	STD_LOGIC;
	Branch 		: OUT 	STD_LOGIC;
	bne			: OUT 	STD_LOGIC;
	Jump		: OUT	STD_LOGIC;
	jal 		: OUT 	STD_LOGIC;
	ALUop 		: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	clock, reset: IN 	STD_LOGIC
	);
	END COMPONENT;

	COMPONENT  Execute
   	     PORT(		Read_data_1 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				Read_data_2 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				Sign_extend 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				Funct			: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 ); 
				Opcode			: IN	STD_LOGIC_VECTOR( 5 DOWNTO 0);
				ALUOp 			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
				ALUSrc 			: IN 	STD_LOGIC;
				shamt			: IN	STD_LOGIC_VECTOR( 4 DOWNTO 0);
				Zero 			: OUT	STD_LOGIC;
				ALU_Result 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				JumpAddr		: OUT   STD_LOGIC_VECTOR( 7 DOWNTO 0 );
				Add_Result 		: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
				PC_plus_4 		: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
				clock, reset		: IN 	STD_LOGIC );
	END COMPONENT;


	COMPONENT dmemory
	    GENERIC (MemWidth	: INTEGER;
			 SIM 		: BOOLEAN);
	PORT(	read_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	address 			: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	   		MemRead, Memwrite 	: IN 	STD_LOGIC;
            clock,reset			: IN 	STD_LOGIC );
	END COMPONENT;


					-- declare signals used to connect VHDL components
	---SIGNAL clock			: STD_LOGIC;
	SIGNAL pll_rst 			: STD_LOGIC;
	SIGNAL PC_plus_4 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL read_data_1 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_Extend 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Add_result 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL ALU_result 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_MUX 	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALUSrc 			: STD_LOGIC;
	SIGNAL Branch 			: STD_LOGIC;
	SIGNAL RegDst 			: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL Regwrite 		: STD_LOGIC;
	SIGNAL Zero 			: STD_LOGIC;
	SIGNAL MemWrite 		: STD_LOGIC;
	SIGNAL MemtoReg 		: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL MemRead 			: STD_LOGIC;
	SIGNAL ALUop 			: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL Instruction		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL JumpAddr        	: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL Jump           	: STD_LOGIC;
	SIGNAL jal           	: STD_LOGIC;
	SIGNAL bne           	: STD_LOGIC;
	SIGNAL PC_STOP			: STD_LOGIC;
	SIGNAL EN_PC_ISR		: STD_LOGIC;
	SIGNAL INTA_temp		: STD_LOGIC;
	SIGNAL PC_ISR			: STD_LOGIC_VECTOR( 31 DOWNTO 0);
	SIGNAL DMemAddr			: STD_LOGIC_VECTOR( 31 DOWNTO 0);
	SIGNAL write_data_SIG	: STD_LOGIC_VECTOR( 31 DOWNTO 0);
	SIGNAL MemRead_Mem		: STD_LOGIC;
	SIGNAL MemWrite_Mem		: STD_LOGIC;
	SIGNAL next_PC_for_jr   : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	--SIGNAL INTR_cycle 		: STD_LOGIC;  
	 
	---------------------------------------------
	      
   
BEGIN
	MemRead_Mem  <= '1' WHEN ((MemRead  = '1' OR INTA_temp = '0') AND DMemAddr(11) = '0') ELSE '0';
	MemWrite_Mem <= '1' WHEN (MemWrite = '1' AND INTA_temp = '1'  AND DMemAddr(11) = '0') ELSE '0';
	MemReadBus	 <= '1' WHEN (MemRead  = '1' AND DMemAddr(11) = '1') ELSE '0';
	MemWriteBus	 <= '1' WHEN (MemWrite = '1' AND DMemAddr(11) = '1') ELSE '0';

	------------- Output for Periph: -------------------------
 

	AddressBus		<= DMemAddr;
	read_data_MUX	<= DataBus 		  	WHEN (DMemAddr(11) = '1' AND MemRead = '1') ELSE read_data; 
	write_data_SIG  	<= ALU_result( 31 DOWNTO 0 ) WHEN ( MemtoReg = "00" ) ELSE
						X"00000" & B"00" & PC_plus_4 WHEN ( MemtoReg = "10" ) ELSE
						read_data;
	--DataBus			<=  read_data_2 WHEN (Instruction(31 downto 26) = "101011" AND DMemAddr(11) = '1' AND MemWrite = '1') ELSE (OTHERS => 'Z');	 
	
	--write_data_SIG 	WHEN (ALU_Result(11) = '1' AND MemWrite = '1') ELSE (OTHERS => 'Z');
	DataBus			<= read_data_2 	WHEN (DMemAddr(11) = '1' AND MemWrite = '1') ELSE (OTHERS => 'Z');	
	
	------------- Output for display in Simulator: -------------

   Instruction_out 	<= Instruction;
   ALU_result_out 	<= ALU_result;
   read_data_1_out 	<= read_data_1;
   read_data_2_out 	<= read_data_2;
   write_data_out  	<= write_data_SIG;
   Branch_out 		<= Branch;
   Zero_out 		<= Zero;
   RegWrite_out 	<= RegWrite;
   MemWrite_out 	<= MemWrite;	
   pll_rst 			<= '0';
   INTA				<= INTA_temp;
   DMemAddr 		<= DataBus WHEN (INTA_temp = '0') ELSE ALU_Result;
   
------------------ interrupt handle --------------------------------
PROCESS (clock, INTR, reset)
		VARIABLE INTR_cycle : STD_LOGIC_VECTOR(1 DOWNTO 0);

	BEGIN
		IF reset = '1' THEN
			INTR_cycle 	:= "00";
			INTA_temp		<= '1';
			EN_PC_ISR	<= '0';
			PC_STOP		<= '0';
		
		ELSIF (rising_edge(clock)) THEN
			IF (INTR_cycle = "00") THEN
				IF (INTR = '1') THEN
					INTA_temp		<= '0';
					PC_STOP		<= '1';
					INTR_cycle	:= "01";					
				END IF;
				EN_PC_ISR	<= '0';
				
			ELSIF (INTR_cycle = "01") THEN		
				INTA_temp		<= '1';
				INTR_cycle 	:= "10";
								
			ELSE 
				--INTA_temp		<= '1';
				PC_ISR		<= read_data;
				EN_PC_ISR	<= '1';
				PC_STOP		<= '0';
				INTR_cycle 	:= "00";
			END IF;
		
		END IF;
	END PROCESS;










--PROCESS (clock, INTR, reset, INTR_cycle)


--	BEGIN
--		IF reset = '1' THEN
--			INTR_cycle 	<= '0';
--			INTA_temp		<= '1';
---			EN_PC_ISR	<= '0';
--			PC_STOP		<= '0';
--		
--		ELSIF (rising_edge(clock)) THEN
--			IF (INTR_cycle = '0') THEN
--				IF (INTR = '1') THEN
--					INTA_temp		<= '0';
--					PC_STOP		<= '1';
--					EN_PC_ISR	<= '0';
--					INTR_cycle	<= '1';					
--				END IF;
---				
--			ELSIF (INTR_cycle = '1') THEN		
--				INTA_temp		<= '1';
--				PC_STOP		<= '0';
--				EN_PC_ISR	<= '1';
--				PC_ISR		<= read_data;
--				INTR_cycle 	<= '0';
--				
--			END IF;
		
--		END IF;
--	END PROCESS;
--------------------------------------------------------------------				
 
IFE : Ifetch
	GENERIC MAP(MemWidth => MemWidth,
					 SIM => SIM )
	PORT MAP (
				Instruction 	=> Instruction,
    	    	PC_plus_4_out 	=> PC_plus_4,
				Add_result 		=> Add_result,
				JumpAddr 		=> JumpAddr,
				Branch 			=> Branch,
				bne				=> bne,
				Jump			=> Jump,
				next_PC_for_jr  => next_PC_for_jr,
				Zero 			=> Zero,
				PC_STOP			=> PC_STOP,
				EN_PC_ISR		=> EN_PC_ISR,
				PC_ISR			=> PC_ISR,
				PC_out 			=> PC,        		
				clock 			=> clock,  
				reset 			=> reset
				);

   ID : Idecode
   	PORT MAP (	
				read_data_1 	=> read_data_1,
        		read_data_2 	=> read_data_2,
        		Instruction 	=> Instruction,
        		read_data 		=> read_data_MUX,
				ALU_result 		=> ALU_result,
				RegWrite 		=> RegWrite,
				jal				=> jal,
				INTA			=> INTA_temp,
				INTR			=> INTR,
				GIE				=> GIE,
				MemtoReg 		=> MemtoReg,
				RegDst 			=> RegDst,
				PC_plus_4_out	=> PC_plus_4,
				next_PC_for_jr  => next_PC_for_jr,
				Sign_extend 	=> Sign_extend,
        		clock 			=> clock,  
				reset 			=> reset
				);


   CTL:   control
	PORT MAP (
				Opcode 			=> Instruction( 31 DOWNTO 26 ),
				Funct			=> Instruction( 5 DOWNTO 0 ),
				RegDst 			=> RegDst,
				ALUSrc 			=> ALUSrc,
				MemtoReg 		=> MemtoReg,
				RegWrite 		=> RegWrite,
				MemRead 		=> MemRead,
				MemWrite 		=> MemWrite,
				Branch 			=> Branch,
				bne				=> bne,
				Jump			=> Jump,
				jal				=> jal,
				ALUop 			=> ALUop,
            	clock 			=> clock,
				reset 			=> reset
				);

   EXE:  Execute
   	PORT MAP (
				Read_data_1 	=> read_data_1,
             	Read_data_2 	=> read_data_2,
				Sign_extend 	=> Sign_extend,
                Funct			=> Instruction( 5 DOWNTO 0 ),
				Opcode			=> Instruction( 31 DOWNTO 26 ),
				shamt			=> Instruction( 10 DOWNTO 6),
				ALUOp 			=> ALUop,
				ALUSrc 			=> ALUSrc,
				Zero 			=> Zero,
          		ALU_Result		=> ALU_Result,
				JumpAddr		=> JumpAddr,
				Add_Result 		=> Add_Result,
				PC_plus_4		=> PC_plus_4,
           		clock			=> clock,
				Reset			=> reset
				);

   MEM:  dmemory
    GENERIC MAP(		MemWidth 		=> MemWidth, SIM => SIM)
	PORT MAP (
				read_data 		=> read_data,
				address 		=> DMemAddr (9 DOWNTO 0),
				write_data 		=> read_data_2,
				MemRead 		=> MemRead_Mem, 
				Memwrite 		=> MemWrite_Mem, 
                clock 			=> clock,  
				reset 			=> reset
				);
	


	
END structure;


