module ALU (
    input  logic [4:0]  ir,
    input  logic [5:0]  op_sel,
    input  logic [31:0] input1, input2,
    output logic [31:0] result, res
   
);

    // Funct codes
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

    // Internal
    logic [63:0] temp_mult;
    logic [31:0] result_h;

    // ALU Logic
    always_comb begin
        temp_mult = 64'b0;
        result    = 32'b0;
        result_h  = 32'b0;


        case (op_sel)
            ADDU    : result = input1 + input2;
            SUBU    : result = input1 - input2;
            MULTU   : begin
                         temp_mult = input1 * input2;
                         result    = temp_mult[31:0];
                         result_h  = temp_mult[63:32];
                      end
            MULT    : begin
                         temp_mult = $signed(input1) * $signed(input2);
                         result    = temp_mult[31:0];
                         result_h  = temp_mult[63:32];
                      end
            L_R_S   : result = input2 >> ir;
            A_R_S   : result = $signed(input2) >>> ir;
            S_O_L   : if ($signed(input1) < $signed(input2)) result[0] = 1'b1;
            S_O_L_U : if (input1 < input2) result[0] = 1'b1;
            SL      : result = input2 << ir;
            AND1    : result = input1 & input2;
            OR1     : result = input1 | input2;
            XOR1    : result = input1 ^ input2;
            default : ; // HALT
        endcase
    end
endmodule

