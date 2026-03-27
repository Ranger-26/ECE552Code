`default_nettype none

module execute (
    input wire clk,
    input wire [31:0] read_data_1,
    input wire [31:0] read_data_2,
    input wire [31:0] PC,
    input wire [31:0] imm_sext,
    input wire use_pc_reg,
    input wire use_imm,
    input wire [2:0] alu_op,
    input wire i_sub,
    input wire i_arith,
    input wire i_unsigned,
    input wire [1:0] forward_A,
    input wire [1:0] forward_B,
    input wire [31:0] i_EX_TO_EX_data,
    input wire [31:0] i_MEM_TO_EX_data,
    output wire [31:0] alu_out,
    output wire eq,
    output wire slt,
    // FOR RETIRE
    output wire [31:0] op1,
    output wire [31:0] op2
);
    localparam EX_TO_EX = 2'b01;
    localparam MEM_TO_EX = 2'b10;

    wire [31:0] forwardless_op1 = use_pc_reg ? PC : read_data_1;

    assign op1 = (forward_A == EX_TO_EX) ? i_EX_TO_EX_data :
        (forward_A == MEM_TO_EX) ? i_MEM_TO_EX_data :
        forwardless_op1;

    assign op2 = use_imm ? imm_sext: (forward_B == EX_TO_EX) ? i_EX_TO_EX_data :
        (forward_B == MEM_TO_EX) ? i_MEM_TO_EX_data :
        read_data_2;

    alu alu_main (
        .i_op1(op1),
        .i_op2(op2),
        .i_opsel(alu_op),
        .i_sub(i_sub),
        .i_arith(i_arith),
        .i_unsigned(i_unsigned),
        .o_result(alu_out),
        .o_eq(eq),
        .o_slt(slt)  
    );

    
endmodule

`default_nettype wire
