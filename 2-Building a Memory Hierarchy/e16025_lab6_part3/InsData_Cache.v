`timescale  1ns/100ps
//////////////////////////////////////////////////////
//module for Instruction Data cache
// Author : Diwanga Amasith  6/19/2020
/////////////////////////////////////////////////////
 module InsData_Cache (

		clock,
        reset,        
    	address, 	    
		readdata,
   cache_busywait,
     mem_busywait,
	 mem_read,
	 mem_address,	 
	 mem_readdata
);
 //declaring ports
input				clock;
input           	reset;

input[9:0]      	address;
output reg [31:0]	readdata;
output reg      	cache_busywait;

input mem_busywait;
output reg mem_read;

output reg [5:0] mem_address;

input[127:0] mem_readdata;


//Declare cache memory array (32x4)x8 = 1024bits >128Bytes
reg [31:0] cache_array [7:0][3:0];


//Declare valid bit array 8 bit
reg valid[0:7];


//tag array 3bit x 8
reg [2:0] tagarray [7:0];

//for read data
wire [31:0] next_Instuction;
reg cache_read;

//Combinational part for indexing, tag comparison for hit deciding, etc.
  	
//asserting busywait signals	
always @(address)
begin
if(!reset) 
begin
cache_read = 1;
 cache_busywait = 1;

end
end



//Reading data for next instruction
assign #1  next_Instuction =  cache_array[address[6:4]][address[3:2]];


// intiating
wire[2:0] tagIn;
reg hit;
wire validnow ;

//indexing 

assign #1 validnow = valid[address[6:4]];
assign #1 tagIn =  tagarray[address[6:4]];

//getting hit status // i use xnor operator in verilog to compare tag in bitwise
always @(*)         
begin

#0.9; //latency for tag comparison #1 
hit= (((address[7] ~^ tagIn[0]) && (address[8] ~^ tagIn[1]) && (address[9] ~^ tagIn[2])) && validnow ) ? 1 :0 ; //tag comprison and get hitting//at this stage validnow is setted

end



//things to do when hit occur
always @ (*)
begin

 if (cache_read && hit)
  begin
    
   readdata = next_Instuction;  //sending next instrctions to cpu 

  end



end





always @ (posedge clock)
begin

 if (hit)
  begin

   cache_busywait =0;            //deasserting busywait
     cache_read = 0;

  end


end




  /* Cache Controller FSM Start */
 
  //declaring states
    parameter IDLE = 2'b00, MEM_READ = 2'b01 , CACHE_WRITE = 2'b11;
    reg [1:0] state, next_state;

    // combinational next state logic
    always @(*)
	
    begin
        case (state)
            IDLE:   //initial state and state for direct hitting instrctions
			begin
			
			  if (cache_read && !hit) 
			  begin
			   
                    next_state = MEM_READ;
			 end
                
                           
			   else
                    next_state = IDLE;            
            end
			 
            
			MEM_READ:   //Instruction data memory read state
			begin
              
			  if (!mem_busywait)  //waiting for mem read stop 
			    begin
                    next_state = CACHE_WRITE;
					end
                else    
                    next_state = MEM_READ;
													   
		    end
									
			
			CACHE_WRITE :    //cach write state
			
			begin
			  			
			    next_state = IDLE;
					
			end	
            
        endcase
    end

    // combinational output logic
    always @(*)
    begin
        case(state)
            IDLE:
            begin
		
                mem_read = 0;

                mem_address = 6'dx;
               						
          
            end
         
            MEM_READ: 
            begin
			    cache_busywait = 1;
                mem_read = 1;    //setting memory read signal high                
                mem_address = {address[9:4]};  //sending address for requesting data from instruction memory
                
              
				
            end
			CACHE_WRITE :			
			begin
			
			  mem_read = 0;
              
              mem_address = 6'dx;
              
			  //writing into cache with readdata from Instruction datamemory
			  #1;
			  cache_array[address[6:4]][0] = mem_readdata[31:0];   
			  cache_array[address[6:4]][1] = mem_readdata[63:32];
			  cache_array[address[6:4]][2] = mem_readdata[95:64];
			  cache_array[address[6:4]][3] = mem_readdata[127:96];
			  tagarray[address[6:4]]= {address[9],address[8],address[7]};
			  valid[address[6:4]]= 1;   //updating valid bit

			end
			
            
        endcase
    end
integer i;

     // initializing valid and tag arrays at reset
    always @(posedge reset)
    begin

			
			 for (i=0;i<8; i=i+1) 
            valid[i] = 0;
			
						
			 cache_busywait = 0;
	            			  
    end
	
	// sequential logic for state transitioning 
    always @(posedge clock, reset)
    begin
        if(reset)
            state = IDLE;
        else
            state = next_state;
    end


    /* Cache Controller FSM End */

 

endmodule



