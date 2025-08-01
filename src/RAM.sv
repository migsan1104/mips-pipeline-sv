module RAM#(
    parameter ADDR_WIDTH = 10, // 256 words
    parameter MEM_INIT_FILE = "ram_test_init.hex "
)(
    input  logic                  clk,
    input  logic                  mem_write,
	 
    input  logic [ADDR_WIDTH-1:0] addr,
	 
	    
    input  logic [31:0] write_data,
	 input logic mem_read,
    output logic [31:0] read_data
);

    logic [7:0] mem_array [0:(1<<ADDR_WIDTH)-1];  // Byte-addressed memory(Byte-allignment)

   

    // Write 32-bit word as 4 separate bytes
    always_ff @(posedge clk) begin
        if (mem_write) begin
            mem_array[addr]     <= write_data[31:24];
            mem_array[addr + 1] <= write_data[23:16];
            mem_array[addr + 2] <= write_data[15:8];
            mem_array[addr + 3] <= write_data[7:0];
        end
    end
	 // comb logic for data memory, reading four bytes, big endian
	 always_comb begin
		if(mem_read) begin
		  read_data = {
        mem_array[addr],
        mem_array[addr + 1],
        mem_array[addr + 2],
        mem_array[addr + 3]
			};
		end
		else read_data = 32'b0;
	 
	 end

    initial begin
        if (MEM_INIT_FILE != "") begin
            $display("Loading memory from: %s", MEM_INIT_FILE);
            $readmemh(MEM_INIT_FILE, mem_array);
        end
    end

endmodule

