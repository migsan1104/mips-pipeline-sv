module ALU(input logic [4:0] IR,input logic [5:0] OP_SEL,input logic [31:0] input1, input2, output logic [31:0] Result,Result_H,output logic Branch_Taken);
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

reg [63:0] Temp_MULT;
//alu_logic
always_comb
begin
    Temp_MULT = 63'b0;
    Result = 31'b0;
    Result_H = 31'b0;
    Branch_Taken = 0;
    case (OP_SEL) 
        ADDU    : begin Result = input1 + input2; end
        SUBU    : begin Result = input1 - input2; end
        MULTU   : begin Temp_MULT = input1 * input2; Result = Temp_MULT[31:0]; Result_H = Temp_MULT[63:32]; end
        MULT    : begin Temp_MULT = $signed(input1) * $signed(input2); Result = Temp_MULT[31:0]; Result_H = Temp_MULT[63:32]; end
        L_R_S   : begin Result = (input2 >> IR); end
        A_R_S   : begin Result = ($signed(input2) >>> IR); end
        S_O_L   : begin if($signed(input1) < $signed(input2)) Result[0] = 1'b1; end
        S_O_L_U : begin if(input1 < input2) Result[0] = 1'b1; end
        BNE     : begin if(input1 != input2) Branch_Taken = 1'b1; end
        BEQ     : begin if(input1 == input2) Branch_Taken = 1'b1; end
        BGEZ    : begin if($signed(input1) >= 0) Branch_Taken = 1'b1; end
        BLTZ    : begin if($signed(input1) < 0) Branch_Taken = 1'b1; end
        SL      : begin Result = input2 << IR; end
        BLEZ    : begin if($signed(input1) <= 0) Branch_Taken = 1'b1; end
        BGTZ    : begin Result = input1; if($signed(input1) > 0) Branch_Taken = 1'b1; end
        AND1    : begin Result = input1 & input2; end
        OR1     : begin Result = input1 | input2; end
        XOR1    : begin Result = input1 ^ input2; end
        default : begin end
    endcase
end
endmodule
