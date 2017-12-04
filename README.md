# Computer Architecture A
Simulation files of MIPS.


## Requirements
- Icarus Verilog
- GTKWave
- XQuartz (For macOS)


## Usage
```bash
cd tmips
iverilog -s testbench -o testbench *.v
vvp testbench
```
if "Simulation succeeded" is displayed, it is successful.

- Display the waveform
```bash
gtkwave testb.vcd
```
