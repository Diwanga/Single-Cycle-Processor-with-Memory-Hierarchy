////////////////////////////////////////////////////////
/////// E/16/025 AMASITH K.T.D  2020/05/03 /////////////
/////////////// LAB 05 PART 01 /////////////////////////
///////////////////////////////////////////////////////

// Commands for compiling and executing this verilog file in cmd (with testbench)

// 1  iverilog -o alu.vvp alu.v alu_tb.v
// 2  vvp alu.vvp
// 3  gtkwave alu_wavedata.vcd

////////////////////////////////////////////////////////////////////////////////


//  ALU module 

module alu(       
      input          [7:0]     DATA1,          //OPERAND1 
      input          [7:0]     DATA2,          //OPERAND2
      output     reg     [7:0]     RESULT,     //RESULT  
      input          [2:0]     SELECT          //ALUOP  	       
   );  
   
 always @(*)
 begin   
 
// selecting the received aluop
      case(SELECT)  
      3'b000: begin
	              #1;             //delay for FORWARD
	              RESULT = DATA2; // FORWARD operation 	  
	         end
      
	  3'b001:  begin 	           
			       #2;
	               RESULT = DATA1 + DATA2; // ADD operation			  
	           end
		
      3'b010: 
	         begin 			 
  	             #1;                      //delay for AND
		         RESULT = DATA1 & DATA2; // AND	operation        
	          end
	  
      3'b011: begin 
         	      #1;                     //delay for OR
			      RESULT = DATA1 | DATA2; // OR operation	    
	           end
     
      default: RESULT = 8'bxxxxxxxx; // Reserved --> For reserved selections are don't care conditions for this stage. 
                                      // So this is the default output in this alu module for reserved inputs	  
	 
	  
      endcase  
 end  
 endmodule 