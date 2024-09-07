LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
  
ENTITY dmemory IS
	GENERIC (MemWidth	: INTEGER;
			 SIM 		: BOOLEAN);
	PORT(	read_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	address 			: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	   		MemRead, Memwrite 	: IN 	STD_LOGIC;
            clock,reset			: IN 	STD_LOGIC );
END dmemory;

ARCHITECTURE behavior OF dmemory IS
SIGNAL write_clock : STD_LOGIC;
SIGNAL dMemAddr		: STD_LOGIC_VECTOR(MemWidth-1 DOWNTO 0);
--SIGNAL numword : INTEGER;

BEGIN
	
	ModelSim: 
		IF (SIM = TRUE) GENERATE
				dMemAddr <= address(9 DOWNTO 2);
		END GENERATE ModelSim;
		
	FPGA: 
		IF (SIM = FALSE) GENERATE
				dMemAddr <= address(9 DOWNTO 2) & "00";
		END GENERATE FPGA;
		
--numword <= 2**MemWidth; 	
	
	data_memory : altsyncram
	GENERIC MAP  (
		operation_mode => "SINGLE_PORT",
		width_a => 32,
		widthad_a => MemWidth,
		numwords_a => 2**MemWidth,
		lpm_hint => "ENABLE_RUNTIME_MOD = YES,INSTANCE_NAME = DTCM",
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "C:\Users\User\Desktop\project\program\DTCM.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		wren_a => memwrite,
		clock0 => write_clock,
		address_a => dMemAddr,
		data_a => write_data,
		q_a => read_data	);
-- Load memory address register with write clock
		write_clock <= clock;
END behavior;


