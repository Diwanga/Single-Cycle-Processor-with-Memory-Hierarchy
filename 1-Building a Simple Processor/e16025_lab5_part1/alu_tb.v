
//Module for test the alu module
module testbench;

//Inputs
 reg[7:0] DATA1,DATA2;
 reg[2:0] SELECT;
 wire[7:0] RESULT;
 

//Instantiating alu module as myalu
alu myalu(DATA1,DATA2,RESULT,SELECT);

initial
begin
   $monitor($time," OUTPUT  %b ",RESULT); // for cmd output
   
   //Generating wavedata file   
   $dumpfile("alu_wavedata.vcd");  //to dump the changes in the values of nets and registers in a wavedata file
   $dumpvars(0,testbench  );   //it dumps ALL variables in the current testbench module and alu module which instantate on testbench. 
end 

    initial begin
	
	//Giving DATA1 and DATA2 input values
	//You can change the input values for DATA1 and DATA2
	
      DATA1 = 8'b00000001;
      DATA2 = 8'b00000011;
          
		  
	  SELECT = 3'b000; // select FORWARD
       	   #10;
      SELECT = 3'b001;//select ADD
       	   #10;
      SELECT = 3'b010; // select AND
       	   #10;
      SELECT = 3'b011;//select OR
       	   #10;
		
	//select one of Reserved selection
		   
      SELECT = 3'b100; #10;
 
 
      SELECT = 3'b101;  #10;     	 
      SELECT = 3'b110;  #10;     	   	   
      SELECT = 3'b111;  #10;
	 
    //>> view gtkwave --> cmd will not show different output for continues reserved selections   	  
		  
      
    end

endmodule