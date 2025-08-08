Overview
This repo contains a 32-bit, 5-stage pipelined MIPS-like CPU implemented in SystemVerilog for deployment on the  DE10-Lite FPGA. It supports  MIPSv1 instructions and ones unique to this project:

Byte-addressed ROM and RAM that by default has an address width of 10. 

Branch resolution unit which enables resolution during the Instruction-Decode stage(ID)

Hazard detection unit that enables hazards to at most cost one cycle

Forwarding Unit to mitigate data hazards

Address handling rules: memory immediates kept as byte offsets; jump/branch targets stored word-aligned (shift left 2 in CPU)

Instructions must be one word, one word = 4 bytes. This is loaded into the ROM


Architecture
Pipeline stages: Instruction Fetch --> Instruction Decode --> Execution --> Memory Access --> Write Back

Branching: BRU in ID outputs branch_taken; HDU flushes on taken branch

Hazards:

Load-use: stall one cycle when needed

Branch flush: on taken branches

Jump handling: no stall except JR hazards

Forwarding: EX/MEM and MEM/WB paths to ALU inputs

Module Summary (top-level ports abbreviated)
MIPS_Processor #(ADDR_WIDTH=10, ROM_INIT, RAM_INIT)

clk, rst

button0, button1 (board I/O as needed)

Instantiates ROM, RAM, Register_File, ALU, BRU, HDU, Forwarding_Unit, and pipeline registers

Memory_Unit (byte-addressed RAM):

Stores 32-bit words in big-endian order

Parameterized address width, $readmemh init from *_ram.hex

I/O port map: 8'hFD→port0, 8'hFE→port1, 8'hFF→output port (legacy convenience)

ROM (byte-addressed, 10-bit):

Outputs one word at a time, one word = 4 bytes

$readmemh from *_rom.hex

Register_File:

2R/1W, synchronous write, r0 reads as zero

Supports JumpAndLink writeback if enabled

ALU + ALU_OUT/HI/LOW:

Standard integer ops; HI/LO capture mult/div style results if present

BRU:

Compares operands in ID; outputs branch_taken and target PC

HDU:

Detects load-use hazards; controls pc_write, IF_ID_write, stall, flush

Forwarding_Unit:

EX/MEM and MEM/WB forwarding to ALU srcA/srcB

Instruction Handling Rules
Loads/Stores (lw, sw): immediate is a byte offset relative to base register; no left shift.

Branches/Jumps (beq, bne, j, jal, jr):

Targets are stored word-aligned by the assembler → SLL2 inside the CPU.

beq/bne offset is sign-extended (use ZE or SE as appropriate) and SLL2 before add.

jr uses register target; handle EX hazards (forward) and potential load-use stall.

Memory Map & Initialization
ROM: 10-bit byte address → 1024 bytes (256 words)

RAM: parameterized byte address width; words stored in big-endian byte order

Init: $readmemh with assembler outputs:

<program>_rom.hex → ROM

<program>_ram.hex → RAM

Build & Simulate
Quartus Project

Set top-level to MIPS_Processor (or module under test for TB)

Add *.sv sources and *_rom.hex, *_ram.hex

ModelSim (Intel/Altera Edition)

Compile libraries, then vlog sources

vsim TB or top; add waves; run

FPGA

Assign pins for DE10-Lite

Program SOF; verify via LEDs/UART/ports as configured 
