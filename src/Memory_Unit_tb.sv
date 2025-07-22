`timescale 1ns / 1ps
module Memory_Unit_tb;
  //internal signals
  logic [7:0] addr;
  logic write_en, en_0, en_1, clk, rst;
  logic [31:0] data_in;
  logic [31:0] data_out, output_port;

  // Instantiate DUT
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
    
    clk = 0;
    rst = 1;
    addr = 0;
    write_en = 0;
    en_0 = 0;
    en_1 = 0;
    data_in = 0;

    #10 rst = 0;

    // === Write to RAM at 0x00 ===
    addr = 8'h00;
    data_in = 32'h12345678;
    write_en = 1;
    #10 write_en = 0;
    #10;

    // === Read from RAM at 0x00 ===
    addr = 8'h00;
    #10;
    $display("RAM[0x00] Read: %h", data_out);

    // === Write to Port 0 (FD) ===
    addr = 8'hFD;
    data_in = 32'hDEADBEEF;
    en_0 = 1;
    #10 en_0 = 0;
    #10;

    // === Read from Port 0 ===
    addr = 8'hFD;
    #10 $display("Port0 Read: %h", data_out);

    // === Write to Port 1 (FE) ===
    addr = 8'hFE;
    data_in = 32'hCAFEBABE;
    en_1 = 1;
    #10 en_1 = 0;
    #10;

    // === Read from Port 1 ===
    addr = 8'hFE;
    #10 $display("Port1 Read: %h", data_out);

    // === Write to Output Port (FF) ===
    addr = 8'hFF;
    data_in = 32'hAABBCCDD;
    write_en = 1;
    #10 write_en = 0;
    #10;

    // === Check Output Port ===
    $display("Output Port: %h", output_port);

    

    // Write to 0x10
    addr = 8'h10;
    data_in = 32'h11111111;
    write_en = 1;
    #10 write_en = 0;
    #10;

    // Read from 0x10
    addr = 8'h10;
    #10 $display("RAM[0x10] Read: %h", data_out);

    // Write to 0x40
    addr = 8'h40;
    data_in = 32'h22222222;
    write_en = 1;
    #10 write_en = 0;
    #10;

    // Read from 0x40
    addr = 8'h40;
    #10 $display("RAM[0x40] Read: %h", data_out);

    // Write to 0x80
    addr = 8'h80;
    data_in = 32'h33333333;
    write_en = 1;
    #10 write_en = 0;
    #10;

    // Read from 0x80
    addr = 8'h80;
    #10 $display("RAM[0x80] Read: %h", data_out);

    // Write to 0xC0
    addr = 8'hC0;
    data_in = 32'h44444444;
    write_en = 1;
    #10 write_en = 0;
    #10;

    // Read from 0xC0
    addr = 8'hC0;
    #10 $display("RAM[0xC0] Read: %h", data_out);

    $finish;
  end

endmodule
