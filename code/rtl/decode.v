module decode (
    input wire [31:0] i_clk,
    input wire [31:0] i_rst,
    input wire [31:0] instruction,
    output wire [4:0] rd,
    output wire [4:0] rs1,
    output wire [4:0] rs2,
    output wire [31:0] read_1,
    output wire [31:0] read_2, 
    output wire [31:0] imm_sext
);

    wire [4:0] itype;

    i_format_encoder encoder (
        .opcode(instruction[6:0]),
        .itype(itype)
    );

    imm imm_gen (
        .instruction(instruction),
        .itype(itype),
        .imm_sext(imm_sext)
    );

    assign rd = instruction[11:7];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];

    //rf should be instantiated and implemented in the main module since it is needed by multiple other stages
endmodule

`default_nettype wire
