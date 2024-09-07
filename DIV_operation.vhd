LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY DIV_operation is
    Port (
        clk     : IN  STD_LOGIC;
        rst        : IN  STD_LOGIC;
		start		   : IN  STD_LOGIC;
        dividend   : IN  STD_LOGIC_VECTOR(31 downto 0); -- 32-bit dividend
        divisor    : IN  STD_LOGIC_VECTOR(31 downto 0); -- 32-bit divisor
        quotient   : OUT STD_LOGIC_VECTOR(31 downto 0); -- 32-bit quotient
        remainder    : OUT STD_LOGIC_VECTOR(31 downto 0); -- 32-bit Residue
        done     : OUT STD_LOGIC
    );
END DIV_operation;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure of DIV_operation is
    SIGNAL state         : STD_LOGIC_VECTOR(1 downto 0);
    --SIGNAL temp_dividend : STD_LOGIC_VECTOR(63 downto 0);
    --SIGNAL temp_divisor  : STD_LOGIC_VECTOR(31 downto 0);
    --SIGNAL temp_quotient : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL quotient_sig  : STD_LOGIC_VECTOR(31 downto 0);
    --SIGNAL temp_Residue  : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL Residue_sig   : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL count         : STD_LOGIC_VECTOR(5 downto 0);
	SIGNAL DIVIFG_sig	 : STD_LOGIC;
    SIGNAL max_count     : STD_LOGIC_VECTOR(5 downto 0); -- Number of bits in dividend/divisor
    
BEGIN

   process(clk, rst)
   variable temp_quotient : unsigned(31 downto 0);
   variable temp_dividend  : unsigned(63 downto 0);
   variable temp_divisor  : unsigned(31 downto 0);
   
   begin
       if rst = '1' then
           state <= "00";
           temp_dividend := (others => '0');
           temp_divisor  := (others => '0');
           temp_quotient := (others => '0');
		   quotient_sig	 <= (others => '0');	
		   Residue_sig	 <= (others => '0');
           count <= (others => '0');
		   max_count <= "100000";
           DIVIFG_sig <= '0';
       elsif rising_edge(clk) then
           case state is
               when "00" => -- Idle State
                   if start = '1' then
                       temp_dividend := x"00000000" & unsigned(Dividend);
                       temp_divisor := unsigned(Divisor);
                       temp_quotient := (others => '0');
                       count <= (others => '0');
                       state <= "01";
                       DIVIFG_sig <= '0';
                   end if;

               when "01" => -- Division State
                   if count < max_count then
                       temp_dividend := temp_dividend(62 downto 0) & '0'; -- Shift dividend
                  
                       if temp_dividend(63 DOWNTO 32) >= temp_divisor then
                           temp_dividend := (temp_dividend(63 DOWNTO 32) - temp_divisor) & temp_dividend( 31 DOWNTO 0 );
                           temp_quotient := temp_quotient(30 downto 0) & '1'; -- Set bit in quotient
                       else
                           temp_quotient := temp_quotient(30 downto 0) & '0'; -- Clear bit in quotient
                       end if;

					   if count = "011111" then
							quotient_sig <= STD_LOGIC_VECTOR(temp_quotient);
							Residue_sig  <= STD_LOGIC_VECTOR(temp_dividend(63 DOWNTO 32));
							DIVIFG_sig	 <= '1';
							state <= "00";
					   end if;
					   
					   count <= count + 1;
					   
                   end if;
		
               when others =>
              	   state <= "00";
				   DIVIFG_sig	 <= '0';

           end case;
       end if;
   end process;
   quotient <= quotient_sig;
   remainder  <= Residue_sig;
   done	<= DIVIFG_sig;

end structure;