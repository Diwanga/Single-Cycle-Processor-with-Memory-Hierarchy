////////////////////////////////////////////////////////////////////
 //making mux module(for 8 bit inputs and output)
//////////////////////////////////////////////////////////////////

module MUX_8bit(OUT,SELECT,INPUT1,INPUT2); 

input SELECT;
input [7:0] INPUT1,INPUT2;
output reg [7:0] OUT;
always @ (INPUT1 or INPUT2 or SELECT)   //mux have to generate output whenever inputsignals get changed
begin
	if (SELECT==1) 
		OUT = INPUT1;   //selecting inputs for output
	else 
		OUT = INPUT2;
end

endmodule
