
/////////////////////////////////////////////////////////////////////
//module for dedicated adder to general increment of pc value parallel to instruction read.
////////////////////////////////////////////////////////////////////

module PCadder (NowPC , NextPC);
output reg [31:0] NextPC;    
input [31:0] NowPC ;

always @ (NowPC) begin
#2;                     //dedicated adder delay
NextPC = NowPC +3'd004;//add pc to 4 to go to next instruction
end
endmodule
