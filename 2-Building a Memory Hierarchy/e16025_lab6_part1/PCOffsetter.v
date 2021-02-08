/////////////////////////////////////////////////////////////////////
//module for dedicated adder to increment o decrement pc value from offsets in beq nd jump instructions
////////////////////////////////////////////////////////////////////

module PCOffsetter (next4pc , Next4plusPC,OFFSET);
output reg [31:0] Next4plusPC;    
input [31:0] next4pc ;
input [7:0] OFFSET;

always @ (next4pc) begin
#2;                     //dedicated adder delay
Next4plusPC = next4pc + { {22{OFFSET[7]}}, OFFSET[7:0],2'b00 };//add pc to 4 to go to next instruction
end
endmodule
