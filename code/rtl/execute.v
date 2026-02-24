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
        .a(use_pc_reg ? PC : read_data_1),
        .b(use_imm ? imm_sext : read_data_2),
        .alu_op(alu_op),
        .i_sub(i_sub),
        .i_arith(i_arith),
        .i_unsigned(i_unsigned),
        .result(alu_out),
        .eq(eq),
        .slt(slt)  
    );

    
endmodule

`default_nettype wire
