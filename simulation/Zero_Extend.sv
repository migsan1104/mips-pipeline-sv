module Zero_Extend(input logic [15:0] data, output wire [31:0] out);
assign out = {16'b0, data};
endmodule