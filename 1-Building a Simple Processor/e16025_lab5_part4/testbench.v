//////////////////////////////////////////////////////////////
//////////// E/16/025 $$ AMASITH K.T.D $$ 2020/05/11    //////
//////////////////////////////////////////////////////////////
///////////////           LAB 5 PART 4        ////////////////
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



//creating instruction memory as array of bytes
initial
begin
{bytemem[3] , bytemem[2] , bytemem[1] ,bytemem[0]}       = 32'b00001000000001100000000000010010;    // loadi   6  0x12 
{bytemem[7] , bytemem[6] , bytemem[5] ,bytemem[4]}       = 32'b00001000000001010000000000010010;	// loadi   5  0x12 
{bytemem[11] , bytemem[10] , bytemem[9] ,bytemem[8]}     = 32'b00010001000000100000011000000101;    //beq 0x02 6 5 
{bytemem[15] , bytemem[14] , bytemem[13] ,bytemem[12]}   = 32'b00001000000000010000000000011110;    //loadi   1  0x1E 
{bytemem[19] , bytemem[18] , bytemem[17] ,bytemem[16]}   = 32'b00001000000001110000000000011100;    //loadi   7  0x1C 
{bytemem[23] , bytemem[22] , bytemem[21] ,bytemem[20]}   = 32'b00000010000000110000010100000110;    //and 3 5 6
{bytemem[27] , bytemem[26] , bytemem[25] ,bytemem[24]}   = 32'b00000011000000100000010100000110;    //or 2 5 6
{bytemem[31] , bytemem[30] , bytemem[29] ,bytemem[28]}   = 32'b00000001000001000000010100000110;    //add 4 5 6 
{bytemem[35] , bytemem[34] , bytemem[33] ,bytemem[32]}   = 32'b00010100111111100000000000000000;    //j   0xFE
{bytemem[39] , bytemem[38] , bytemem[37] ,bytemem[36]}   = 32'b00001000000000110000000011001110;    //loadi  3  0xCE  //does not reach
///////////////////////////////////////////////////////////
//////

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


// Instantiating modules
// In my design. there are two main modules as diagram in lab sheet. 
// They are cpu module and IntrucMemRead  module
// I create seperate module for Instruction memoey read.
// But there was a guideline to implement intruction memory inside testbench module, So i keep memory array inside testbench.
 
 cpu mycpu(PC,INSTRUCTION,CLK,RESET);
 IntrucMemRead MYIntrucMemRead({bytemem[PC+3] , bytemem[PC+2] , bytemem[PC+1] ,bytemem[PC]},PC,INSTRUCTION); 
   

 
 
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


always #5 CLK=~CLK;      //making clock signal

initial
begin

	#120 $finish;         //stop 120 time units from start/
end

 
 endmodule
 

 
 
 
 





