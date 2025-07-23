module Control_Unit(input logic [5:0] IR, Funct,input logic clk,rst, output logic reg_write,is_signed,reg_dst,jump,branch,mem_to_reg,mem_write,mem_read,output logic [1:0] alu_sel, output logic [3:0] ALU_Code);
//initializing custom type to represent instruction type;
typedef enum logic [1:0] {R,M,J,B,I} Instruction_type;
//initializing instruction type to perfrom controller logic
Instruction_type IT;
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
localparam [5:0] BLEZ     = 6'b000111;
localparam [5:0] BGTZ     = 6'b001000;
localparam [5:0] AND1     = 6'b100100;
localparam [5:0] OR1      = 6'b100101;
localparam [5:0] XOR1     = 6'b100110;
localparam [5:0] BEQ      = 6'b001001;
localparam [5:0] BNE      = 6'b001010;
localparam [5:0] BGEZ     = 6'b001011;
localparam [5:0] BLTZ     = 6'b001100;
localparam [5:0] SL       = 6'b000000;

always_comb begin
	//initializing all outputs to 0  avoid latches
	reg_write = 1'b0;
	is_signed = 1'b0;
	reg_dst = 1'b0;
	jump = 1'b0;
	branch = 1'b0;
	mem_to_reg = 1'b0;
	mem_write = 1'b0;
	mem_read = 1'b0;
	alu_sel = 2'b0;
	ALU_Code = 4'b0;
	//decoding the instruction and setting the instruction type
	case(IR)
	6'b0: IT = R;
	6'h23: IT = M;
	6'h2B: IT = M;
	6'h04: IT = B;
	6'h05: IT = B;
	6'h06: IT = B;
	6'h07: IT = B;
	6'h01: IT = B;
	6'h02: IT = J;
	6'h03: IT = J;
	default: IT = I;
	endcase
	//We now determine the control unit outputs 
	case(IT)
	R:begin
	ALU_Code = 4'b01;
	if(Funct != MULT && Funct != MULTU) begin
		reg_dst = 1'b1;
		reg_write = 1'b1;
		end
	if(Funct == 6'h08) jump = 1'b1;
		
	end
	M:begin
		is_signed = 1'b1;
		reg_dst = 1'b0;
		alu_sel = 2'b01;
		if(IR == 6'h23) begin
			reg_write = 1'b1;
			mem_read = 1'b1;
			mem_to_reg = 1'b1;
		end
		if(IR == 6'h28) begin
			mem_write = 1'b1;
		end
	end
	B:begin
		branch = 1'b1;
		ALU_Code = IR;
	end
	J:begin
		jump = 1'b1;
	end
	I:begin
	alu_sel = 2'b01;
	reg_write = 1'b1;
	ALU_Code = IR;
	end
	
	default: begin
	end 
	endcase
	
	

end
endmodule