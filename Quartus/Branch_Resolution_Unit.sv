module Branch_Resolution_Unit (input logic branch,input logic [32:0] input0,input1, input logic [5:0] Branch_Code, output logic branch_taken);
// Branch Codes
localparam [5:0] BEQ_code = 6'h03;
localparam [5:0] BNE_code = 6'h04;
localparam [5:0] BLEZ_code = 6'h07;
localparam [5:0] BGTZ_code = 6'h0F;
localparam [5:0] BGEZ_code = 6'h11;
localparam [5:0] BLTZ_code = 6'h13;
always_comb begin
	//initializing output to 0 to avoid latches
	branch_taken = 1'b0;
	if(branch) begin
	case(Branch_Code) 
	       BNE_code     : if (input1 != input2) branch_taken = 1'b1;
          BEQ_code     : if (input1 == input2) branch_taken = 1'b1;
          BGEZ_code    : if ($signed(input1) >= 0) branch_taken = 1'b1;
          BLTZ_code    : if ($signed(input1) < 0) branch_taken = 1'b1;
          BLEZ_code    : if ($signed(input1) <= 0) branch_taken = 1'b1;
          BGTZ_code    : begin
                if ($signed(input1) > 0) branch_taken = 1'b1;
                end
	default: branch_taken = 1'b0;
	endcase
	end
end
endmodule