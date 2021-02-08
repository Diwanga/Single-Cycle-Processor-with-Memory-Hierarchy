/////////////////////////////////////////////////////////////////////
//module for dedicated adder to general increment of pc value parallel to instruction read.
////////////////////////////////////////////////////////////////////
`timescale  1ns/100ps
module PCadder (NowPC , NextPC);
output reg [31:0] NextPC;    
input [31:0] NowPC ;

always @ (NowPC) begin
#1;                     //dedicated adder delay
NextPC = NowPC +3'd004;//add pc to 4 to go to next instruction
end
endmodule