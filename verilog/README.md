# Verilog implementation

To only test the functionality, the Verilog codes are with the parameters (PE, R, Q) = (16 ↘<sub>-2</sub> 12 every 16 Tc, 64, 48).

You can run the Verilog codes with the following commands (10 testcases are provided, Tc = 10ns):

To source the license,

`$ source /usr/cad/synopsys/CIC/vcs.cshrc`

For the RTL simulation (x = 1-10),

`$ source SW_vcs.sh x`

For the simulation after Synthesis (x = 1-10),

`$ source SW_syn_vcs.sh x`

The reports for timing, area and power are provided.

<br/>

Note: The tsmc13.v file is not provided on github.
