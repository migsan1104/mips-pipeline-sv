`timescale 1ns / 1ps

module RAM_tb;

    // Standard 256x32
    localparam ADDR_WIDTH = 5;
    localparam DATA_WIDTH = 32;

    // Testbench signals
    logic clk;
    logic mem_write;
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] write_data;
    logic [DATA_WIDTH-1:0] read_data;

    // Instantiate RAM
    RAM #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .MEM_INIT_FILE("")
    ) dut (
        .clk(clk),
        .mem_write(mem_write),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation
    always #5 clk = ~clk;

    
    initial begin
        $display("=== RAM Testbench Start ===");
			//all values begin as zero
        clk = 0;
        mem_write = 0;
        addr = 0;
        write_data = 0;

        // Wait for global reset
        #10;

        // Write to address 0x03
        addr = 5'd3;
        write_data = 32'hDEADBEEF;
        mem_write = 1;
        #10;

        // Disable write
        mem_write = 0;
        #10;

        // Read back from address 0x03
        addr = 5'd3;
        #5;
        $display("Read data at addr 3 = %h (expected: DEADBEEF)", read_data);

        // Write to address 0x04
        addr = 5'd4;
        write_data = 32'hCAFEBABE;
        mem_write = 1;
        #10;

        mem_write = 0;
        #10;

        // Read from address 0x04
        addr = 5'd4;
        #5;
        $display("Read data at addr 4 = %h (expected: CAFEBABE)", read_data);

        // Test is now done
        $display("=== RAM Testbench End ===");
        $finish;
    end

endmodule
