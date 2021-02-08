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
 ///////////////////////////////////////////////////////////////