module Register#(parameter data_width = 32)(input logic [data_width - 1:0]  data,input logic rst,clk,en, output logic [data_width - 1:0] out);

always_ff@(posedge clk or posedge rst) begin
	if(rst) begin
		out <= 0;
	end
	else begin
		if(en) out <= data;
		
	end

end
endmodule
