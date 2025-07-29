module MIPS_Processor(input logic clk,rst, button0,button1, input logic [9:0] switches , output logic [31:0] LEDS);
assign LEDS = 32'b0;
// internal signals
logic reg_write,vcc,pc_write,flush,stall,instruction_rst,jmp_source,is_signed,jmp_link,reg_dst,jump,branch,IF_ID_write;
assign vcc = 1'b1;
assign instruction_rst = flush || rst;
logic [31:0] Jump_ls_out,branch_ls,branch_se,reg_write_data,pc_input,pc_out,pc_4_in,pc_4_out,intruction_mem_out,instruction_reg_out,branch_target,jump_target,jmp_sel0,jmp_sel1,se_out,ID_EX_se,reg_file0,reg_file1;
logic [9:0] addr;
logic [4:0] MEM_WB_rd;
logic [5:0] ID_EX_funct,ALU_Code,Branch_Code;
logic [22:0] stall_mux_out;
logic mem_to_reg,mem_write,mem_read,alu_sel,branch_take,MEM_WB_reg_write;
logic [31:0] inputA,inputB,ID_EX_A,ID_EX_B,ID_EX_forward,ID_MEM_forward,ID_WB_forward;
logic [1:0] inputA_sel,inputB_sel,pc_source;
assign jump_sel1 = reg_file0;
assign jump_sel0 = {pc_4_out[31:28], Jump_ls_out[27:0]};

//special busses
 logic [22:0] control_bus;
 assign control_bus = {
    ALU_Code, Branch_Code, alu_sel,        
    mem_read, mem_write, mem_to_reg,     
    branch,jump,reg_dst,        
    is_signed, reg_write,jmp_source, jmp_link        
    };
//IF components
	ROM Instruction_memory(.addr(addr),.read_data(instruction_mem_out));
	Adder Add4(.input0(pc_out), .input1(6'h04), .out(pc_4_in));
	Register PC(.data(pc_input),.rst(rst),.out(pc_out),.clk(clk),.en(pc_write));
	Register PC_4(.data(pc_4_in),.rst(rst),.clk(clk),.en(vcc), .out(pc_4_out));
	Register instruction_reg(.data(instruction_mem_out),.clk(clk),.en(IF_ID_write),.rst(instruction_rst),.out(instruction_reg_out));
	Four_Two_Mux(.data0(pc_4_out),.data1(branch_target),.data2(jump_target),.data3(6'h00),.sel(pc_source));
	Two_One_Mux Jmp_sel(.data0(jmp_sel0),.data1(jmp_sel1),.out(jump_target),.sel(jmp_source));
//ID components
	Two_One_Mux #(.data_width(5)) reg_dst_sel(.data0(instruction_reg_out[20:16]),.data1(instruction_reg_out[15:11]),.sel(reg_dst),.out(reg_dst_out));
	Register #(.data_width(5)) ID_EX_rd_reg(.en(vcc),.rst(rst),.clk(clk),.data(reg_dst_out),.out(ID_EX_rd));
	Register #(.data_width(5)) ID_EX_rt_reg(.en(vcc),.rst(rst),.clk(clk),.data(instruction_reg_out[20:16]),.out(ID_EX_rt));
	Register #(.data_width(5)) ID_EX_rs_reg(.en(vcc),.rst(rst),.clk(clk),.data(instruction_reg_out[15:11]),.out(ID_EX_rs));
	Sign_Extend SE(.data(instruction_reg_out[15:0]),.out(se_out),.is_signed(is_signed));
	Register SE_reg(.clk(clk),.rst(rst),.data(se_out),.en(vcc), .out(ID_EX_se)); 
	Register #(.data_width(6)) Funct_reg(.clk(clk),.rst(rst),.data(instruction_reg_out[5:0]),.out(ID_EX_funct));
	Register_File reg_file(.clk(clk),.rst(rst),.JumpAndLink(jmp_link),.wr_data(reg_write_data),.link_addr(pc_4_out),.wr_en(MEM_WB_reg_write),
	.rd_addr0(instruction_reg_out[25:21]),.rd_addr1(instruction_reg_out[20:16]),.wr_addr(MEM_WB_rd),.rd_data0(reg_file0),.rd_data1(reg_file1));
	//target resolution
	Sign_Extend Branch_SE (.data(instruction_reg_out[15:0]),.is_signed(vcc),.out(branch_sel));
	Shift_l2 Branch_ls(.data(branch_se),.out(branch_ls));
	Adder Branch_add(.input0(pc_4_out),.input1(branch_ls),.out(branch_target));
	Shift_l2 Jump_ls(.data(instruction_reg_out[25:0]),.out(Jump_ls_out));
	//control unit
	Control_Unit(.IR2(instruction_reg_out[20:16]),.IR(instruction_reg_out[31:26]),.Funct(instruction_reg_out[5:0]),.jmp_link(jmp_link),.jmp_source(jmp_source),.reg_write(reg_write),
	.is_signed(is_signed),.reg_dst(reg_dst),.jump(jump),.branch(branch),.mem_to_reg(mem_to_reg),.mem_write(mem_write),
	.mem_read(mem_read),.alu_sel(alu_sel),.ALU_Code(ALU_Code),.Branch_Code(Branch_Code));
    Two_One_Mux #(.data_width(23)) stall_mux(.sel(stall),.data0(control_bus),.data1(23'b0),.out(stall_mux_out));
	//more registers(after reg file)
	Register InputA_reg(.data(inputA),.clk(clk),.rst(rst),.en(vcc),.out(ID_EX_A));
	Register InputB_reg(.data(inputB),.clk(clk),.rst(rst),.en(vcc),.out(ID_EX_B));
	//ID fowarding muxes
	Four_Two_Mux InputA_mux(.sel(inputA_sel),.data0(regfile0),.data1(ID_EX_forward),.data2(ID_MEM_forward),.data3(ID_WB_forward),.out(inputA));
	Four_Two_Mux InputB_mux(.sel(inputB_sel),.data0(regfile0),.data1(ID_EX_forward),.data2(ID_MEM_forward),.data3(ID_WB_forward),.out(inputB));
	//hazard unit
	Hazard_Unit(.branch_taken(branch_taken),.jump(jump),.ID_EX_rd(ID_EX_rd),.IF_ID_rt(instruction_reg_out[20:16]),.IF_ID_rs(instruction_reg_out[25:21]),
	.pc_source(pc_source),.IF_ID_write(IF_ID_write),.pc_write(pc_write),.stall(stall),.flush(flush));
	//branch resolution unit
	Branch_Resolution_Unit BRU(.branch(branch),.input0(inputA),.input1(inputB),.Branch_Code(Branch_Code),.branch_taken(branch_taken));
	
	
	



endmodule