// Code your design here
`default_nettype none

module decode (
    input wire i_clk,
    input wire i_rst,
    input wire [31:0] i_instruction,
    output wire [4:0] o_rd,
    output wire [4:0] o_rs1,
    output wire [4:0] o_rs2,
    output wire [31:0] o_imm_sext
);

    wire [5:0] itype;

    i_format_encoder encoder (
        .opcode(i_instruction[6:0]),
        .itype(itype)
    );

    imm imm_gen (
        .i_inst(i_instruction),
        .i_format(itype),
        .o_immediate(o_imm_sext)
    );

    assign o_rd = i_instruction[11:7];
    assign o_rs1 = i_instruction[19:15];
    assign o_rs2 = i_instruction[24:20];

    //rf should be instantiated and implemented in the main module since it is needed by multiple other stages
endmodule

`default_nettype wire
