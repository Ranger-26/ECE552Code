`default_nettype none

module control_unit (
    input wire eq,
    input wire slt,
    input wire [31:0] instruction,
    output wire halted, // done
    output wire is_jal_r, // done
    output wire pc_mod, // done
    output wire use_pc_reg, // done
    output wire mem_write, // done
    output wire mem_read, // done
    output wire reg_write, // done
    output wire [1:0] mem_size, // done
    output wire [1:0] write_sel, // done
    output wire [2:0] alu_op, // done
    output wire use_imm, // done
    output wire i_sub, // done
    output wire i_arith, // done
    output wire i_unsigned // done
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
    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];

    // Control signal generation logic
    assign alu_op = ((opcode == R_ARITH) | (opcode == I_ARITH)) ? funct3 : 3'b000; // Always add unless R/I type

    assign halted = (opcode == EBREAK);
    assign is_jal_r = (opcode == JALR);

    assign i_unsigned = (opcode == BRANCH) & funct3[1] | (opcode == LOAD) & funct3[2] | (funct3 == 3'b011); // last term for R/I types
    assign pc_mod = (opcode == JAL) | ((opcode == BRANCH) & // jal or B type
        (funct3[0] ^ (funct3[2] ? eq : slt))); // Convenient logic (since funct3[1] never matters for CU, ALU uses it)

    assign i_sub = funct7[5];
    assign i_arith = funct7[5];

    assign write_sel = ((opcode == JAL) | (opcode == JALR)) ? 2'b00 : // PC + 4 for JAL/JALR
        (opcode == LUI) ? 2'b11 : // Immediate for LUI
        (opcode == LOAD) ? 2'b01 : 2'b10; // MemDataOut for LOAD, ALU result for rest
    
    assign use_imm = (opcode == I_ARITH) | (opcode == AUIPC) | (opcode == LOAD) | (opcode == STORE) | (opcode == JALR);

    assign reg_write = (opcode == R_ARITH) | (opcode == I_ARITH) | (opcode == LUI) | (opcode == AUIPC) | (opcode == LOAD) | (opcode == JAL) | (opcode == JALR);
    assign mem_write = (opcode == STORE);
    assign mem_read = (opcode == LOAD);

    assign use_pc_reg = (opcode == AUIPC);

    assign mem_size = funct3[1:0]; // 00 = byte, 01 = halfword, 10 = word

endmodule

`default_nettype wire
