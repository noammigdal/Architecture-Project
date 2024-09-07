library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; 
USE work.aux_package.all;
 
entity PWM_counter is 
    
	port (
	clk, ena,rst ,PWM_MODE: in std_logic;	
	BTCL0,BTCL1: in std_logic_vector (31 downto 0);
	PWM_o: out std_logic 
	);
end PWM_counter;

architecture rtl of PWM_counter is
    signal q_int : std_logic_vector (31 downto 0):=X"00000000";
	signal PWM_int : std_logic;
begin
    process (clk)
    begin
        if (rising_edge(clk)) then
			if rst ='1' then	
				q_int <= (others => '0'); 
			elsif ena = '1' then	
				if (q_int < BTCL0) then 
		        q_int <= (q_int + 1); else 
				q_int <= (others => '0');
				end if;
           end if;
	     end if;
    end process;
    PWM_int <= '0' when q_int <= BTCL1 else '1';
	PWM_o <= PWM_int when (PWM_MODE = '0') else (not PWM_int);
	
end rtl;



