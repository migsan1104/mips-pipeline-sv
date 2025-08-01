module Forwarding_Unit(
    input  logic [4:0] ID_EX_rs, ID_EX_rt,
    input  logic [4:0] IF_ID_rs, IF_ID_rt,        
    input  logic [4:0] ID_EX_rd,                  
    input  logic [4:0] EX_MEM_rd, MEM_WB_rd,
    input  logic       ID_EX_RegWrite,            
    input  logic       EX_MEM_RegWrite, MEM_WB_RegWrite,
    output logic [1:0] ForwardA_Ex, ForwardB_Ex,  
    output logic [1:0] ForwardA_ID, ForwardB_ID   
);

always_comb begin
    // by default we assume no forwarding is needed
    ForwardA_Ex = 2'b00;
    ForwardB_Ex = 2'b00;
    ForwardA_ID = 2'b00;
    ForwardB_ID = 2'b00;

    // this first set of if statements only apply to fowarding to the exe stage
    
	// ForwardA logic
	if (EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs))
    ForwardA_Ex = 2'b01; // Forward from MEM stage
	else if (MEM_WB_RegWrite && (MEM_WB_rd != 0) && (MEM_WB_rd == ID_EX_rs))
    ForwardA_Ex = 2'b10; // Forward from WB stage


	// ForwardB logic
	if (EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rt))
    ForwardB_Ex = 2'b01;
	else if (MEM_WB_RegWrite && (MEM_WB_rd != 0) && (MEM_WB_rd == ID_EX_rt))
    ForwardB_Ex = 2'b10;



    // this set of if statement is for forwarding to the ID stage, this is used in branch resolution
    // for inputA
    if (ID_EX_RegWrite && (ID_EX_rd != 0) && (ID_EX_rd == IF_ID_rs))
        ForwardA_ID = 2'b01;
    else if (EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == IF_ID_rs))
        ForwardA_ID = 2'b10;
    // this last case is very rare 


    // for inputB
    if (ID_EX_RegWrite && (ID_EX_rd != 0) && (ID_EX_rd == IF_ID_rt))
        ForwardB_ID = 2'b01;
    else if (EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == IF_ID_rt))
        ForwardB_ID = 2'b10;

end

endmodule

