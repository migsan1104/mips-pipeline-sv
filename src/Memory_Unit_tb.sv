`timescale 1ns / 1ps
module Memory_Unit_tb;

  // Internal signals
  logic [9:0] addr;                  // Byte address (10 bits)
  logic write_en, en_0, en_1, clk, rst;
  logic [31:0] data_in;
  logic [31:0] data_out, output_port;

  Memory_Unit dut (
    .addr(addr),
    .write_en(write_en),
    .en_0(en_0),
    .en_1(en_1),
    .clk(clk),
    .rst(rst),
    .data_out(data_out),
    .output_port(output_port),
    .data_in(data_in)
  );

  // Clock 
  always #5 clk = ~clk;

  initial begin
    $display("=== Byte-Aligned Memory_Unit Testbench ===");

    clk = 0;
    rst = 1;
    addr = 10'h000;
    write_en = 0;
    en_0 = 0;
    en_1 = 0;
    data_in = 32'h0;

    #10 rst = 0;

    // === Write to RAM at 0x000 ===
    addr = 10'h000;
    data_in = 32'h12345678;
    write_en = 1;
    #10 write_en = 0;

    // === Read from RAM at 0x000 ===
    addr = 10'h000;
    #10;
    $display("Read RAM[0x000] = %h (expected: 12345678)", data_out);

    // === Write to Input Port 0 at 0x3F4 ===
    addr = 10'h3F4;
    data_in = 32'hDEADBEEF;
    en_0 = 1;
    #10 en_0 = 0;

    // === Read from Input Port 0 at 0x3F4 ===
    addr = 10'h3F4;
    #10;
    $display("Read Port0 (0x3F4) = %h (expected: DEADBEEF)", data_out);

    // === Write to Input Port 1 at 0x3F8 ===
    addr = 10'h3F8;
    data_in = 32'hCAFEBABE;
    en_1 = 1;
    #10 en_1 = 0;

    // === Read from Input Port 1 at 0x3F8 ===
    addr = 10'h3F8;
    #10;
    $display("Read Port1 (0x3F8) = %h (expected: CAFEBABE)", data_out);

    // === Write to Output Port at 0x3FC ===
    addr = 10'h3FC;
    data_in = 32'hAABBCCDD;
    write_en = 1;
    #10 write_en = 0;

    // === Check Output Port ===
    $display("Output Port (0x3FC) = %h (expected: AABBCCDD)", output_port);

    // === Additional RAM checks ===
    addr = 10'h010;
    data_in = 32'h11111111;
    write_en = 1;
    #10 write_en = 0;
    addr = 10'h010;
    #10 $display("Read RAM[0x010] = %h (expected: 11111111)", data_out);

    addr = 10'h040;
    data_in = 32'h22222222;
    write_en = 1;
    #10 write_en = 0;
    addr = 10'h040;
    #10 $display("Read RAM[0x040] = %h (expected: 22222222)", data_out);

    addr = 10'h080;
    data_in = 32'h33333333;
    write_en = 1;
    #10 write_en = 0;
    addr = 10'h080;
    #10 $display("Read RAM[0x080] = %h (expected: 33333333)", data_out);

    addr = 10'h0C0;
    data_in = 32'h44444444;
    write_en = 1;
    #10 write_en = 0;
    addr = 10'h0C0;
    #10 $display("Read RAM[0x0C0] = %h (expected: 44444444)", data_out);

    $display("=== Byte-Aligned Memory_Unit Testbench End ===");
    $finish;
  end

endmodule
