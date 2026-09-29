# Single-Cycle CPU in VHDL

Computer Organisation lab project (TUC, spring 2023). A **32-bit single-cycle processor**
for a MIPS-like instruction set, written in VHDL. Each component was built and tested
on its own, then combined into the datapath and the full processor.

## Architecture

The datapath is split into four stages, all driven by one control unit:

| Stage | Entity | Role |
|-------|--------|------|
| Fetch | `IFSTAGE` | Program counter (`PC`), `+4` incrementor, branch target adder, instruction memory (`IMEM`) |
| Decode | `DECSTAGE` | 32×32-bit register file, immediate extension (`DECcloud`) |
| Execute | `ALUSTAGE` | `ALU`: add, sub, and, or, not, shifts, rotations, with zero, overflow and carry-out flags |
| Memory | (inside `DATAPATH`) | Data memory (`RAM1024`) with word and byte access (`LSByte`); tested by `MEMSTAGE_tb` |

- `DATAPATH` connects the stages.
- `CONTROL` is an FSM that decodes the opcode and function fields and sets every select and
  enable signal.
- `PROCESSOR` is the top level: `CONTROL` + `DATAPATH`.

Building blocks: `Reg`, `RegisterFile`, `DEC5to32`, `MUX32to1`, `MUX2to1`, `MUX5bit2to1`,
`CompareModule`, `Incrementor`, `AdderImmediate`.

## Testing

Almost every entity has a testbench (`*_tb.vhd`). `PROCESSOR_tb` runs the whole CPU on the
program in `rom.data`. `romLab.coe` is the same kind of program as a Xilinx memory init file.

## Running

The project was built with **Xilinx ISE** (ISim). To run it elsewhere, e.g. with GHDL, compile
the sources and pick a testbench:

```sh
ghdl -a --ieee=synopsys *.vhd
ghdl -e --ieee=synopsys PROCESSOR_tb
ghdl -r --ieee=synopsys PROCESSOR_tb --wave=cpu.ghw
```

The Xilinx-specific files may need small changes to run under GHDL.
