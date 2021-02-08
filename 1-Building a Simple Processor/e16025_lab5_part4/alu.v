//////////////////////////////////////////////////////
//module for ALU
/////////////////////////////////////////////////////

module alu(DATA1,DATA2,RESULT,SELECT,ZERO); 
input [7:0] DATA1,DATA2;
input [2:0] SELECT;
output reg [7:0] RESULT;
output ZERO;         

always@(DATA1,DATA2,SELECT)
begin


case(SELECT)
3'b000: 
     begin #1;RESULT =DATA2; //delay for FORWARD and FORWARD operation
	 end

3'b001:begin #2; RESULT =DATA1+DATA2; //delay for ADD and ADD operation
       end
3'b010: begin #1; RESULT =DATA1&DATA2;  //delay for the AND and AND operation
        end

3'b011:  begin #1; RESULT =DATA1|DATA2; //delay for OR and OR operation
    end
		
endcase
 
 
end
 //generating zero signal high when result is zero
nor nor1 (ZERO, RESULT[0],RESULT[1],RESULT[2],RESULT[3],RESULT[4],RESULT[5],RESULT[6],RESULT[7]);//checking result is zero or not

endmodule