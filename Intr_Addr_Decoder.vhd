--------------- Optimized Address Decoder Module 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;  
-------------- ENTITY --------------------
ENTITY Intr_Addr_Decoder IS
	PORT( 
		reset 												: IN	STD_LOGIC;
		AddressBus											: IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
		CS_IE ,CS_IFG,CS_TYPE       		                : OUT 	STD_LOGIC
		);
END Intr_Addr_Decoder;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF Intr_Addr_Decoder IS

BEGIN

	CS_IE	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddressBus = X"83C" ELSE '0';
	CS_IFG	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddressBus = X"83D" ELSE '0';
	CS_TYPE	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddressBus = X"83E" ELSE '0';

END structure;