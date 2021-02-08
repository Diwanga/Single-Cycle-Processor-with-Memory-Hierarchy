////////////////////////////////////////////////////////
/////// E/16/025 AMASITH K.T.D  2020/05/03 /////////////
/////////////// LAB 05 PART 02 /////////////////////////
///////////////////////////////////////////////////////

// Commands for compiling and executing this verilog file in cmd 

// 1  iverilog -o reg_file.vvp reg_file.v reg_file_tb.v
// 2  vvp reg_file.vvp
// 3  gtkwave reg_file_wavedata.vcd

//////////////////////////////////////////////

//Register file module

module reg_file(
           
            
               input [7:0] IN,
		
               output reg [7:0] OUT1,
               output reg [7:0] OUT2,
					
               input [2:0] INADDRESS ,
               input [2:0] OUT1ADDRESS,
               input [2:0] OUT2ADDRESS,
   	           input WRITE,
	           input CLK,
		       input RESET    );
   
                         
   reg [7:0] regMem [7:0];  //creating  spaces for registers

    integer i; //itterative variable

    always @(posedge CLK) //to syncronize the register
      begin
       
        if (WRITE) begin
            #2;                         //adding Write delay
			regMem[INADDRESS] <= IN;   //writing in to register
			
        end   
		
      end 
	
    always @(*) 
	  begin 
            #2;                           // adding read delay
			OUT1 <= regMem[OUT1ADDRESS];  // reading form register which have OUT1ADDRESS to OUT1
            OUT2 <= regMem[OUT2ADDRESS];  //reading from register which have OUT2ADDRESS to OUT2
	  end
	  
	always @(*) 
	  begin
	   if (RESET) begin
		     #2;                         //adding reset delay
			 			 
            for (i=0; i<8; i=i+1)
                regMem[i] <= 0;      // reseting registers > make them zero
        end
	  end
	  
	
endmodule
