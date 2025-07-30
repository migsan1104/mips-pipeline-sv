module MIPS_Processor#(parameter ADDR_WIDTH = 10)(input logic clk,rst, button0,button1, input logic [9:0] switches , output logic [41:0] LEDs);
// internal signals
logic reg_write,vcc,pc_write,flush,stall,instruction_rst,jmp_source,is_signed,jmp_link,reg_dst,jump,branch,IF_ID_write;
logic [31:0] Jump_ls_out,branch_ls,branch_se,reg_write_data,pc_input,pc_out,pc_4_in,pc_4_out,intruction_mem_out,instruction_reg_out,branch_target,jump_target,jmp_sel0,jmp_sel1,se_out,ID_EX_se,reg_file0,reg_file1;
logic [9:0] addr;
logic [4:0] MEM_WB_rd,EX_MEM_rd,shamt;
logic [5:0] ID_EX_funct,ALU_Code,Branch_Code,op_sel;
logic [22:0] stall_mux_out,ID_EX_out,EX_MEM_out,MEM_WB_out;
logic mem_to_reg,mem_write,mem_read,alu_sel,branch_take,MEM_WB_reg_write;
logic [31:0] inputA,inputB,ID_EX_A,ID_EX_B,ID_EX_forward,ID_MEM_forward,ID_WB_forward;
logic [31:0] EX_MEM_Forward,EX_WB_Forward,EX_forward_A_out,EX_forward_B_out;
logic [31:0] ALU_Input_B,ALU_result,ALU_result_high,low_reg_out,high_reg_out,EX_MEM_Result,EXE_Desired_Out,EXE_Write_Data;
logic [31:0] MEM_WB_ALU_Result,output_port,Data_MEM_Out,MEM_WB_MEM_Data;
logic [1:0] inputA_sel,inputB_sel,pc_source,ExA_sel,ExB_sel,alu_lo_hi;
logic  hi_en, lo_en;
logic port0_en,port1_en;
//general assignments
assign jump_sel1 = reg_file0;
assign jump_sel0 = {pc_4_out[31:28], Jump_ls_out[27:0]};
assign vcc = 1'b1;
assign instruction_rst = flush || rst;
assign port0_en = ~button0;
assign port1_en = ~button1;
//forward assingments
assign ID_EX_forward = EXE_Desired_Out;
assign ID_MEM_forward = Data_MEM_Out;
assign ID_WB_forward = MEM_WB_MEM_Data;
assign EX_MEM_forward = EX_MEM_Result;
assign EX_WB_forward = MEM_WB_MEM_Data;

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
	Four_Two_Mux PC_Selection_Mux (.data0(pc_4_out),.data1(branch_target),.data2(jump_target),.data3(6'h00),.sel(pc_source));
	Two_One_Mux Jmp_sel(.data0(jmp_sel0),.data1(jmp_sel1),.out(jump_target),.sel(jmp_source));
//ID components
	Register #(.data_width(5)) Shamt_reg (.clk(clk),.en(vcc),.rst(rst),.out(shamt),.data(instruction_reg[10:6]));
	Register #(.data_width(5)) ID_EX_rd_reg(.en(vcc),.rst(rst),.clk(clk),.data(reg_dst_out),.out(ID_EX_rd));
	Register #(.data_width(5)) ID_EX_rt_reg(.en(vcc),.rst(rst),.clk(clk),.data(instruction_reg_out[20:16]),.out(ID_EX_rt));
	Register #(.data_width(5)) ID_EX_rs_reg(.en(vcc),.rst(rst),.clk(clk),.data(instruction_reg_out[15:11]),.out(ID_EX_rs));
	Sign_Extend SE(.data(instruction_reg_out[15:0]),.out(se_out),.is_signed(is_signed));
	Two_One_Mux #(.data_width(5)) reg_dst_sel(.data0(instruction_reg_out[20:16]),.data1(instruction_reg_out[15:11]),.sel(reg_dst),.out(reg_dst_out));
	Register SE_reg(.clk(clk),.rst(rst),.data(se_out),.en(vcc), .out(ID_EX_se)); 
	Register #(.data_width(6)) Funct_reg(.clk(clk),.rst(rst),.data(instruction_reg_out[5:0]),.out(ID_EX_funct));
	Register_File reg_file(.clk(clk),.rst(rst),.JumpAndLink(jmp_link),.wr_data(reg_write_data),.link_addr(pc_4_out),.wr_en(MEM_WB_out[2]),
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
	Register #(.data_width(23)) ID_EX_reg(.data(stall_mux_out),.clk(clk),.rst(rst),.en(vcc),.out(ID_EX_out));
	//ID fowarding muxes
	Four_Two_Mux InputA_mux(.sel(inputA_sel),.data0(regfile0),.data1(ID_EX_forward),.data2(ID_MEM_forward),.data3(ID_WB_forward),.out(inputA));
	Four_Two_Mux InputB_mux(.sel(inputB_sel),.data0(regfile1),.data1(ID_EX_forward),.data2(ID_MEM_forward),.data3(ID_WB_forward),.out(inputB));
	//hazard unit
	Hazard_Unit(.branch_taken(branch_taken),.jump(jump),.ID_EX_rd(ID_EX_rd),.IF_ID_rt(instruction_reg_out[20:16]),.IF_ID_rs(instruction_reg_out[25:21]),
	.pc_source(pc_source),.IF_ID_write(IF_ID_write),.pc_write(pc_write),.stall(stall),.flush(flush));
	//branch resolution unit
	Branch_Resolution_Unit BRU(.branch(branch),.input0(inputA),.input1(inputB),.Branch_Code(Branch_Code),.branch_taken(branch_taken));
//Ex stage components
	//forwarding unit and muxes
		Forwarding_Unit FU (.ID_EX_rt(ID_EX_rt),.ID_EX_rs(ID_EX_rs),.IF_ID_rs(instruction_reg_out[25:21]),.IF_ID_rt(instruction_reg_out[20:16]),.ID_EX_rd(ID_EX_rd),
		.MEM_WB_rd(MEM_WB_rd),.EX_MEM_rd(EX_MEM_rd),.ID_EX_RegWrite(ID_EX_out[2]),.EX_MEM_RegWrite(EX_MEM_out[2]),.MEM_WB_RegWrite(MEM_WB_out[2]),.ForwardA_Ex(ExA_sel),
		.ForwardB_Ex(ExB_sel),.ForwardA_ID(inputA_sel),.ForwardB_ID(inputB_sel));
	   Four_Two_Mux EX_Forward_A(.sel(ExA_sel),.data0(ID_EX_A),.data1(EX_MEM_forward),.data2(ID_MEM_forward),.data3(32'b0),.out(EX_Forward_A_out));
	   Four_Two_Mux EX_Forward_B(.sel(ExA_sel),.data0(ID_EX_A),.data1(EX_MEM_forward),.data2(ID_MEM_forward),.data3(32'b0),.out(EX_Forward_B_out));
		Two_One_Mux ALU_Input_B_Mux(.sel(ID_EX_out[10]),.data0(EX_Forward_B_out),.data1(ID_EX_se),.out(ALU_Input_B));
	//Data Path registers
		Register #(.data_width(5)) EX_MEM_rd_reg(.clk(clk),.en(vcc),.rst(rst),.data(ID_EX_rd),.out(EX_MEM_rd));
		Register #(.data_width(23)) EX_MEM_reg(.clk(clk),.en(vcc),.rst(rst),.out(EX_MEM_out),.data(ID_EX_out));
		Register EXE_Write_Data_Reg (.clk(clk),.rst(rst),.en(vcc),.data(EX_Forward_B_out),.out(EXE_Write_Data));
	// ALU,ALU control and supporting components
		ALU MIPS_ALU (.shamt(shamt),.op_sel(op_sel),.input1(EX_Forward_A_out),.input2(ALU_Input_B),.result(ALU_result),.result_h(ALU_result_high));
		ALU_Control ALU_CU (.alu_con(ID_EX_out[22:17]),.funct(ID_EX_funct),.op_sel(op_el),.alu_lo_hi(alu_lo_hi),.hi_en(hi_en),.lo_en(lo_en));
		Register ALU_Low_Reg (.clk(clk),.en(lo_en),.rst(rst),.data(ALU_result),.out(low_reg_out));
		Register ALU_High_Reg (.clk(clk),.en(hi_en),.rst(rst),.data(ALU_result_high),.out(high_reg_out));
		Register EX_MEM_Result_Reg (.clk(clk),.en(vcc),.rst(rst),.data(EXE_Desired_Out),.out(EX_MEM_Result));
      Four_Two_Mux EXE_Sel (.sel(alu_lo_hi),.data0(ALU_result),.data1(low_reg_out),.data2(high_reg_out),.data3(32'b0),.out(EXE_Desired_Out));
//MEM stage components
		//Data Path registers 
		Register #(.data_width(5)) MEM_WB_rd_reg(.clk(clk),.en(vcc),.rst(rst),.data(EX_MEM_rd),.out(MEM_WB_rd));
		Register #(.data_width(23)) MEM_WB_reg(.clk(clk),.en(vcc),.rst(rst),.out(MEM_WB_out),.data(EX_MEM_out));
		Register MEM_WB_ALU_Result_Reg (.clk(clk),.en(vcc),.rst(rst),.data(EX_MEM_Result),.out(MEM_WB_ALU_Result));
		Register MEM_WB_MEM_Data_reg (.clk(clk),.en(vcc),.rst(rst),.data(Data_MEM_Out),.out(MEM_WB_MEM_Data));
		//memory unit, zero extend is done without component, using system verilog instead. 
		Memory_Unit #(.ADDR_WIDTH(ADDR_WIDTH)) MEM_Unit(.addr(EX_MEM_Result[ADDR_WIDTH - 1:0]),.data_in(EXE_Write_Data),.switches({22'b0,switches})
		,.write_en(EX_MEM_out[8]),.en_0(port0_en),.en_1(port1_en),.clk(clk),.rst(rst),.mem_read(EX_MEM_out[9]),.data_out(Data_MEM_Out),.output_port(output_port));
// WB stage components 
		Two_One_Mux WB_Mux (.sel(MEM_WB_out[7]),.data0(MEM_WB_ALU_Result),.data1(MEM_WB_MEM_Data),.out(reg_write_data));

// Seven Segment decoders for LEDs
		Seven_Segment_Decoder Decoder0(.X(output_port[3:0]),.out(LEDs[6:0]));
		Seven_Segment_Decoder Decoder1(.X(output_port[7:4]),.out(LEDs[13:7]));
		Seven_Segment_Decoder Decoder2(.X(output_port[11:8]),.out(LEDs[20:14]));
		Seven_Segment_Decoder Decoder3(.X(output_port[15:12]),.out(LEDs[27:21]));
		Seven_Segment_Decoder Decoder4(.X(output_port[19:16]),.out(LEDs[34:28]));
		Seven_Segment_Decoder Decoder5(.X(output_port[23:20]),.out(LEDs[41:35]));


endmodule