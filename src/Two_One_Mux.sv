module Two_One_Mux #(parameter data_width = 32)( input logic [data_width - 1:0] data0,data1, input logic sel, output logic [data_width - 1:0] out);
always_comb begin
	case(sel)
	1'b0: out = data0;
	1'b1:  out = data1;
	default: out = 0;
	endcase

end
endmodule