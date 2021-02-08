============COMMANDS FOR EXECUTING==============

1 Compile
=============================
     iverilog -o processor.vvp *.v
=============================

2 Run
=============================
     vvp  processor.vvp
=============================

3 Open with gtkwave tool
=============================
    gtkwave processor_wavedata.vcd  
=============================

******************************************
 

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// In my design. there are four main modules as diagram in lab sheet. 
// They are cpu , IntrucMemRead ,  Data chache and Data memory
// I create seperate module for Instruction memoey read. ///
// But there was a guideline to implement intruction memory inside testbench module, So i keep memory array inside testbench.
   