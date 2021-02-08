//////////////////////////////////////////////////////////////
//////////// E/16/025 $$ AMASITH K.T.D $$ 2020/06/01    //////
//////////////////////////////////////////////////////////////
///////////////           LAB 6 PART 01       ////////////////
//////////////////////////////////////////////////////////////


// # cmd commands for run this this modules

// (1) iverilog -o processor.vvp *.v
// (2) vvp  processor.vvp
// (3) gtkwave processor_wavedata.vcd   

///////////////////////////////////////////////////////
module testbench;

reg CLK;
reg RESET;
reg [7:0] bytemem [1023:0];    //creating memory one byte(8bit)
wire [31:0] PC;                // to hold pc value
wire [31:0] INSTRUCTION;       // to hold one instruction
wire [7:0] READDATA,WRITEDATA,ADDRESS;
wire READ,WRITE,BUSYWAIT;



//creating instruction memory as array of bytes
initial
begin
{bytemem[3] , bytemem[2] , bytemem[1] ,bytemem[0]}       = 32'b00001000000000010000000000000010;    // loadi 1 0x02
{bytemem[7] , bytemem[6] , bytemem[5] ,bytemem[4]}       = 32'b00001000000000100000000000000100;	// loadi 2 0x04
{bytemem[11] , bytemem[10] , bytemem[9] ,bytemem[8]}     = 32'b00101000000000000000001010001100;    // swi  2 0x8C 
{bytemem[15] , bytemem[14] , bytemem[13] ,bytemem[12]}   = 32'b00011000000001000000000010001100;    // lwi 4 0x8C
{bytemem[19] , bytemem[18] , bytemem[17] ,bytemem[16]}   = 32'b00001000000000110000000010001010;    // loadi 3 0x8A 
{bytemem[23] , bytemem[22] , bytemem[21] ,bytemem[20]}   = 32'b00110000000000000000001000000011;    // swd 2 3
{bytemem[27] , bytemem[26] , bytemem[25] ,bytemem[24]}   = 32'b00010000000001010000000000000011;    // lwd 5 3
{bytemem[31] , bytemem[30] , bytemem[29] ,bytemem[28]}   = 32'b00000001000001010000010100000010;    // add 5 5 2
{bytemem[35] , bytemem[34] , bytemem[33] ,bytemem[32]}   = 32'b00000001000001000000010000000001;    // add 4 4 1


end

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
// In my design. there are two main modules as diagram in lab sheet. 
// They are cpu module and IntrucMemRead  module
// I create seperate module for Instruction memoey read.
// But there was a guideline to implement intruction memory inside testbench module, So i keep memory array inside testbench.
 
 cpu mycpu(PC,INSTRUCTION,CLK,RESET,READ,WRITE,BUSYWAIT,READDATA,WRITEDATA,ADDRESS);
 IntrucMemRead MYIntrucMemRead({bytemem[PC+3] , bytemem[PC+2] , bytemem[PC+1] ,bytemem[PC]},PC,INSTRUCTION); 
 data_memory my_datamem(CLK,RESET,READ,WRITE, ADDRESS,WRITEDATA,READDATA,BUSYWAIT);

 
 
initial
begin
	    $monitor($time," clc = %b   PC= %d   RESET = %b",CLK,PC,RESET); // show clk pc and reset values in cmd with the time
	    $dumpfile("processor_wavedata.vcd");                                   // generate files needed to plot the waveform using GTKWave                
		$dumpvars(0, testbench);                                     //dmp all the  vaariables in tesbench as well as inside modules.
 
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

	#250 $finish;         //stop 250 time units from start
end

 
 endmodule
 
 

 
 











