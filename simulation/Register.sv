module Register(input logic [31:0]  data,input logic rst,clk,en, output logic [31:0] out);

always_ff@(posedge clk or posedge rst) begin
	if(rst) begin
		out <= 32'b0;
	end
	else begin
		if(en) out <= data;
		
	end

end
endmodule
