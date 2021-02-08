 
 /////////////////////////////////////////////////
//module for cpu
//In my cpu design, cpu module have all the module exept instuction read module
//Full datapath also include here inside modules. 
/////////////////////////////////////////////////

module cpu(PC,INSTRUCTION,CLK,RESET);
input RESET;
input CLK;
wire [2:0] SELECT;
output  [31:0] PC;
wire [31:0] NextPC,Next4plusPC,pcnew;
input [31:0] INSTRUCTION;
wire [2:0] OUT1address,OUT2address,IN2address;
wire [7:0] Immediate,OUT2,DATA2,MUX1OUT,RESULT,OUT1,MUX2OUT,offset;
wire compli_signal,imm_signal,BRANCH,MUX3_Select,JUMP,selectpc;
wire WRITE;


//module instantiating

pcUpdater MYpcCounter(PC,CLK,RESET,JUMP,INSTRUCTION,pcnew);          
PCadder MYpcadder (PC,NextPC);                              //for general increment of pc (+4)
PCOffsetter PCOffsetter1(NextPC,Next4plusPC,offset);         //pc offseting for beq an jump instructions
MUX_32bit MUX3(pcnew,MUX3_Select | JUMP,Next4plusPC,NextPC);  //for setting nextpc value

CU MYcu(OUT1address,OUT2address,IN2address,Immediate,SELECT,imm_signal,compli_signal,INSTRUCTION,WRITE,offset,BRANCH,JUMP);

and and1(MUX3_Select,BRANCH,ZERO);                    //generating mux signal for branching 

reg_file MYregister1(RESULT,OUT1,OUT2,IN2address,OUT1address,OUT2address,WRITE,CLK,RESET);

compliment mycomp(DATA2,OUT2);                       //for complimenting
MUX_8bit MUX1(MUX1OUT,compli_signal,DATA2,OUT2);     //to select compliment 
MUX_8bit MUX2(MUX2OUT,imm_signal,Immediate,MUX1OUT);  //to selecct immediate
alu MYalu(OUT1,MUX2OUT,RESULT,SELECT,ZERO);


endmodule