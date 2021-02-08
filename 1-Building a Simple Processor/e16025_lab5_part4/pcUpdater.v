///////////////////////////////////////////////////////////// 
// module for pc counting
/////////////////////////////////////////////////////////////
module pcUpdater (PC,CLK,RESET,JUMP,INSTRUCTION,NextPC);       
input CLK,JUMP;
input RESET;
input [31:0] INSTRUCTION;
output reg [31:0] PC;              
input [31:0] NextPC; 

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

endmodule
