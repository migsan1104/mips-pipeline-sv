module ALU_Control(input logic [5:0] alu_con,funct, output logic [5:0] op_sel, output logic [1:0] alu_lo_hi, output logic hi_en,lo_en);
//funct codes
localparam [5:0] HALT     = 6'b111111;
localparam [5:0] ADDU     = 6'b100001;
localparam [5:0] SUBU     = 6'b100011;
localparam [5:0] MULTU    = 6'b011001;
localparam [5:0] MULT     = 6'b011000;
localparam [5:0] L_R_S    = 6'b000010;
localparam [5:0] A_R_S    = 6'b000011;
localparam [5:0] S_O_L    = 6'b101010;
localparam [5:0] S_O_L_U  = 6'b101011;
localparam [5:0] AND1     = 6'b100100;
localparam [5:0] OR1      = 6'b100101;
localparam [5:0] XOR1     = 6'b100110;
localparam [5:0] SL       = 6'b000000;

//these codes are sent as alu_control signals to tell the alu control unit what type of branch we want



// comb logic for control unit
always_comb begin
	// initialize outputs to avoid latches
	hi_en = 1'b0;
	lo_en = 1'b0;
	alu_lo_hi = 2'b0;
	op_sel = HALT;
	// outputs are decided
	case(alu_con) 
		6'b0: op_sel = ADDU;
		6'b000001: op_sel = SUBU;
		6'b000010: begin
			 if(funct == MULT || funct == MULTU) begin
				hi_en = 1'b1;
			   lo_en = 1'b1;
				end
			 op_sel = funct;
			 if(funct == 6'h12) begin
				op_sel = HALT; alu_lo_hi = 2'b01;
				end
			 if(funct == 6'h10) begin
				op_sel = HALT; alu_lo_hi = 2'b10;
				end
			end
		6'h09 : op_sel = ADDU;
		6'h10 : op_sel = SUBU;
		6'h0C : op_sel = AND1;
		6'h0D : op_sel = OR1;
		6'h0E : op_sel = XOR1;
		6'h0A : op_sel = S_O_L;
		6'h0B : op_sel = S_O_L_U;
		6'h0F : op_sel = HALT;
		default : begin end
	endcase
	
end
endmodule
	