# Revised Banded Smith-Waterman Algorithm

This repo is the Software (Python) and Hardware (Verilog) implementations of the Revised BSW Algorithm.

This work is for the 111-2 Special Project, and is based on the 110-2 ICD final project and the 111-1 Special Project.

Previos Work: <https://github.com/JasonCS-Chen/Revised_BSW.git>

Advisor: Prof. Yi-Chang Lu, National Taiwan University

<br>

The Revised Banded-SW Algorithm is with:

**a. Dynamic Shifting**

Sum left and right half values of PEs, and shift to right or down if one side is larger by 2.

**b. 2-bit Branch Prediction**

Shift the PEs according to the following FSM instead of the current cycle shift signal.

![Photo](https://github.com/JasonCS-Chen/Revised_BSW_PM/blob/main/branch_prediction.jpg)


**c. Power Management**

After half way, shut down 2 PEs every 16 cycles with the lower bound of half number of PEs.

<br>

Advantages:

a. Able to cover the regions not in the original Banded-SW.

b. Decrease the power usage than the original Banded-SW.

### Reference
Y. -L. Liao, Y. -C. Li, N. -C. Chen and Y. -C. Lu, "Adaptively Banded Smith-Waterman Algorithm for Long Reads and Its Hardware Accelerator,"
2018 IEEE 29th International Conference on Application-specific Systems, Architectures and Processors (ASAP), 2018, pp. 1-9.

Heng Li, "Minimap2: pairwise alignment for nucleotide sequences," Bioinformatics, Volume 34, Issue 18, September 2018, pp. 3094-3100.

David A. Patterson and John L. Hennessy, Computer Organization and Design RISC-V Edition: The Hardware Software Interface, 1st edition, Morgan Kaufmann.

GitHub Link: <https://github.com/JasonCS-Chen/Revised_BSW_PM.git>
