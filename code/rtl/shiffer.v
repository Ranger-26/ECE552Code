module shiffter (
    input  wire [31:0] i_op,
  
    input  wire [ 4:0] shamt,

    input wire left,

    input wire arith,

    output wire [31:0] shifted_value
);


    wire [31:0] leftShiftStage [4:0];
    wire [31:0] rightShiftStage [4:0];


    assign leftShiftStage[0] = shamt[0] ? {i_op[30:0], 1'b0} : i_op;
    assign leftShiftStage[1] = shamt[1] ? {leftShiftStage[0][29:0], 2'b0} : leftShiftStage[0];
    assign leftShiftStage[2] = shamt[2] ? {leftShiftStage[1][27:0], 4'b0} : leftShiftStage[1];
    assign leftShiftStage[3] = shamt[3] ? {leftShiftStage[2][23:0], 8'b0} : leftShiftStage[2];
    assign leftShiftStage[4] = shamt[4] ? {leftShiftStage[3][15:0], 16'b0} : leftShiftStage[3];

    assign rightShiftStage[0] = shamt[0] ? {arith ? i_op[31] : 1'b0, i_op[31:1]} : i_op;// 
    assign rightShiftStage[1] = shamt[1] ? {{2{arith ? rightShiftStage[0][31] : 1'b0}}, rightShiftStage[0][31:2]} : rightShiftStage[0];
    assign rightShiftStage[2] = shamt[2] ? {{4{arith ? rightShiftStage[1][31] : 1'b0}}, rightShiftStage[1][31:4]} : rightShiftStage[1];
    assign rightShiftStage[3] = shamt[3] ? {{8{arith ? rightShiftStage[2][31] : 1'b0}}, rightShiftStage[2][31:8]} : rightShiftStage[2];
    assign rightShiftStage[4] = shamt[4] ? {{16{arith ? rightShiftStage[3][31] : 1'b0}}, rightShiftStage[3][31:16]} : rightShiftStage[3];


    assign shifted_value = left ? leftShiftStage[4] : rightShiftStage[4];

    

endmodule