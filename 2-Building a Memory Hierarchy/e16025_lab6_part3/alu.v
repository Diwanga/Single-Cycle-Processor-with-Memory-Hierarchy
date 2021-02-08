//////////////////////////////////////////////////////
//module for ALU
/////////////////////////////////////////////////////
`timescale  1ns/100ps
module alu(DATA1,DATA2,RESULT,SELECT,ZERO); 
input [7:0] DATA1,DATA2;
input [2:0] SELECT;
output reg [7:0] RESULT;
wire [7:0] forwadres, andres,addres,orres;
output ZERO;         


assign #1 forwadres = DATA2; //FORWARD operation
assign #2 addres = DATA1+DATA2; //ADD operation
assign #1 andres = DATA1&DATA2; //AND operation
assign #1 orres = DATA1|DATA2;  //OR operation



always@(*)
begin


case(SELECT)
3'b000: RESULT =forwadres; // Select FORWARD operation
	 

3'b001: RESULT =addres; //Select ADD operation
       
3'b010:  RESULT =andres;  //Select AND operation
        

3'b011:   RESULT =orres; //Select OR operation
   
 default : RESULT = 8'b00000000;
		
endcase
 
 
end
 //generating zero signal high when result is zero
nor nor1 (ZERO, RESULT[0],RESULT[1],RESULT[2],RESULT[3],RESULT[4],RESULT[5],RESULT[6],RESULT[7]);//checking result is zero or not

endmodule


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////