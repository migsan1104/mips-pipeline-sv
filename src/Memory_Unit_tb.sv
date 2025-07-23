`timescale 1ns / 1ps
module Memory_Unit_tb;

  // Local parameters
  localparam ADDR_WIDTH = 10;

  // internal testbench signals
  logic [ADDR_WIDTH-1:0] addr;
  logic write_en, en_0, en_1, clk, rst, mem_read;
  logic [31:0] data_in;
  logic [31:0] data_out, output_port;

  // Instantiate RAM
  Memory_Unit dut (
    .addr(addr),
    .write_en(write_en),
    .en_0(en_0),
    .en_1(en_1),
    .clk(clk),
    .rst(rst),
    .mem_read(mem_read),
    .data_in(data_in),
    .data_out(data_out),
    .output_port(output_port)
  );

  // Clock generation: 10ns period
  always #5 clk = ~clk;

  initial begin
    $display("=== Memory_Unit Testbench Start ===");

    // Initial reset and signal setup
    clk = 0;
    rst = 1;
    addr = 0;
    write_en = 0;
    en_0 = 0;
    en_1 = 0;
    mem_read = 0;
    data_in = 32'h0;

    #10 rst = 0;

    // === Write and Read from RAM at 0x000 ===
    addr = 10'h000;
    data_in = 32'h12345678;
    write_en = 1; mem_read = 0;
    #10 write_en = 0;

    mem_read = 1;
    #10;
    $display("Read RAM[0x000] = %h (expected: 12345678)", data_out);
    mem_read = 0;

    // === Write and Read Port0 ===
    addr = 10'h3F4;
    data_in = 32'hDEADBEEF;
    en_0 = 1; #10 en_0 = 0;

    mem_read = 1;
    #10;
    $display("Read Port0 (0x3F4) = %h (expected: DEADBEEF)", data_out);
    mem_read = 0;

    // === Write and Read Port1 ===
    addr = 10'h3F8;
    data_in = 32'hCAFEBABE;
    en_1 = 1; #10 en_1 = 0;

    mem_read = 1;
    #10;
    $display("Read Port1 (0x3F8) = %h (expected: CAFEBABE)", data_out);
    mem_read = 0;

    // === Write to Output Port (0x3FC) ===
    addr = 10'h3FC;
    data_in = 32'hAABBCCDD;
    write_en = 1; #10 write_en = 0;

    $display("Output Port (0x3FC) = %h (expected: AABBCCDD)", output_port);

    // === More RAM tests ===
    addr = 10'h010;
    data_in = 32'h11111111;
    write_en = 1; #10 write_en = 0;
    mem_read = 1; #10;
    $display("Read RAM[0x010] = %h (expected: 11111111)", data_out);
    mem_read = 0;

    addr = 10'h040;
    data_in = 32'h22222222;
    write_en = 1; #10 write_en = 0;
    mem_read = 1; #10;
    $display("Read RAM[0x040] = %h (expected: 22222222)", data_out);
    mem_read = 0;

    addr = 10'h080;
    data_in = 32'h33333333;
    write_en = 1; #10 write_en = 0;
    mem_read = 1; #10;
    $display("Read RAM[0x080] = %h (expected: 33333333)", data_out);
    mem_read = 0;

    addr = 10'h0C0;
    data_in = 32'h44444444;
    write_en = 1; #10 write_en = 0;
    mem_read = 1; #10;
    $display("Read RAM[0x0C0] = %h (expected: 44444444)", data_out);
    mem_read = 0;

    $display("=== Memory_Unit Testbench End ===");
    $finish;
  end

endmodule

