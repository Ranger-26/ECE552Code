`default_nettype none

module execute (
    input wire clk,
    input wire rst,
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
    output wire [31:0] alu_out,
    output wire eq,
    output wire slt
);

    alu alu_main (
        .i_op1(use_pc_reg ? PC : read_data_1),
        .i_op2(use_imm ? imm_sext : read_data_2),
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
