`default_nettype none

module fetch (
    input wire i_clk,
    input wire i_rst,
    input wire i_pcmod,
    input wire [6:0] i_instr_op,
    input wire [31:0] i_branch_target_addr,
    input wire [31:0] i_jalr_target_addr,
    input wire i_is_jal_r,
    input wire i_halted,
    output wire [31:0] o_PC,
    // output wire [31:0] o_pc_plus4,
    output wire [31:0] o_nxt_pc,
    output wire [5:0] o_itype
);

i_format_encoder encoder (
    .opcode(i_instr_op),
    .itype(o_itype)
);


reg [31:0] ProgramCounter;

always @(posedge i_clk) begin
    if (i_rst) begin
        ProgramCounter <= 32'b0;
    end else begin
        ProgramCounter <= i_halted ? ProgramCounter : (i_is_jal_r ? i_jalr_target_addr : (i_pcmod ? i_branch_target_addr : ProgramCounter + 4));
    end
end

assign o_PC = ProgramCounter;
// assign o_pc_plus4 = ProgramCounter + 4;
assign o_nxt_pc =  (i_halted ? ProgramCounter : (i_is_jal_r ? i_jalr_target_addr : (i_pcmod ? i_branch_target_addr : ProgramCounter + 4)));

endmodule

`default_nettype wire
