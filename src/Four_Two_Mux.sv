module Four_Two_Mux (input logic [32:0] data0,data1,data2,data3, input logic[1:0] sel, output logic [31:0] out);
always_comb begin
	case(sel) 
	2'b00:out <= data0;
	2'b01: out <= data1;
	2'b10: out <= data2;
	2'b11:out <= data3;
	default: out <= data0;
	endcase

end
endmodule