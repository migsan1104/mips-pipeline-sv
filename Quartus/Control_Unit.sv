module Control_Unit(input logic [5:0] IR, output logic is_signed,reg_dst,jump,branch,mem_to_reg,mem_write,mem_read,output logic [1:0] alu_sel, output logic [3:0] ALU_Code);
//defining custom types for stages(states0 and instruction types
typedef enum logic [2:0] {Instruction_Fetch,Instruction_Decode,Execution,Memory_Access, Write_Back} Stage;
typedef enum logic [1:0] {R,M,J,B} Instruction_type;
//initializing instruction type, state and next_state to perfrom controller logic
Stage State,Next_State;
Instruction_type IT;


always_ff @(posedge clk or posedge rst) begin
    if (rst)
        State <= Instruction_Fetch;
    else
        State <= Next_State;
end

always_comb begin
	//initializing all outputs to avoid latches
	is_signed = 1'b0;
	reg_dst = 1'b0;
	jump = 1'b0;
	branch = 1'b0;
	mem_to_reg = 1'b0;
	mem_write = 1'b0;
	mem_read = 1'b0;
	alu_sel = 2'b0;
	ALU_Code = 4'b0;
	Next_State = Instruction_Fetch;
	

end
end module