LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY DIV_Addr_Decoder IS
	PORT( 
		reset 												: IN	STD_LOGIC;
		AddressBus											: IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
		CS_dividend,CS_divisor,CS_quotient,CS_remainder  	: OUT 	STD_LOGIC
		);
END DIV_Addr_Decoder;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF DIV_Addr_Decoder IS

BEGIN

	CS_dividend 	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddressBus = X"82C" ELSE '0';
	CS_divisor  	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddressBus = X"830" ELSE '0';
	CS_quotient 	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddressBus = X"834" ELSE '0';
	CS_remainder	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddressBus = X"838" ELSE '0';

	
END structure;
