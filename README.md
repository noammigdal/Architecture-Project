# Architecture-Project
Micro-architecture Project: Developed a single-cycle MIPS CPU with interrupt support which is received by peripherals components, using VHDL, and verified it with Quartus and ModelSim.
-------------------------------------------------------------
README.TXT
The system uses a 32-bit address and data bus for memory operations.
This VHDL design represents the top-level architecture of a digital system integrating a MIPS processor and peripheral components.

-------*project_Top*-----------
The project_Top entity contains a Phase-Locked Loop (PLL) to generate a stable clock signal from the input,
a MIPS processor core (MIPS_Top)
and a peripheral core (periphcore) manages additional functionalities.

--------*MIPS*-----------------

This VHDL module defines the architecture of a MIPS processor.
The MIPS entity integrates several components to handle instruction fetch, decode, execution, and memory access operations.

Components:
Ifetch: Handles instruction fetching and PC management.
Idecode: Decodes instructions and manages register read/write operations.
Control: Generates control signals based on the instruction opcode and function code.
Execute: Performs arithmetic and logical operations.
Dmemory: Manages memory read and write operations.
Interrupt Handling: The processor supports interrupt management with a dedicated interrupt handling process that updates relevant signals and addresses.

-------*periph_core*-----------

`periph_core` VHDL module is a peripheral core designed for interfacing with a CPU.
It handles various peripherals including GPIO, a basic timer, a divider and interrupt management.

GPIO Interface
- `KEY1`, `KEY2`, `KEY3`: Input key signals.
- `HEX0`, `HEX1`, `HEX2`, `HEX3`, `HEX4`, `HEX5`: Output 7-segment display signals.
- `LEDR`: Output LED signals.
- `Switches`: Input switch signals (8 bits).

CPU Bus Interface
- `MemReadBus`: Input signal indicating memory read request.
- `MemWriteBus`: Input signal indicating memory write request.
- `AddressBus`: Input address bus (12 bits).
- `DataBus`: Inout data bus (32 bits).

### Basic Timer
- `PWMout`: Output PWM signal like LAB4.

## Divider 
- This component handles division operations and generates interrupt flags (`DIVIFG`).
  The divider can be used for arithmetic operations that require division.

### CPU Interrupt Service Routine
- `INTR`: Output interrupt signal.
- `INTA`: Input interrupt acknowledge signal.
- `GIE`: Input global interrupt enable signal.

-------*Basic Timer*-----------

Output
- `BTCNT_INT`: 32-bit output showing the current timer count.
- `BTIFG`: Output interrupt flag indicating timer events.
- `PWMout`: Output PWM signal.

Clock Generation
The module uses the main clock (`MCLK`) to generate an internal clock (`BT_CLK`) based on the `BTSSEL` settings from the `BTCTL` register. Depending on the value of `BTSSEL`, `BT_CLK` is derived from different clock sources:
- `"00"`: Directly from `MCLK`
- `"01"`: From `CLK_CNT(0)`
- `"10"`: From `CLK_CNT(1)`
- `"11"`: From `CLK_CNT(2)`

Timer Counting
The timer (`BTCNT_temp`) is updated based on the `BT_CLK` signal:
- If `BTCNT_wr` is '1', the timer count (`BTCNT_temp`) is set to the value provided in `BTCNT`.
- If `BTHOLD` is '0', the timer count increments on each rising edge of `BT_CLK`, unless reset or cleared.

The PWM signal is generated using the `PWM_counter` component.
The interrupt flag output (`BTIFG`) is set based on a select signal (`BTIPx`) from the `BTCTL` register.
The specific bit of `BTCNT_temp` used for the flag depends on the value of `BTIPx`.

-------*Divider*-----------

Sets up internal signals and initializes values when start is asserted.
Uses a shift-and-subtract algorithm to compute quotient and remainder.
Performs the division over 32 clock cycles.
Asserts the done signal when the division is complete and updates outputs with the final results.

state: Tracks the module's state (Idle or Division).
quotient_sig & Residue_sig: Hold intermediate and final results.
count: Counts the number of cycles for the division.

-------*Interrupt Service Routine*-----------

Manages interrupt control registers, handles interrupt requests, and clears interrupts.

IE: Interrupt Enable
IFG: Interrupt Flag
TYPE: Interrupt Type
Interrupt Request (INTR): Asserted if any interrupt flag is set and global interrupts are enabled.
Clear Interrupts (CLR_IRQ_OUT): Clears specific interrupts based on the interrupt type and INTA.
Updates and reads IE, IFG, and TYPE registers based on memory operations and chip select signals.
Generates and manages interrupt requests and clearing signals.
