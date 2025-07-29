module Register_File(input logic clk,rst,JumpAndLink,wr_en,input logic [4:0] rd_addr0,rd_addr1,wr_addr,input logic [31:0] wr_data,link_addr, output logic [31:0]  rd_data0,rd_data1);
integer i;
//array of 32 bit registers 
logic [31:0] registers [0:31];

// writing is synch
always@(posedge clk or posedge rst) begin
	if(rst == 1'b1) begin
		for(i = 1; i<32; i = i + 1) begin
			registers[i] = 0;
		end
	end
	else if (wr_en == 1'b1) begin
		if(JumpAndLink == 1'b1) begin
			registers[31] = link_addr;
		end
		else begin
			if(wr_addr != 5'b00000) begin
				registers[wr_addr] = wr_data;
			end
		end
	end
end
// reading is combinational
always_comb begin
	registers[0] = 32'b0;
	rd_data0 = registers[rd_addr0];
	rd_data1 = registers[rd_addr1];
end
endmodule
