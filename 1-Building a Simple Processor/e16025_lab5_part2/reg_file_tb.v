

module reg_file_tb;
    
    reg [7:0] WRITEDATA;
    reg [2:0] WRITEREG, READREG1, READREG2;
    reg CLK, RESET, WRITEENABLE; 
    wire [7:0] REGOUT1, REGOUT2;
    
	//instatntiate reg_file as myregfile 
    reg_file myregfile(WRITEDATA, REGOUT1, REGOUT2, WRITEREG, READREG1, READREG2, WRITEENABLE, CLK, RESET);
       
    initial
    begin
        CLK = 1'b1;
        
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("reg_file_wavedata.vcd");
		$dumpvars(0, reg_file_tb);
        
        // assign values with time to input signals to see output of register
		
        RESET = 1'b0;
        WRITEENABLE = 1'b0;
        
        #1
        RESET = 1'b1;       //resetting initially
        READREG1 = 3'd0;
        READREG2 = 3'd4;
        
        #8
        RESET = 1'b0;
      
	  
        #5
        WRITEREG = 3'd2;
        WRITEDATA = 8'd36;
        WRITEENABLE = 1'b1;
        
        #10
        WRITEENABLE = 1'b0;
        
        #1
        READREG1 = 3'd2;
        
        #9
        WRITEREG = 3'd1;      
        WRITEDATA = 8'd85;
        WRITEENABLE = 1'b1;
        READREG1 = 3'd1;
        
        #10
        WRITEENABLE = 1'b0;
        
        #10
        WRITEREG = 3'd4;
        WRITEDATA = 8'd21;
        WRITEENABLE = 1'b1;
        
        #10
        WRITEDATA = 8'd15;
        WRITEENABLE = 1'b1;
        
        #10
        WRITEENABLE = 1'b0;
        
        #6
        WRITEREG = 3'd1;
        WRITEDATA = 8'd12;
        WRITEENABLE = 1'b1;
        
        #5
        WRITEENABLE = 1'b0;
        
		 #6
        WRITEREG = 3'd5;
        WRITEDATA = 8'd44;
        WRITEENABLE = 1'b1;
		 READREG1 = 3'd5;
        
        #10
        WRITEENABLE = 1'b0;
		
        #10
        $finish;         //to stop running continuously
    end
    
     always begin      //generating clock signal

             #5;
             CLK = ~CLK;
            end 
endmodule
