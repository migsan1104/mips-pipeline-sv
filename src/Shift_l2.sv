module Shift_l2(input logic [31:0] data, output wire [31:0] out);
assign out = {data[29:0], 2'b0};
endmodule