`timescale 1ns / 1ps

module RAM_tb;

    localparam ADDR_WIDTH = 10;  // 1024 bytes = 256 words
    localparam DATA_WIDTH = 32;

    // Testbench signals
    logic clk;
    logic mem_write;
    logic [ADDR_WIDTH-1:0] addr;       // Byte address
    logic [DATA_WIDTH-1:0] write_data;
    logic [DATA_WIDTH-1:0] read_data;


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
        $display("=== ByteRAM Testbench Start ===");
        
        // Initialize inputs
        clk = 0;
        mem_write = 0;
        addr = 0;
        write_data = 0;

        // Wait for global reset
        #10;

        // Write 0xDEADBEEF to byte-aligned address 0
        addr = 6'd0;                     // address must be aligned to 4
        write_data = 32'hDEADBEEF;
        mem_write = 1;
        #10;

        // Disable write
        mem_write = 0;
        #10;

        // Read from byte address 0
        addr = 6'd0;
        #5;
        $display("Read data at addr 0 = %h (expected: DEADBEEF)", read_data);

        // Write 0xCAFEBABE to address 4
        addr = 6'd4;
        write_data = 32'hCAFEBABE;
        mem_write = 1;
        #10;

        mem_write = 0;
        #10;

        // Read from byte address 4
        addr = 6'd4;
        #5;
        $display("Read data at addr 4 = %h (expected: CAFEBABE)", read_data);

        $display("=== ByteRAM Testbench End ===");
        $finish;
    end

endmodule
