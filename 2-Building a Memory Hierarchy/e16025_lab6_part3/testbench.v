//////////////////////////////////////////////////////////////
//////////// E/16/025 $$ AMASITH K.T.D $$ 2020/06/21    //////
//////////////////////////////////////////////////////////////
///////////////           LAB 6 PART 03       ////////////////
//////////////////////////////////////////////////////////////


// # cmd commands for run this  modules

// (1) iverilog -o processor.vvp *.v
// (2) vvp  processor.vvp
// (3) gtkwave processor_wavedata.vcd   

///////////////////////////////////////////////////////
`timescale  1ns/100ps
module testbench;

reg CLK;
reg RESET;
wire [31:0] PC;               
wire [31:0] INSTRUCTION,mem_readdata,mem_writedata;       
wire [7:0] READDATA,WRITEDATA,ADDRESS;
wire READ,WRITE,BUSYWAIT,mem_busywait,mem_read,mem_write,Ins_busywait,Inscache_busywait,Insmem_read;
wire[127:0] Insmem_readdata;
wire [5:0] mem_address,Insmem_address;



//instruction encodings

// loadi 	= "00001000";
// mov   	= "00000000";
// add 	    = "00000001";
// sub  	= "00001001";
// and 	    = "00000010";
// or   	= "00000011";
// j		= "00010100";
// beq  	= "00010001"; 
// lwd 	    = "00010000";
// lwi    	= "00011000";
// swd   	= "00110000";
// swi 	    = "00101000";


// Instantiating modules
// In my design. there are Five main modules as expect.
// They are cpu , INSTRUCTION data memory ,INSTRUCTION cache module, Data chache and Data memory

 cpu mycpu(PC,INSTRUCTION,CLK,RESET,READ,WRITE,BUSYWAIT,READDATA,WRITEDATA,ADDRESS,Ins_busywait);
 
 InsData_Cache myInsData_Cache(CLK, RESET, PC[9:0],INSTRUCTION,Ins_busywait,Insmem_busywait,Insmem_read,Insmem_address,Insmem_readdata);
 InsData_memory myInsData_mem(CLK,Insmem_read,Insmem_address,Insmem_readdata,Insmem_busywait);
 
 data_memory my_datamem(CLK,RESET,mem_read,mem_write, mem_address,mem_writedata,mem_readdata,mem_busywait);
 datacache mydatacache( CLK,RESET,READ,WRITE, ADDRESS,WRITEDATA,READDATA,BUSYWAIT, mem_busywait,mem_read,mem_write,mem_address,mem_writedata,mem_readdata);
 
initial
begin
	    $monitor($time," clc = %b   PC= %d   RESET = %b",CLK,PC,RESET); // show clk pc and reset values in cmd with the time
	    $dumpfile("processor_wavedata.vcd");                                   // generate files needed to plot the waveform using GTKWave                
		$dumpvars(0, testbench);                                     //dump all the variables in tesbench as well as inside modules.
 
 end
 
 initial
begin         //initial reset
    
	CLK=1'b1;
	RESET =0;
	#4;
	RESET=1'b1;#4;
	RESET =0;
	
end


always #4 CLK=~CLK;      //making clock signal

initial
begin

     #2456 $finish;         //   stop 2456 time units from start  FOR INSTRUCTION SET 01 <<
 
  //   #4665  $finish;        //   FOR INSTRUCTION SET 02 <<
 
  //  #2100  $finish;        //   FOR INSTRUCTION SET 02 <<
	
end

 
 endmodule
 
 







