module Two_One_Mux ( input logic [31:0] data0,data1, input logic sel, output logic [31:0] out);
always_comb begin
	case(sel)
	1'b0: out = data0;
	1'b1:  out = data1;
	default: out = 32'b0;
	endcase

end
endmodule