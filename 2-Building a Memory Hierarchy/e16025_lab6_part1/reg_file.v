///////////////////////////////////////////////////////////////////
//module for register file
///////////////////////////////////////////////////////////////////

module reg_file(IN,OUT1,OUT2,IN2address,OUT1address,OUT2address,WRITEENABLE,CLK,RESET);
           
            
               input [7:0] IN;
		
               output reg [7:0] OUT1;
               output reg [7:0] OUT2;
					
               input [2:0] IN2address ;
               input [2:0] OUT1address;
               input [2:0] OUT2address;
   	           input WRITEENABLE;
	           input CLK;
		       input RESET ; 
   
                         
   reg [7:0] regMem [7:0];  //creating  spaces for registers

    integer i; //itterative variable

    always @(posedge CLK) //to syncronize the register
      begin
       
        if (WRITEENABLE) begin
            #1;                         //adding WRITEENABLE delay
			regMem[IN2address] <= IN;   //writing in to register
			
        end   
		
      end 
	
    always @(OUT1,OUT2,IN2address,OUT1address,OUT2address,WRITEENABLE,CLK,RESET) 
	  begin 
            #2;                           // adding read delay
			OUT1 = regMem[OUT1address];  // reading form register which have OUT1address to OUT1
           OUT2 = regMem[OUT2address];  //reading from register which have OUT2address to OUT2
	  end




	  
	always @(*) 
	  begin
	   if (RESET) begin
		     #2;                         //adding RESET delay8
			 			 
            for (i=0; i<8; i=i+1)
                regMem[i] <= 0;      // RESETing registers > make them zero
        end
	  end
	  
	
endmodule
