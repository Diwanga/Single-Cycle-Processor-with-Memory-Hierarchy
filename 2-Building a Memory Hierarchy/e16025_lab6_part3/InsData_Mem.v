`timescale  1ns/100ps
/*
Program	: 256x8-bit data memory (16-Byte blocks)
Author	: Isuru Nawinne
Date	: 10/06/2020

Description	:

This program presents a primitive instruction memory module for CO224 Lab 6 - Part 3
This memory allows instructions to be read as 16-Byte blocks
*/

module InsData_memory(
    clock,
    read,
    address,
    readdata,
    busywait
);
input               clock;
input               read;
input[5:0]          address;
output reg [127:0]  readdata;
output reg          busywait;

reg readaccess;

//Declare memory array 1024x8-bits 
reg [7:0] memory_array [1023:0];

//Initialize instruction memory
initial
begin
    busywait = 0;
    readaccess = 0;
 
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//instruction encodings

// loadi 	= "00001000";
// mov   	= "00000000";
// add 	    = "00000001";
// sub  	= "00001001";
// and 	    = "00000010";
// or   	= "00000011";
// j		= "00010100";
// beq  	= "00010001"; 
// lwd 	    = "00010000";
// lwi    	= "00011000";
// swd   	= "00110000";
// swi 	    = "00101000";
 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
	////INSTRUCTION SET 01 
	
   {memory_array[10'd3],  memory_array[10'd2],  memory_array[10'd1],  memory_array[10'd0]}  = 32'b00001000000000010000000000000100;  // loadi 1 0x04
   {memory_array[10'd7],  memory_array[10'd6],  memory_array[10'd5],  memory_array[10'd4]}  = 32'b00001000000000100000000000000101;	 // loadi 2 0x05
   {memory_array[10'd11], memory_array[10'd10], memory_array[10'd9],  memory_array[10'd8]}  = 32'b00101000000000000000001000000001;  // swi 2 0x01   >>Write miss no dirty
   {memory_array[10'd15], memory_array[10'd14], memory_array[10'd13], memory_array[10'd12]} = 32'b00101000000000000000000100001001;  // swi 1 0x09   >>Write miss no dirty
   {memory_array[10'd19], memory_array[10'd18], memory_array[10'd17], memory_array[10'd16]} = 32'b00011000000001000000000000000001;  // lwi 4 0x01   >>Read hit
   
   {memory_array[10'd23], memory_array[10'd22], memory_array[10'd21], memory_array[10'd20]} = 32'b00011000000001010000000000001001;  // lwi 5 0x09   >>Read hit  
   {memory_array[10'd27], memory_array[10'd26], memory_array[10'd25], memory_array[10'd24]} = 32'b00000001000000000000010100000100;  // add 0 5 4   
   {memory_array[10'd31], memory_array[10'd30], memory_array[10'd29], memory_array[10'd28]} = 32'b00001000000001100000000000001001;  // loadi 6 0x09
   {memory_array[10'd35], memory_array[10'd34], memory_array[10'd33], memory_array[10'd32]} = 32'b00001000000001010000000000000001;  // loadi 5 0x01
   {memory_array[10'd39], memory_array[10'd38], memory_array[10'd37], memory_array[10'd36]} = 32'b00010001111111000000011000000000;  // beq 0xFC 6 0 >>reg 6 0 equal? if yes>go to 4 instruction backward   
   {memory_array[10'd43], memory_array[10'd42], memory_array[10'd41], memory_array[10'd40]} = 32'b00000001000001000000011000000000;  // add 4 6 0

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	//INSTRUCTION SET 02 ( with all memory related instruction )
   
   // {memory_array[10'd3],  memory_array[10'd2],  memory_array[10'd1],  memory_array[10'd0]}  = 32'b00001000000000010000000000000100;  // loadi 1 0x04
   // {memory_array[10'd7],  memory_array[10'd6],  memory_array[10'd5],  memory_array[10'd4]}  = 32'b00001000000000100000000000000101;	 // loadi 2 0x05
   // {memory_array[10'd11], memory_array[10'd10], memory_array[10'd9],  memory_array[10'd8]}  = 32'b00101000000000000000001000000001;  // swi 2 0x01    >>Write miss no dirty
   // {memory_array[10'd15], memory_array[10'd14], memory_array[10'd13], memory_array[10'd12]} = 32'b00101000000000000000000100001001;  // swi 1 0x09    >>Write miss no dirty
   // {memory_array[10'd19], memory_array[10'd18], memory_array[10'd17], memory_array[10'd16]} = 32'b00011000000001000000000000000001;  // lwi 4 0x01    >>Read hit
   
   // {memory_array[10'd23], memory_array[10'd22], memory_array[10'd21], memory_array[10'd20]} = 32'b00011000000001010000000000001001;  // lwi 5 0x09    >>Read hit  
   // {memory_array[10'd27], memory_array[10'd26], memory_array[10'd25], memory_array[10'd24]} = 32'b00000001000000000000010100000100;  // add 0 5 4   
   // {memory_array[10'd31], memory_array[10'd30], memory_array[10'd29], memory_array[10'd28]} = 32'b00001000000001110000000000000001;  // loadi 7 0x01
   // {memory_array[10'd35], memory_array[10'd34], memory_array[10'd33], memory_array[10'd32]} = 32'b00010000000000110000000000000111;  // lwd 3 7       >>Read hit
   // {memory_array[10'd39], memory_array[10'd38], memory_array[10'd37], memory_array[10'd36]} = 32'b00110000000000000000001000000001;  // swd 2 1       >>Write miss no dirty
   
   // {memory_array[10'd43], memory_array[10'd42], memory_array[10'd41], memory_array[10'd40]} = 32'b00101000000000000000001100100001;	 // swi 3 0x21    >>Write miss with dirty
   // {memory_array[10'd47], memory_array[10'd46], memory_array[10'd45], memory_array[10'd44]} = 32'b00000001000000110000001100000000;  // add 3 3 0
   // {memory_array[10'd51], memory_array[10'd50], memory_array[10'd49], memory_array[10'd48]} = 32'b00001000000000000000000000000001;  // loadi 0 0x01
   // {memory_array[10'd55], memory_array[10'd54], memory_array[10'd53], memory_array[10'd52]} = 32'b00010000000001010000000000000000;  // lwd 5 0        >>Read miss with dirty
   // {memory_array[10'd59], memory_array[10'd58], memory_array[10'd57], memory_array[10'd56]} = 32'b00000001000001110000010100000000;  // add 7 5 0   
   
   // {memory_array[10'd63], memory_array[10'd62], memory_array[10'd61], memory_array[10'd60]} = 32'b00101000000000000000011100000001;  // swi 7 0x01     >>Write hit
   // {memory_array[10'd67], memory_array[10'd66], memory_array[10'd65], memory_array[10'd64]} = 32'b00011000000001100000000000000001;  // lwi 6 0x01     >>Read hit
   // {memory_array[10'd71], memory_array[10'd70], memory_array[10'd69], memory_array[10'd68]} = 32'b00000001000001100000011000000001;  // add 6 6 1
  
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  // INSTRUCTION SET 03 ( with all flow control instruction )

   // {memory_array[10'd3],  memory_array[10'd2],  memory_array[10'd1],  memory_array[10'd0]}  = 32'b00001000000001100000000000010010;  // loadi   6  0x12 
   // {memory_array[10'd7],  memory_array[10'd6],  memory_array[10'd5],  memory_array[10'd4]}  = 32'b00001000000001010000000000010010;	 // loadi   5  0x12 
   // {memory_array[10'd11], memory_array[10'd10], memory_array[10'd9],  memory_array[10'd8]}  = 32'b00010001000000100000011000000101;  // beq 0x02 6 5
   // {memory_array[10'd15], memory_array[10'd14], memory_array[10'd13], memory_array[10'd12]} = 32'b00001000000000010000000000011110;  //loadi   1  0x1E 
   // {memory_array[10'd19], memory_array[10'd18], memory_array[10'd17], memory_array[10'd16]} = 32'b00001000000001110000000000011100;  //loadi   7  0x1C
   
   // {memory_array[10'd23], memory_array[10'd22], memory_array[10'd21], memory_array[10'd20]} = 32'b00000010000000110000010100000110;  //and 3 5 6
   // {memory_array[10'd27], memory_array[10'd26], memory_array[10'd25], memory_array[10'd24]} = 32'b00000011000000100000010100000110;  //or 2 5 6
   // {memory_array[10'd31], memory_array[10'd30], memory_array[10'd29], memory_array[10'd28]} = 32'b00000001000001000000010100000110;  //add 4 5 6
   // {memory_array[10'd35], memory_array[10'd34], memory_array[10'd33], memory_array[10'd32]} = 32'b00010100111111100000000000000000;  // j   0xFE   
   // {memory_array[10'd39], memory_array[10'd38], memory_array[10'd37], memory_array[10'd36]} = 32'b00001000000000110000000011001110;  // loadi  3  0xCE

 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
end

//Detecting an incoming memory access
always @(read)
begin
    busywait = (read)? 1 : 0;
    readaccess = (read)? 1 : 0;
end

//Reading
always @(posedge clock)
begin
    if(readaccess)
    begin
        readdata[7:0]     = #40 memory_array[{address,4'b0000}];
        readdata[15:8]    = #40 memory_array[{address,4'b0001}];
        readdata[23:16]   = #40 memory_array[{address,4'b0010}];
        readdata[31:24]   = #40 memory_array[{address,4'b0011}];
        readdata[39:32]   = #40 memory_array[{address,4'b0100}];
        readdata[47:40]   = #40 memory_array[{address,4'b0101}];
        readdata[55:48]   = #40 memory_array[{address,4'b0110}];
        readdata[63:56]   = #40 memory_array[{address,4'b0111}];
        readdata[71:64]   = #40 memory_array[{address,4'b1000}];
        readdata[79:72]   = #40 memory_array[{address,4'b1001}];
        readdata[87:80]   = #40 memory_array[{address,4'b1010}];
        readdata[95:88]   = #40 memory_array[{address,4'b1011}];
        readdata[103:96]  = #40 memory_array[{address,4'b1100}];
        readdata[111:104] = #40 memory_array[{address,4'b1101}];
        readdata[119:112] = #40 memory_array[{address,4'b1110}];
        readdata[127:120] = #40 memory_array[{address,4'b1111}];
        busywait = 0;
        readaccess = 0;
    end
end
 
endmodule