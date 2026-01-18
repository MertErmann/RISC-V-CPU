# Custom Single-Cycle RISC-V Core

A clean, modular VHDL implementation of a **Single-Cycle RISC-V Processor** compatible with a subset of the **RV32I** instruction set architecture. Designed for educational purposes to understand computer architecture fundamentals.

## 🚀 Features

*   **Architecture:** Single-Cycle Harvard Architecture (Separate Instruction & Data Memory).
*   **ISA:** RISC-V 32-bit Integer (RV32I) subset.
*   **Design:** Modular VHDL coding style (Control Unit, ALU, Register File, etc.).
*   **Demo:** Pre-loaded with an Assembly program to calculate the **Fibonacci Sequence**.

## 🛠️ Supported Instructions

This core supports the essential instructions required for arithmetic algorithms:

*   **Arithmetic/Logic:** `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLT`, `SLL`, `SRL`, `SRA`
*   **Immediate:** `ADDI`, `ANDI`, `ORI`, `XORI`, `SLTI`
*   **Memory Access:** `LW` (Load Word), `SW` (Store Word)
*   **Branching:** `BEQ`, `BNE`
*   **Jump:** `JAL`

## 📂 File Structure

*   **`riscv_singlecycle_top.vhd`**: The top-level entity connecting all modules.
*   **`control_unit.vhd`**: Decodes instructions and generates control signals.
*   **`alu.vhd`**: Performs arithmetic and logic operations.
*   **`register_file.vhd`**: 32x32-bit register bank (x0 is hardwired to 0).
*   **`instruction_memory.vhd`**: ROM containing the Fibonacci program machine code.
*   **`data_memory.vhd`**: RAM for data storage.
*   **`tb_fibonacci.vhd`**: Testbench for verification.

## 💻 Simulation

The project includes a testbench (`tb_fibonacci.vhd`) that:
1.  Resets the processor.
2.  Runs the pre-loaded Fibonacci program.
3.  Calculates the sequence: `0, 1, 1, 2, 3, 5, 8, 13, 21, 34...`
4.  Loops indefinitely (resetting after 5000ns) for continuous observation.

### Waveform Example
To verify operation, observe the `alu_result` or `wd3` (Write Data) signals in the Register File during simulation.

## 🔮 Future Improvements

*   Implement `LUI`, `AUIPC`, and `JALR` instructions.
*   Add Byte/Half-word load/store support (`LB`, `SB`, etc.).
*   Convert to Pipelined Architecture to improve clock frequency.

---
*Created by [Mert Erman] as part of a Computer Architecture learning project.*
