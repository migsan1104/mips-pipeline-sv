module RAM#(
    parameter ADDR_WIDTH = 10, // 256 words
    parameter DATA_WIDTH = 32, // words are 4 bytes long
    parameter MEM_INIT_FILE = "Temp.hex"
)(
    input  logic                  clk,
    input  logic                  mem_write,
    input  logic [ADDR_WIDTH-1:0] addr,       
    input  logic [DATA_WIDTH-1:0] write_data,
    output logic [DATA_WIDTH-1:0] read_data
);

    logic [7:0] mem_array [0:(1<<ADDR_WIDTH)-1];  // Byte-addressed memory

    // reading as 4 seperate bytes , big endian 
    assign read_data = {
        mem_array[addr],
        mem_array[addr + 1],
        mem_array[addr + 2],
        mem_array[addr + 3]
    };

    // Write 32-bit word as 4 separate bytes
    always_ff @(posedge clk) begin
        if (mem_write) begin
            mem_array[addr]     <= write_data[31:24];
            mem_array[addr + 1] <= write_data[23:16];
            mem_array[addr + 2] <= write_data[15:8];
            mem_array[addr + 3] <= write_data[7:0];
        end
    end

    initial begin
        if (MEM_INIT_FILE != "") begin
            $display("Loading memory from: %s", MEM_INIT_FILE);
            $readmemh(MEM_INIT_FILE, mem_array);
        end
    end

endmodule

