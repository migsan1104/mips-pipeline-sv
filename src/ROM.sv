module ROM#(
    parameter ADDR_WIDTH = 10, // 256 words
    parameter DATA_WIDTH = 32, // words are 4 bytes long
    parameter MEM_INIT_FILE = "Temp.hex"
)(
    
    input  logic [ADDR_WIDTH-1:0] addr,
	 
	    
	
    output logic [DATA_WIDTH-1:0] read_data
);

    logic [7:0] mem_array [0:(1<<ADDR_WIDTH)-1];  // Byte-addressed memory(Byte-allignment)

   

	  //reading 4 bytes big endian
	  assign read_data = {
        mem_array[addr],
        mem_array[addr + 1],
        mem_array[addr + 2],
        mem_array[addr + 3]
			};
		

    initial begin
        if (MEM_INIT_FILE != "") begin
            $display("Loading memory from: %s", MEM_INIT_FILE);
            $readmemh(MEM_INIT_FILE, mem_array);
        end
    end

endmodule
