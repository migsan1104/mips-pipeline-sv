`timescale 1ns / 1ps

module RAM_tb;

    localparam ADDR_WIDTH = 10;  // 1024 bytes
    localparam DATA_WIDTH = 32;

    // DUT signals
    logic clk;
    logic mem_write;
    logic mem_read;
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] write_data;
    logic [DATA_WIDTH-1:0] read_data;

    // Instantiate the RAM
    RAM #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    initial begin
        $display("=== RAM Testbench Start ===");

        // Initialize
        clk = 0;
        mem_write = 0;
        mem_read = 0;
        addr = 0;
        write_data = 0;

        // Wait for a few cycles
        #12;

        // === Write to address 0 ===
        addr = 10'd0;
        write_data = 32'hDEADBEEF;
        mem_write = 1;
        #10;
        mem_write = 0;

        // === Read from address 0 ===
        #2;
        addr = 10'd0;
        mem_read = 1;
        #1;  // allow time for read_data to propagate
        $display("Read data @ addr 0 = %h (expected DEADBEEF)", read_data);
        mem_read = 0;

        // === Write to address 4 ===
        #8;
        addr = 10'd4;
        write_data = 32'hCAFEBABE;
        mem_write = 1;
        #10;
        mem_write = 0;

        // === Read from address 4 ===
        #2;
        addr = 10'd4;
        mem_read = 1;
        #1;
        $display("Read data @ addr 4 = %h (expected CAFEBABE)", read_data);
        mem_read = 0;

        $display("=== RAM Testbench End ===");
        $finish;
    end

endmodule

