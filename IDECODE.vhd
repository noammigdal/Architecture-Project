LIBRARY IEEE; 			
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Idecode IS
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
END Idecode;


ARCHITECTURE behavior OF Idecode IS
TYPE register_file IS ARRAY ( 0 TO 31 ) OF STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL register_array				: register_file;
	SIGNAL write_register_address 		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_data					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL PC_plus_4_temp				: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL read_register_1_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL read_register_2_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_register_address_1		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_register_address_0		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL Instruction_immediate_value	: STD_LOGIC_VECTOR( 15 DOWNTO 0 );
	SIGNAL opcode						: STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	SIGNAL Funct						: STD_LOGIC_VECTOR( 5 DOWNTO 0 );

BEGIN
	read_register_1_address 	<= Instruction( 25 DOWNTO 21 );
   	read_register_2_address 	<= Instruction( 20 DOWNTO 16 );
   	write_register_address_1	<= Instruction( 15 DOWNTO 11 );
   	write_register_address_0 	<= Instruction( 20 DOWNTO 16 );
   	Instruction_immediate_value <= Instruction( 15 DOWNTO 0 );
	opcode						<= Instruction( 31 DOWNTO 26);
	Funct						<= Instruction( 5 DOWNTO 0);
	
					-- Read Register 1 Operation
	read_data_1 <= register_array( CONV_INTEGER( read_register_1_address ) );
	
					-- Read Register 2 Operation
	read_data_2 <= register_array( CONV_INTEGER( read_register_2_address ) );


	write_register_address <= 	write_register_address_1 WHEN RegDst = "01" ELSE
								"11111" WHEN RegDst = "10" and INTA = '1'  ELSE -- 31
								write_register_address_0;
				
				
					-- Mux to bypass data memory for Rformat instructions
	write_data <= ALU_result( 31 DOWNTO 0 ) WHEN ( MemtoReg = "00" ) ELSE
				X"00000" & B"00" & PC_plus_4_temp WHEN ( MemtoReg = "10" ) ELSE
				read_data;
	
					-- Sign Extend 16-bits to 32-bits
    Sign_extend <= X"0000" & Instruction_immediate_value WHEN Instruction_immediate_value(15) = '0' ELSE
				X"FFFF" & Instruction_immediate_value;

PROCESS
	BEGIN
		WAIT UNTIL clock'EVENT AND clock = '0';
		IF reset = '1' THEN
					-- Initial register values on reset are register = reg#
					-- use loop to automatically generate reset logic 
					-- for all registers
			FOR i IN 0 TO 31 LOOP
				register_array(i) <= CONV_STD_LOGIC_VECTOR( i, 32 );
 			END LOOP;
					-- Write back to register - don't write to register 0
  		ELSIF RegWrite = '1' AND write_register_address /= 0 THEN
		      register_array( CONV_INTEGER( write_register_address)) <= write_data;
		END IF;
		
				------ Edit $k0 section ------
		IF (INTR = '1') THEN
			register_array(26)(0) <= '0';  -- clr GIE in $k0
		ELSIF (read_register_1_address = "11011" AND (opcode = "000000" AND Funct = "001000") ) THEN  --- if jr $k1
			register_array(26)(0) <= '1';  -- set GIE in $k0
		END IF;

		------ Edit $k1 section ------
		IF (INTA = '0') THEN
			register_array(27) <=  X"00000" & "00" & next_PC_for_jr;
		END IF;
		
		PC_plus_4_temp <= PC_plus_4_out;
		
	END PROCESS;   
	
	-------------- GIE ------------------------	
GIE				<= register_array(26)(0);	
	
END behavior;