`default_nettype none

module fetch (
    input wire i_clk,
    input wire i_rst,
    input wire [6:0] i_instr_op,
    input wire [31:0] i_branch_target_addr,
    input wire [31:0] i_jalr_target_addr,
    input wire i_pc_mod,
    input wire i_is_jalr,
    input wire i_halted,
    output wire [31:0] o_PC,
    output wire [31:0] o_pc_plus4,
    output wire [31:0] o_next_pc,
    output wire [5:0] o_itype
);

    i_format_encoder encoder (
        .opcode(i_instr_op),
        .itype(o_itype)
    );

    reg [31:0] ProgramCounter;
    assign o_PC = ProgramCounter;
    assign o_pc_plus4 = ProgramCounter + 4;

    // cascaded pc muxes
    assign o_next_pc = i_halted ? ProgramCounter :
        i_is_jalr ? i_jalr_target_addr :
        i_pc_mod ? i_branch_target_addr :
        o_pc_plus4;

    always @(posedge i_clk) begin
        if (i_rst) begin
            ProgramCounter <= 32'b0;
        end else begin
            ProgramCounter <= o_next_pc;
        end
    end

endmodule

`default_nettype wire
