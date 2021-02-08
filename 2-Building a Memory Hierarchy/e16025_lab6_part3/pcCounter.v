///////////////////////////////////////////////////////////// 
// module for pc counting
/////////////////////////////////////////////////////////////
`timescale  1ns/100ps
module pcCounter (PC,CLK,RESET,JUMP,INSTRUCTION,NextPC,BUSYWAIT,Ins_busywait);       
input CLK,JUMP;
input RESET,BUSYWAIT,Ins_busywait;
input [31:0] INSTRUCTION;
output reg [31:0] PC;              
input [31:0] NextPC; 

always @(posedge CLK )
begin
  #1  //pc update delay
if(!RESET && !BUSYWAIT && !Ins_busywait)  // pc update when not in one of busywait or reset
begin 

     	
	             
	PC<=NextPC;         //pc update
 	
end
end

always @(posedge RESET)
begin
    
	    #1;      //pc update delay
	PC<= -4;	//if reset -> pc << -4

end

endmodule
