module control_unit (
    input wire eq,
    input wire slt,
    input wire [31:0] instruction,
    output wire halted,
    output wire is_jal_r,
    output wire pc_mod,
    output wire use_pc_reg,
    output wire mem_write,
    output wire reg_write,
    output wire [2:0] mem_mode,
    output wire [1:0] reg_sel,
    output wire [2:0] alu_op,
    output wire use_imm,
    output wire i_sub,
    output wire i_arith,
    output wire i_unsigned
);


assign halted = (instruction[6:0] == 7'b1110011); // ebreak
assign is_jal_r = (instruction[6:0] == 7'1100111) //jalr


endmodule