//////////////////////////////////////////////////////////////
//////////// E/16/025 $$ AMASITH K.T.D $$ 2020/05/11    //////
//////////////////////////////////////////////////////////////
///////////////           LAB 5 PART 3        ////////////////
//////////////////////////////////////////////////////////////


// # cmd commands for run this this modules

// (1) iverilog -o cpu.vvp cpu.v
// (2) vvp cpu.vvp
// (3) gtkwave cpu_wavedata.vcd   

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
{bytemem[3] , bytemem[2] , bytemem[1] ,bytemem[0]}     = 32'b00001000000001100000000001100100;      // loadi   6  0x64 
{bytemem[7] , bytemem[6] , bytemem[5] ,bytemem[4]}     = 32'b00001000000001010000000000011110;		// loadi   5  0x1E  
{bytemem[11] , bytemem[10] , bytemem[9] ,bytemem[8]}   = 32'b00001000000000110000000011001110;		// loadi  3  0xCE
{bytemem[15] , bytemem[14] , bytemem[13] ,bytemem[12]} = 32'b00000001000001000000011000000011;		// add     4 6 3
{bytemem[19] , bytemem[18] , bytemem[17] ,bytemem[16]} = 32'b00000010000000100000010000000101;		// and   2 4 5
{bytemem[23] , bytemem[22] , bytemem[21] ,bytemem[20]} = 32'b00000011000000010000001000000011;		// or   1 2 3
{bytemem[27] , bytemem[26] , bytemem[25] ,bytemem[24]} = 32'b00000000000001110000000000000110;		// mov    7 6
{bytemem[31] , bytemem[30] , bytemem[29] ,bytemem[28]} = 32'b00001001000001000000011100000011;		// sub    4 7 3

end

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
	    $dumpfile("cpu_wavedata.vcd");                                   // generate files needed to plot the waveform using GTKWave                
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

	#110 $finish;         //stop 100 time units from start/
end

 
 endmodule
 
///////////////////////////////////////////////////////////// 
// module for pc counting
/////////////////////////////////////////////////////////////
module pcCounter (PC,CLK,RESET);       
input CLK;
input RESET;
output reg [31:0] PC;              
wire [31:0] NextPC; 


always @(posedge CLK)
begin
if(!RESET) 
begin 
    
	#1;                 //pc update delay
	PC<=NextPC;         //pc update

end
end

always @(posedge RESET)
begin
    
	    #1;
	PC<= -4;	//if reset -> pc << -4

end


PCadder MYpcadder (PC,NextPC); //pc increment via dedicated adder**

endmodule

/////////////////////////////////////////////////////////////////////
//module for dedicated adder to increment pc value parallel to instruction read.
////////////////////////////////////////////////////////////////////

module PCadder (NowPC , NextPC);
output reg [31:0] NextPC;    
input [31:0] NowPC ;

always @ (NowPC) begin
#2;                     //dedicated adder delay
NextPC = NowPC +3'd004;//add pc to 4 to go to next instruction
end
endmodule

//////////////////////////////////////////////
// module for Instruction memoey reading.
//////////////////////////////////////////////
module IntrucMemRead (WORD,PC,INSTRUCTION); 
 

input [31:0] PC;      
input [31:0] WORD;
output reg [31:0] INSTRUCTION;


   always @ (PC) begin
      #2;                     // instruction reading delay
      INSTRUCTION <= WORD ;   //instruction reading position
   
   end


endmodule

//////////////////////////////////////////////////////////////////////
//module for control unit
///////////////////////////////////////////////////////////////////////

module CU(OUT1address,OUT2address,IN2address,Immediate,ALUOP,imm_signal,compli_signal,INSTRUCTION,WRITE);

input [31:0] INSTRUCTION;
output reg [7:0] Immediate;
output reg imm_signal;
output reg [2:0] ALUOP;
output reg [2:0] OUT1address;
output reg [2:0] OUT2address;
output reg [2:0] IN2address;
output reg compli_signal,WRITE;




always @(INSTRUCTION)
 
begin
	
	//fletch the values of the instruction[23:0] 
	
	 OUT2address <= INSTRUCTION[2:0];
	OUT1address <= INSTRUCTION[10:8];
	Immediate <= INSTRUCTION[7:0];	
	IN2address <= INSTRUCTION[18:16];
	
	//fletch the values of the instruction[31:24] 
	//control logic for the incoming OPCODE
	
    #1;          //decoding delay	
   ALUOP <= INSTRUCTION[26:24];   //make the aluop
   
    //generating the signals for muxs.  
	
	imm_signal = 1'b0;       //immediate signal    
	compli_signal = 1'b0;     //compliment signal
	
	case (INSTRUCTION[31:24])
		8'b00001000:
		      begin
			imm_signal = 1'b1;  //enabale the immediate signal
			WRITE =1'b1;       //write is enable for all the operations in this stage
			end
			
		8'b00001001:		
		begin
			compli_signal = 1'b1;  //enabal compliment signal 
			WRITE =1'b1;          //write is enable for all the operations in this stage
			end
		default:WRITE =1'b1;      ////write is enable for all the operations in this stage
	endcase
	
end

endmodule

////////////////////////////////////////////////////////////////////
 //making mux module
//////////////////////////////////////////////////////////////////

module MUX(OUT,SELECT,INPUT1,INPUT2); 

input SELECT;
input [7:0] INPUT1,INPUT2;
output reg [7:0] OUT;
always @ (INPUT1 or INPUT2 or SELECT)   //mux have to generate output whenever inputsignals get changed
begin
	if (SELECT==1) 
		OUT = INPUT1;   //selecting inputs for output
	else 
		OUT = INPUT2;
end

endmodule

//////////////////////////////////////////////////////////////////
//module for making two's compliment
//////////////////////////////////////////////////////////////////

module compliment(OUT,IN);   
output [7:0] OUT;
input [7:0] IN;

assign OUT= ~IN+1'b1;

endmodule

///////////////////////////////////////////////////////////////////
//module for rejister file
///////////////////////////////////////////////////////////////////

module reg_file(IN,OUT1,OUT2,IN2address,OUT1address,OUT2address,WRITE,CLK,RESET);
           
            
               input [7:0] IN;
		
               output reg [7:0] OUT1;
               output reg [7:0] OUT2;
					
               input [2:0] IN2address ;
               input [2:0] OUT1address;
               input [2:0] OUT2address;
   	           input WRITE;
	           input CLK;
		       input RESET ; 
   
                         
   reg [7:0] regMem [7:0];  //creating  spaces for registers

    integer i; //itterative variable

    always @(posedge CLK) //to syncronize the register
      begin
       
        if (WRITE) begin
            #2;                         //adding WRITE delay
			regMem[IN2address] <= IN;   //writing in to register
			
        end   
		
      end 
	
    always @(OUT1,OUT2,IN2address,OUT1address,OUT2address,WRITE,CLK,RESET) 
	  begin 
            #2;                           // adding read delay
			OUT1 = regMem[OUT1address];  // reading form register which have OUT1address to OUT1
           OUT2 = regMem[OUT2address];  //reading from register which have OUT2address to OUT2
	  end




	  
	always @(*) 
	  begin
	   if (RESET) begin
		     #2;                         //adding RESET delay8
			 			 
            for (i=0; i<8; i=i+1)
                regMem[i] <= 0;      // RESETing registers > make them zero
        end
	  end
	  
	
endmodule

//////////////////////////////////////////////////////
//module for ALU
/////////////////////////////////////////////////////

module alu(DATA1,DATA2,RESULT,SELECT); 
input [7:0] DATA1,DATA2;
input [2:0] SELECT;
output reg [7:0] RESULT;

always@(DATA1,DATA2,SELECT)
begin
case(SELECT)
3'b000: 
     begin #1;RESULT =DATA2; //delay for FORWARD and FORWARD operation
	 end

3'b001:begin #2; RESULT =DATA1+DATA2; //delay for ADD and ADD operation
       end
3'b010: begin #1; RESULT =DATA1&DATA2;  //delay for the AND and AND operation
        end

3'b011:  begin #1; RESULT =DATA1|DATA2; //delay for OR and OR operation
    end
endcase
end
endmodule

/////////////////////////////////////////////////
//module for cpu
//In my cpu design, cpu module have all the module exept instuction read module
/////////////////////////////////////////////////

module cpu(PC,INSTRUCTION,CLK,RESET);
input RESET;
input CLK;

wire [2:0] SELECT;
output  [31:0] PC;
input [31:0] INSTRUCTION;
wire [2:0] OUT1address,OUT2address,IN2address;
wire [7:0] Immediate,OUT2,DATA2,MUX1OUT,RESULT,OUT1,MUX2OUT;
wire compli_signal,imm_signal;
wire WRITE;


//module instantiating
pcCounter MYpcCounter(PC,CLK,RESET); 
CU MYcu(OUT1address,OUT2address,IN2address,Immediate,SELECT,imm_signal,compli_signal,INSTRUCTION,WRITE);
reg_file MYregister1(RESULT,OUT1,OUT2,IN2address,OUT1address,OUT2address,WRITE,CLK,RESET);
compliment mycomp(DATA2,OUT2);
MUX MUX1(MUX1OUT,compli_signal,DATA2,OUT2);
MUX MUX2(MUX2OUT,imm_signal,Immediate,MUX1OUT);
alu MYalu(OUT1,MUX2OUT,RESULT,SELECT);
//reg_file MYregister2(RESULT,OUT1,OUT2,IN2address,OUT1address,OUT2address,WRITE,CLK,RESET);
endmodule