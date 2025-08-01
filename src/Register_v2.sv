module Register_v2#(parameter data_width = 32)(input logic [data_width - 1:0]  data,input logic rst,clk,en,flush, output logic [data_width - 1:0] out);
// special register only used to instruction reg, IF_ID, incorporate flush
always_ff@(posedge clk or posedge rst) begin
	if(rst) begin
		out <= 0;
	end
	else begin
		if(flush == 1'b1) out <= {data_width{1'b0}};

		else if(en) out <= data;
		
	end

end
endmodule
