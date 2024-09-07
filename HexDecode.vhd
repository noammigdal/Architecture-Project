LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

-------------------------------------
ENTITY HexDecode IS
  PORT    (Binary_vec: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		  HEX_out: OUT STD_LOGIC_VECTOR(6 downto 0));
END HexDecode;

ARCHITECTURE HEX_arch OF HexDecode IS
begin
HEX_out <= "1000000" when Binary_vec = "0000" else --0
		   "1111001" when Binary_vec = "0001" else --1
		   "0100100" when Binary_vec = "0010" else --2
		   "0110000" when Binary_vec = "0011" else --3
		   "0011001" when Binary_vec = "0100" else --4
		   "0010010" when Binary_vec = "0101" else --5
		   "0000010" when Binary_vec = "0110" else --6
		   "1111000" when Binary_vec = "0111" else --7
		   "0000000" when Binary_vec = "1000" else --8
		   "0011000" when Binary_vec = "1001" else --9
		   "0001000" when Binary_vec = "1010" else --A
		   "0000011" when Binary_vec = "1011" else --b
		   "0100111" when Binary_vec = "1100" else --c
		   "0100001" when Binary_vec = "1101" else --d
		   "0000110" when Binary_vec = "1110" else --E
		   "0001110" when Binary_vec = "1111" else --F
		   "0111111";  					           -- unknown	   
end HEX_arch;