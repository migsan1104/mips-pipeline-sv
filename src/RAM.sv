
module RAM#(
    parameter ADDR_WIDTH = 8, 
    parameter DATA_WIDTH = 32,
	 parameter MEM_INIT_FILE = "Temp.hex"
)(
    input  logic                  clk,
    input  logic                  mem_write,
    input  logic [ADDR_WIDTH-1:0] addr,       
    input  logic [DATA_WIDTH-1:0] write_data,
    output logic [DATA_WIDTH-1:0] read_data
);

    
    logic [DATA_WIDTH-1:0] mem_array [0:(1<<ADDR_WIDTH)-1];

    // Asynchronous read
    assign read_data = mem_array[addr];

    // Synchronous write
    always_ff @(posedge clk) begin
        if (mem_write)
            mem_array[addr] <= write_data;
    end
	 //initializing the ram
    initial begin
        if (MEM_INIT_FILE != "") begin
            $display("Loading memory from: %s", MEM_INIT_FILE);
            $readmemh(MEM_INIT_FILE, mem_array);
        end
    end

endmodule
