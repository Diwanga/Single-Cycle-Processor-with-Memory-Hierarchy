
//////////////////////////////////////////////////////////////////////
//module for control unit
///////////////////////////////////////////////////////////////////////

module CU(OUT1address,OUT2address,IN2address,Immediate,ALUOP,imm_signal,compli_signal,INSTRUCTION,WRITE,offset,BRANCH,JUMP);

input [31:0] INSTRUCTION;
output reg [7:0] Immediate;
output reg imm_signal;
output reg [2:0] ALUOP;
output reg [2:0] OUT1address;
output reg [2:0] OUT2address;
output reg [2:0] IN2address;
output reg compli_signal,WRITE,BRANCH,JUMP;
output reg [7:0] offset;


always @(INSTRUCTION)
 
begin
	
	//fletch the values of the instruction[23:0] 
	
	 OUT2address <= INSTRUCTION[2:0];
	OUT1address <= INSTRUCTION[10:8];
	Immediate <= INSTRUCTION[7:0];	
	IN2address <= INSTRUCTION[18:16];
	
	offset <= 8'b00000000;	
	
	
	//fletch the values of the instruction[31:24] 
	//control logic for the incoming OPCODE
	
    #1;          //decoding delay	
   ALUOP <= INSTRUCTION[26:24];   //make the aluop
   
    //generating the signals for muxs.  
	
	imm_signal = 1'b0;       //immediate signal    
	compli_signal = 1'b0;     //compliment signal
	BRANCH =1'b0;             //BRANCH signal
	JUMP =1'b0;             //JUMP signal
	
	case (INSTRUCTION[31:24])
		8'b00001000:
		      begin
			imm_signal = 1'b1;  //enabale the immediate signal
			WRITE =1'b1;       //write is enable for all the operations in this stage
			end
			
		8'b00001001:		
		begin
			compli_signal = 1'b1;  //enabal compliment signal 
			WRITE =1'b1;          //write is enable for all the operations in this stage
			end
				
		8'b00010001:		//generating control signals for branch if equal instruction
		begin
		compli_signal <= 1'b1;          //enabal compliment signal as subtraction have to happen
		BRANCH <= 1'b1;                 //enable branch signal 
		offset <= INSTRUCTION[23:16];   //getting the offset to change the pc
        WRITE =0;                       //disable write signal as beq does not want write
		end
		
		8'b00010100:		  //generating control signals for jump instruction
		begin
		JUMP = 1'b1;                       //enable JUMP signal
		offset <= INSTRUCTION[23:16];      //getting the offset to change the pc
		WRITE =0;                           //disable write signal as beq does not want write
		end
			
			
		default:WRITE =1'b1;      ////write is enable for all the operations
		
	endcase
	
end

endmodule
