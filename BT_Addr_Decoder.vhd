--------------- Optimized Address Decoder Module 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;  
-------------- ENTITY --------------------
ENTITY BT_Addr_Decoder IS
	PORT( 
		reset 												: IN	STD_LOGIC;
		AddressBus											: IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
		CS_BTCTL ,CS_BTCNT,CS_BTCCR0,CS_BTCCR1       		: OUT 	STD_LOGIC
		);
END BT_Addr_Decoder;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF BT_Addr_Decoder IS

BEGIN

	CS_BTCTL	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddressBus = X"81C" ELSE '0';
	CS_BTCNT	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddressBus = X"820" ELSE '0';
	CS_BTCCR0	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddressBus = X"824" ELSE '0';
	CS_BTCCR1	<=	'0' WHEN reset = '1' ELSE '1' WHEN AddressBus = X"828" ELSE '0';

END structure;