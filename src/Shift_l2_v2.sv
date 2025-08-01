module Shift_l2_v2 (input [25:0] data, output logic [27:0] out);
assign out = {data,2'b0};
endmodule