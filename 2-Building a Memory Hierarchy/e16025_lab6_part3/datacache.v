`timescale  1ns/100ps
//////////////////////////////////////////////////////
//module for Data cache
/////////////////////////////////////////////////////
 module datacache (

		clock,
        reset,
        read,
        write,
    	address,
  	    writedata,
		readdata,
     	busywait,

     mem_busywait,
	 mem_read,
	 mem_write,
	 mem_address,
	 mem_writedata,
	 mem_readdata
);
 //declaring ports
input				clock;
input           	reset;
input           	read;
input           	write;
input[7:0]      	address;
input[7:0]     	writedata;
output reg [7:0]	readdata;
output reg      	busywait;

input mem_busywait;
output reg mem_read;
output reg mem_write;
output reg [5:0] mem_address;
output reg [31:0] mem_writedata;
input[31:0] mem_readdata;


//Declare cache memory array (8x4)x8 = 256bits 
reg [7:0] cache_array [7:0][3:0];

//Declare dirty bit array 8 bit
reg dirty[0:7];

//Declare valid bit array 8 bit
reg valid[0:7];


//tag array 3bitx8
reg [2:0] tagarray [7:0];

//for read data
wire [7:0] dataforcpu;


//Combinational part for indexing, tag comparison for hit deciding, etc.
  	
//asserting busywait signals	
always @(read, write,address)
begin
if(write || read)
	busywait = 1 ;
	else busywait =0;

end



//Reading data for cpu readdata
assign #1  dataforcpu =  cache_array[address[4:2]][address[1:0]];


// intiating
wire[2:0] tagIn;
reg hit;
wire validnow ,dirtynow ;

//indexing 
assign #1 dirtynow = dirty[address[4:2]];
assign #1 validnow = valid[address[4:2]];
assign #1 tagIn =  tagarray[address[4:2]];

//getting hit status // i use xnor operator in verilog to compare tag in bitwise
always @(*)         
begin

#0.9; //latency for tag comparison #1 
hit= (((address[5] ~^ tagIn[0]) && (address[6] ~^ tagIn[1]) && (address[7] ~^ tagIn[2])) && validnow ) ? 1 :0 ; //tag comprison and get hitting//at this stage validnow is setted

end



//things to do when hit occur
always @ (*)
begin

 if (read && hit)
  begin

   readdata = dataforcpu;  //sending data to cpu //register will write it at next clock posedge
   
 
  end



end

always @(posedge hit)              //trigert to pos egdge of hit for support two consecutive store instructions
begin

 if (write && hit)
  begin
 
   dirty[address[4:2]] = 1;        //making dirty in writing block

  end
end



always @ (posedge clock)
begin

 if (read && hit)
  begin

   busywait =0;            //deasserting busywait
   

  end

 if (write && hit)
  begin

   busywait =0;             //deasserting busywait

  end

end



//writing data into cache
always @ (posedge clock)
begin

if (write && hit)
begin

 #1 //cache writing delay
 cache_array[address[4:2]][address[1:0]]= writedata ; //writing data into cache 


end


end

  /* Cache Controller FSM Start */
 
  //declaring states
    parameter IDLE = 2'b00, MEM_READ = 2'b01 , MEM_WRITE = 2'b10, CACHE_WRITE = 2'b11;
    reg [1:0] state, next_state;

    // combinational next state logic
    always @(*)
	
    begin
        case (state)
            IDLE:   //state for non memory related  and direct hitting instrctions
			begin
			
			  if ((read || write) && dirtynow && !hit) 
			  begin
			   
                    next_state = MEM_WRITE;
			 end
                
              else if ((read || write) && !dirtynow && !hit)  			  
			  begin
                    next_state = MEM_READ;
					
					
			 end
               
			   else
                    next_state = IDLE;            
            end
			 
            
			MEM_READ:   //data memory read state
			begin
              
			  if (!mem_busywait)  //waiting for mem read stop 
			    begin
                    next_state = CACHE_WRITE;
					end
                else    
                    next_state = MEM_READ;
													   
		    end
					
	
		    MEM_WRITE:		 //data memory write state
			
			begin
			   if (!mem_busywait)    //waiting for mem write stop 
			   begin
                    next_state =  MEM_READ;
			   end
			   
			   else
				  next_state = MEM_WRITE;
			  
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
                mem_write = 0;
                mem_address = 6'dx;
                mem_writedata = 8'dx;
						
          
            end
         
            MEM_READ: 
            begin
			    busywait = 1;
                mem_read = 1;    //setting memory read signal high
                mem_write = 0;
                mem_address = {address[7:5], address[4:2]};  //sending address for requesting data
                mem_writedata = 32'dx;
              
				
            end
			CACHE_WRITE :			
			begin
			
			  mem_read = 0;
              mem_write = 0;
              mem_address = 6'dx;
              mem_writedata = 32'dx;
              
			  //writing into cache with readdata from datamemory
			  #1;
			  cache_array[address[4:2]][0] = mem_readdata[7:0];   
			  cache_array[address[4:2]][1] = mem_readdata[15:8];
			  cache_array[address[4:2]][2] = mem_readdata[23:16];
			  cache_array[address[4:2]][3] = mem_readdata[31:24];
			  tagarray[address[4:2]]= {address[7],address[6],address[5]};
			  valid[address[4:2]]= 1;   //updating valid bit

			end
			MEM_WRITE :
			begin
			    busywait = 1;   
			    mem_read = 0;
                mem_write = 1;    //setting memory read signal high
                mem_address ={tagarray[address[4:2]], address[4:2]}; //sending address of cache block whish is dirty
				
				//sending data to data memory to write
                mem_writedata = {cache_array[address[4:2]][3],cache_array[address[4:2]][2],cache_array[address[4:2]][1],cache_array[address[4:2]][0]}; 
              
			
			end
            
        endcase
    end
integer i,j,k;

     // initializing dirty valid and tag arrays at reset
    always @(posedge reset)
    begin

			
			 for (i=0;i<8; i=i+1) 
            valid[i] = 0;
			
			for (j=0;j<8; j=j+1)
            dirty[j] = 0;
						
			 busywait = 0;
	            			  
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



