--------------- Input Peripheral Module 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY GPIO_SW IS
	PORT( 
		MemRead		: IN	STD_LOGIC;
		ChipSelect	: IN 	STD_LOGIC;
		GPInput		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		Data		: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
END GPIO_SW;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF GPIO_SW IS

BEGIN	
	Data <= GPInput WHEN (MemRead AND ChipSelect) = '1' ELSE (OTHERS => 'Z');
	
END structure;