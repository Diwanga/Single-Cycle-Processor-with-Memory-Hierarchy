 /////////////////////////////////////////////////
//module for cpu
//In my cpu design, cpu module have all the module exept instuction read module
//Full datapath also include here inside modules. 
/////////////////////////////////////////////////
`timescale  1ns/100ps
module cpu(PC,INSTRUCTION,CLK,RESET,READ,WRITE,BUSYWAIT,READDATA,OUT1,RESULT,Ins_busywait);
input RESET;
input CLK;
output READ,WRITE;
input BUSYWAIT;
input Ins_busywait;
input [7:0] READDATA;
output [7:0] OUT1,RESULT;
wire [2:0] SELECT;
output  [31:0] PC;
wire [31:0] NextPC,Next4plusPC,pcnew;
input [31:0] INSTRUCTION;
wire [2:0] OUT1address,OUT2address,IN2address;
wire [7:0] Immediate,OUT2,DATA2,MUX1OUT,MUX2OUT,offset,MUX3OUT;
wire compli_signal,imm_signal,BRANCH,MUX3_Select,JUMP,selectpc;
wire WRITEENABLE,READ,WRITE;


//module instantiating

pcCounter MYpcCounter(PC,CLK,RESET,JUMP,INSTRUCTION,pcnew,BUSYWAIT,Ins_busywait);      //pc updating     
PCadder MYpcadder (PC,NextPC);                              //for general increment of pc (+4)
PCOffsetter PCOffsetter1(NextPC,Next4plusPC,offset);         //pc offseting for beq an jump instructions
MUX_32bit MUX3(pcnew,MUX3_Select | JUMP,Next4plusPC,NextPC);  //for setting nextpc value

CU MYcu(OUT1address,OUT2address,IN2address,Immediate,SELECT,imm_signal,compli_signal,INSTRUCTION,WRITEENABLE,offset,BRANCH,JUMP,READ,WRITE); //generating control signls 

and and1(MUX3_Select,BRANCH,ZERO);                    //generating mux signal for branching 

reg_file MYregister1(MUX3OUT,OUT1,OUT2,IN2address,OUT1address,OUT2address,WRITEENABLE,CLK,RESET,BUSYWAIT);

compliment mycomp(DATA2,OUT2);                       //for complimenting
MUX_8bit MUX1(MUX1OUT,compli_signal,DATA2,OUT2);     //to select compliment 
MUX_8bit MUX2(MUX2OUT,imm_signal,Immediate,MUX1OUT);  //to selecct immediate
alu MYalu(OUT1,MUX2OUT,RESULT,SELECT,ZERO);

MUX_8bit MUX4(MUX3OUT,READ,READDATA,RESULT);  //to select register write values

endmodule