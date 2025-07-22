module Memory_Unit(input logic [7:0] addr,input logic write_en, en_0,en_1,clk,rst, output logic [31:0] data_out,output_port, input logic [31:0] data_in);

//internal signals
logic [1:0] sel;
logic [31:0] data_im,port0_data,port1_data;
logic en,out_en;
//creating components
RAM memory(.addr(addr),.clk(clk),.mem_write(en),.write_data(data_in)
,.read_data(data_im));

Register port0(.clk(clk),.data(data_in),.out(port0_data),
.en(en_0),.rst(rst));

Register port1(.clk(clk),.data(data_in),.out(port1_data),
.en(en_1),.rst(rst));

Register out_port(.clk(clk),.data(data_in),.out(output_port),
.en(out_en),.rst(rst));

Four_Two_Mux MUX (.sel(sel),.data0(data_im),.data1(port0_data),.data2(port1_data),.data3(32'b0), .out(data_out));
//comb logic 
always_comb begin
	case (addr)
	8'hFD:sel = 2'b01;
	8'hFE:sel = 2'b10;
	default: sel = 2'b0;
	endcase
end
always_comb begin
	en = 1'b1;
	out_en = 1'b0;
	if(write_en == 1'b1 && addr == 8'hFF) begin
		en = 1'b0; out_en = 1'b1;
	end
end
endmodule
		

