# RISC-V-Processor

This repository contains two main components:

1. **RISC-V Processor (Quartus Project)**:
    - This folder contains a complete Quartus project for a RISC-V processor, currently supporting the execution of R-type and I-type instructions. The processor design is fully customizable and can be expanded to support additional instruction types as needed.

2. **Verifython (Python Instruction Tester)**:
    - Verifython is a Python-based tool used to test a sequence of RISC-V instructions on the processor. The tool interprets machine code instructions, identifies the instruction type, and simulates the execution by displaying the state of the registers after each instruction.

### Example Output from Verifython:

1: I-type 06400f93: [addi x31, x0, 100] | x31 = 100 2: I-type 00100093: [addi x1, x0, 1] | x1 = 1 3: R-type 001080b3: [add x1, x1, x1] | x1 = 2 4: I-type 00100093: [addi x1, x0, 1] | x1 = 1 5: R-type 01f080b3: [add x1, x1, x31] | x1 = 101 6: I-type 00200113: [addi x2, x0, 2] | x2 = 2

### How to Use

- **Quartus Project**: Open the Quartus project using Intel Quartus Prime software. You can synthesize, simulate, or program the design onto an FPGA board.
  
- **Verifython**: Run the Python script to simulate instruction execution by feeding it machine code instructions in hexadecimal format. The results will display the instruction type, operation, and the final value of the modified registers.

### Future Work
- Expanding instruction set support.
- Integration with FPGA for real-time instruction execution.
- Additional testing features in Verifython.
