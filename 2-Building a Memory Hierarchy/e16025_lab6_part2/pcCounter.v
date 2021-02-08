///////////////////////////////////////////////////////////// 
// module for pc counting
/////////////////////////////////////////////////////////////
`timescale  1ns/100ps
module pcCounter (PC,CLK,RESET,JUMP,INSTRUCTION,NextPC,BUSYWAIT);       
input CLK,JUMP;
input RESET,BUSYWAIT;
input [31:0] INSTRUCTION;
output reg [31:0] PC;              
input [31:0] NextPC; 

always @(posedge CLK )
begin
  #1;
if(!RESET && !BUSYWAIT)  // pc update when not in busywait or reset
begin 

     	
	              //pc update delay
	PC<=NextPC;         //pc update
 	
end
end

always @(posedge RESET)
begin
    
	    #1;
	PC<= -4;	//if reset -> pc << -4

end

endmodule
