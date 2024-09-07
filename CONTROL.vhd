LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
  
ENTITY control IS
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

END control;

ARCHITECTURE behavior OF control IS

	SIGNAL  R_type, I_type, Lw, Sw, Beq_bne, j, jal_temp, jr_temp 	: STD_LOGIC;

BEGIN           
				-- Code to generate control signals using opcode bits
	R_type 		<=  '1'  WHEN  (Opcode = "000000" or Opcode = "011100") ELSE '0'; -- includes jump register & slt
	I_type		<=  '1'  WHEN  Opcode(5 downto 3) = "001"  ELSE '0';
	Lw        	<=  '1'  WHEN  Opcode = "100011"  ELSE '0';
 	Sw      	<=  '1'  WHEN  Opcode = "101011"  ELSE '0';
   	Beq_bne   	<=  '1'  WHEN  (Opcode = "000100" or Opcode = "000101") ELSE '0'; 
	j			<=  '1'  WHEN  (Opcode = "000010" or Opcode = "000011" or (Opcode = "000000" and Funct = "001000")) ELSE '0';
	jal_temp		<=  '1'  WHEN  Opcode = "000011" ELSE '0';
	jr_temp			<=  '1'  WHEN   (Opcode = "000000" and Funct = "001000") ELSE '0';  
  	RegDst    	<=  "01" WHEN R_type = '1' ELSE
					"10" WHEN j = '1' ELSE
					"00";
	bne			<=  '1'  WHEN Opcode = "000101" ELSE '0';
 	ALUSrc  	<=  Lw OR Sw OR I_type;
	MemtoReg 	<=  "01" WHEN LW = '1' ELSE
					"10" WHEN j = '1' ELSE
					"00";
  	RegWrite 	<=  (R_type AND (not jr_temp)) OR Lw OR I_type OR jal_temp;
  	MemRead 	<=  Lw;
   	MemWrite 	<=  Sw; 
 	Branch  	<=  Beq_bne;
	Jump		<=  j;
	ALUOp( 1 ) 	<=  R_type OR I_type; -- In I_type: depends on opcode
	ALUOp( 0 ) 	<=  Beq_bne OR I_type;


	jal <= jal_temp;
	
	
   END behavior;


