`default_nettype none

module control_unit (
    input wire _eq,
    input wire _slt,
    input wire [31:0] _instruction,
    output wire c_halted, // done
    output wire c_is_jal_r, // done
    output wire c_pc_mod, // done
    output wire c_use_pc_reg, // done
    output wire c_mem_write, // done
    output wire c_mem_read, // done
    output wire c_reg_write, // done
    output wire [1:0] c_mem_size, // done
    output wire [1:0] c_write_sel, // done
    output wire [2:0] c_alu_op, // done
    output wire c_use_imm, // done
    output wire c_i_sub, // done
    output wire c_i_arith, // done
    output wire c_i_unsigned // done
);
    // Opcode aliases
    localparam [6:0] EBREAK = 7'b1110011;
    localparam [6:0] BRANCH = 7'b1100011;
    localparam [6:0] JAL = 7'b1101111;
    localparam [6:0] JALR = 7'b1100111;
    localparam [6:0] LOAD = 7'b0000011;
    localparam [6:0] STORE = 7'b0100011;
    localparam [6:0] LUI = 7'b0110111;
    localparam [6:0] AUIPC = 7'b0010111;
    localparam [6:0] R_ARITH = 7'b0110011;
    localparam [6:0] I_ARITH = 7'b0010011;

    // Instruction field aliases
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;

    assign opcode = _instruction[6:0];
    assign funct3 = _instruction[14:12];
    assign funct7 = _instruction[31:25];

    // Control signal generation logic
    assign c_alu_op = ((opcode == R_ARITH) | (opcode == I_ARITH)) ? funct3 : 3'b000; // Always add unless R/I type

    assign c_halted = (opcode == EBREAK);
    assign c_is_jal_r = (opcode == JALR);

    assign c_i_unsigned = ((opcode == BRANCH) & funct3[1]) | ((opcode == LOAD) & funct3[2]) | (funct3 == 3'b011); // last term for R/I types
    assign c_pc_mod = (opcode == JAL) | ((opcode == BRANCH) & // jal or B type
        (funct3[0] ^ (funct3[2] ? _eq : _slt))); // Convenient logic (since funct3[1] never matters for CU, ALU uses it)

    assign c_i_sub = funct7[5];
    assign c_i_arith = funct7[5];

    assign c_write_sel = ((opcode == JAL) | (opcode == JALR)) ? 2'b00 : // PC + 4 for JAL/JALR
        (opcode == LUI) ? 2'b11 : // Immediate for LUI
        (opcode == LOAD) ? 2'b01 : 2'b10; // MemDataOut for LOAD, ALU result for rest
    
    assign c_use_imm = (opcode == I_ARITH) | (opcode == AUIPC) | (opcode == LOAD) | (opcode == STORE) | (opcode == JALR);

    assign c_reg_write = (opcode == R_ARITH) | (opcode == I_ARITH) | (opcode == LUI) | (opcode == AUIPC) | (opcode == LOAD) | (opcode == JAL) | (opcode == JALR);
    assign c_mem_write = (opcode == STORE);
    assign c_mem_read = (opcode == LOAD);

    assign c_use_pc_reg = (opcode == AUIPC);

    assign c_mem_size = funct3[1:0]; // 00 = byte, 01 = halfword, 10 = word

endmodule

`default_nettype wire
