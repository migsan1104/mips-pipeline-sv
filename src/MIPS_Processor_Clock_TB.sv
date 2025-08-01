`timescale 1ns/1ps  
module MIPS_Processor_Clock_TB;

    
    logic clk;
    logic rst;
    logic button0;
    logic button1;
    logic [9:0] switches;

    
    logic [41:0] LEDs;

    //device under testing
    MIPS_Processor  #(.ADDR_WIDTH(10),.ROM_INIT("TestCase1_Instructions.hex"),.RAM_INIT("TestCase1_Data.hex")) dut  (
        .clk(clk),
        .rst(rst),
        .button0(button0),
        .button1(button1),
        .switches(switches),
        .LEDs(LEDs)
    );

    
    initial clk = 0;
    always #5 clk = ~clk;
	 
    initial begin
       
        rst      = 1;
        button0  = 1;
        button1  = 0;
        switches = 10'b0111111111;
		  #5 rst = 0;
        
        

       
        

        
    end

endmodule
