//////////////////////////////////////////////////////////////
//////////// E/16/025 $$ AMASITH K.T.D $$ 2020/06/17    //////
//////////////////////////////////////////////////////////////
///////////////           LAB 6 PART 02       ////////////////
//////////////////////////////////////////////////////////////


// # cmd commands for run this this modules

// (1) iverilog -o processor.vvp *.v
// (2) vvp  processor.vvp
// (3) gtkwave processor_wavedata.vcd   

///////////////////////////////////////////////////////
`timescale  1ns/100ps
module testbench;

reg CLK;
reg RESET;
reg [7:0] bytemem [1023:0];   //creating instruction memory as array of bytes
wire [31:0] PC;                // to hold pc value
wire [31:0] INSTRUCTION,mem_readdata,mem_writedata;       // to hold one instruction
wire [7:0] READDATA,WRITEDATA,ADDRESS;
wire READ,WRITE,BUSYWAIT,mem_busywait,mem_read,mem_write;
wire [5:0] mem_address;




initial
begin

//INSTRUCTION SET 


{bytemem[3] , bytemem[2] , bytemem[1] ,bytemem[0]}       = 32'b00001000000000010000000000000100;    // loadi 1 0x04
{bytemem[7] , bytemem[6] , bytemem[5] ,bytemem[4]}       = 32'b00001000000000100000000000000101;	// loadi 2 0x05
{bytemem[11] , bytemem[10] , bytemem[9] ,bytemem[8]}     = 32'b00101000000000000000001000000001;    // swi 2 0x01    >>Write miss no dirty
{bytemem[15] , bytemem[14] , bytemem[13] ,bytemem[12]}   = 32'b00101000000000000000000100001001;    // swi 1 0x09    >>Write miss no dirty
{bytemem[19] , bytemem[18] , bytemem[17] ,bytemem[16]}   = 32'b00011000000001000000000000000001;    // lwi 4 0x01    >>Read hit
  
{bytemem[23] , bytemem[22] , bytemem[21] ,bytemem[20]}   = 32'b00011000000001010000000000001001;    // lwi 5 0x09    >>Read hit  
{bytemem[27] , bytemem[26] , bytemem[25] ,bytemem[24]}  =  32'b00000001000000000000010100000100;    // add 0 5 4   
{bytemem[31] , bytemem[30] , bytemem[29] ,bytemem[28]}   = 32'b00001000000001110000000000000001;    // loadi 7 0x01
{bytemem[35] , bytemem[34] , bytemem[33] ,bytemem[32]}   = 32'b00010000000000110000000000000111;    // lwd 3 7       >>Read hit
{bytemem[39] , bytemem[38] , bytemem[37] ,bytemem[36]}   = 32'b00110000000000000000001000000001;    // swd 2 1       >>Write miss no dirty

{bytemem[43] , bytemem[42] , bytemem[41] ,bytemem[40]}   = 32'b00101000000000000000001100100001;	// swi 3 0x21    >>Write miss with dirty
{bytemem[47] , bytemem[46] , bytemem[45] ,bytemem[44]}   = 32'b00000001000000110000001100000000;    // add 3 3 0
{bytemem[51] , bytemem[50] , bytemem[49] ,bytemem[48]}   = 32'b00001000000000000000000000000001;    // loadi 0 0x01
{bytemem[55] , bytemem[54] , bytemem[53] ,bytemem[52]}   = 32'b00010000000001010000000000000000;    // lwd 5 0        >>Read miss with dirty
{bytemem[59] , bytemem[58] , bytemem[57] ,bytemem[56]}   = 32'b00000001000001110000010100000000;    // add 7 5 0   

{bytemem[63] , bytemem[62] , bytemem[61] ,bytemem[60]}   = 32'b00101000000000000000011100000001;    // swi 7 0x01     >>Write hit
{bytemem[67] , bytemem[66] , bytemem[65] ,bytemem[64]}   = 32'b00011000000001100000000000000001;    // lwi 6 0x01     >>Read hit
{bytemem[71] , bytemem[70] , bytemem[69] ,bytemem[68]}   = 32'b00000001000001100000011000000001;    // add 6 6 1


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
// In my design. there are four main modules as diagram in lab sheet. 
// They are cpu , IntrucMemRead ,  Data chache and Data memory
// I create seperate module for Instruction memoey read. ///
// But there was a guideline to implement intruction memory inside testbench module, So i keep memory array inside testbench.
 
cpu mycpu(PC,INSTRUCTION,CLK,RESET,READ,WRITE,BUSYWAIT,READDATA,WRITEDATA,ADDRESS);
IntrucMemRead MYIntrucMemRead({bytemem[PC+3] , bytemem[PC+2] , bytemem[PC+1] ,bytemem[PC]},PC,INSTRUCTION); 
 
data_memory my_datamem(CLK,RESET,mem_read,mem_write, mem_address,mem_writedata,mem_readdata,mem_busywait);
datacache mydatacache( CLK,RESET,READ,WRITE, ADDRESS,WRITEDATA,READDATA,BUSYWAIT, mem_busywait,mem_read,mem_write,mem_address,mem_writedata,mem_readdata);
 
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

     #1400 $finish;         //   stop 1400 time units from start

	
end

 
 endmodule
 
 







