module Sign_Extend(input logic [15:0] data, input logic is_signed, output logic [31:0] out );

always_comb begin
	if(is_signed) out = {{16{data[15]}},data};
	else out = {16'b0,data};
end
endmodule 