LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY Ifetch IS
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
END Ifetch;	

ARCHITECTURE behavior OF Ifetch IS
	SIGNAL PC, PC_plus_4    	: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL Mem_Addr 			: STD_LOGIC_VECTOR( MemWidth-1 DOWNTO 0 );
	SIGNAL next_PC,PC_DST2		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL not_clock			: STD_LOGIC;
	

--	SIGNAL numword : INTEGER;
BEGIN

--numword <= 2**MemWidth;
						--ROM for Instruction Memory
inst_memory: altsyncram
	
	GENERIC MAP (
		operation_mode => "ROM",
		width_a => 32,
		widthad_a => MemWidth,
		numwords_a => 2**MemWidth,
		lpm_hint => "ENABLE_RUNTIME_MOD = YES,INSTANCE_NAME = ITCM",
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "C:\Users\User\Desktop\project\program\ITCM.hex",
		intended_device_family => "Cyclone"
	)
	
	PORT MAP (
		clock0  		=> not_clock,
		address_a 		=> Mem_Addr, 
		q_a 			=> Instruction );
		
		not_clock <= not clock;
		
		next_PC_for_jr <= next_PC & "00";
		
					-- Instructions always start on word address - not byte
		PC(1 DOWNTO 0) <= "00";
					-- copy output signals - allows read inside module
		PC_out 			<= PC;
		PC_plus_4_out 	<= PC_plus_4;
						-- send address to inst. memory address register
		ModelSim: 
		IF (SIM = TRUE) GENERATE
				Mem_Addr <= PC( 9 DOWNTO 2 );
		END GENERATE ModelSim;
		
		FPGA: 
		IF (SIM = FALSE) GENERATE
				Mem_Addr <= PC;
		END GENERATE FPGA;
						-- Adder to increment PC by 4        
      		PC_plus_4( 9 DOWNTO 2 )  <= PC( 9 DOWNTO 2 ) + 1;
    	   	PC_plus_4( 1 DOWNTO 0 )  <= "00";
						-- Mux to select Branch Address or PC + 4        
		PC_DST2 <= X"00" WHEN Reset = '1' ELSE
					Add_result  WHEN ((Branch = '1') AND (Zero = '1') AND (bne = '0')) ELSE -- PC_SRC2 
					Add_result	WHEN ((Zero = '0') AND (bne = '1')) ELSE
					PC_plus_4( 9 DOWNTO 2 );
						-- Mux to select Jump Address or PC + 4        
		Next_PC <= 	X"00" WHEN Reset = '1' ELSE	
					PC_ISR( 9 DOWNTO 2 ) WHEN EN_PC_ISR = '1' ELSE -- INTR
					JumpAddr WHEN (Jump = '1') ELSE -- PC_SRC1
					PC_DST2;
					
		
    

	PROCESS (clock, reset)
		BEGIN
		IF (reset = '1') THEN
			PC( 9 DOWNTO 2) <= "00000000" ;
		ELSIF (rising_edge(clock)) THEN
			IF (PC_STOP = '0') THEN 
				PC( 9 DOWNTO 2 ) <= next_PC;
			END IF;	
		END IF;
	END PROCESS;

	
		
END behavior;



