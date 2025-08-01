module Register_File(
    input  logic        clk, rst, JumpAndLink, wr_en,
    input  logic [4:0]  rd_addr0, rd_addr1, wr_addr,
    input  logic [31:0] wr_data, link_addr,
    output logic [31:0] rd_data0, rd_data1
);
    integer i;
    logic [31:0] registers [0:31];

    // synchronous write, jump and link not dependent on write enable, zero reg is also protected.
	always_ff @(posedge clk or posedge rst) begin
	    i = 1;
		if (rst) begin
			for (i = 1; i < 32; i = i + 1)
            registers[i] <= 32'b0;
		end else begin
        if (JumpAndLink)
            registers[31] <= link_addr; 
        else if (wr_en && wr_addr != 5'd0)
            registers[wr_addr] <= wr_data;
		end
	end


    // combinational read , we are able to read and write in the same clock edge. Really helpful as now we dont have to forward as much.
    always_comb begin
        // Read port 0
        if (rd_addr0 == 5'd0) begin
            rd_data0 = 32'b0;
        end else if (wr_en && JumpAndLink && rd_addr0 == 5'd31) begin
            rd_data0 = link_addr;
        end else if (wr_en && !JumpAndLink && rd_addr0 == wr_addr) begin
            rd_data0 = wr_data;
        end else begin
            rd_data0 = registers[rd_addr0];
        end

        // Read port 1
        if (rd_addr1 == 5'd0) begin
            rd_data1 = 32'b0;
        end else if (wr_en && JumpAndLink && rd_addr1 == 5'd31) begin
            rd_data1 = link_addr;
        end else if (wr_en && !JumpAndLink && rd_addr1 == wr_addr) begin
            rd_data1 = wr_data;
        end else begin
            rd_data1 = registers[rd_addr1];
        end
    end
endmodule


