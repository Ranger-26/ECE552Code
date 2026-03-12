`default_nettype none

module hart #(
    // After reset, the program counter (PC) should be initialized to this
    // address and start executing instructions from there.
    parameter RESET_ADDR = 32'h00000000
) (
    // Global clock.
    input  wire        i_clk,
    // Synchronous active-high reset.
    input  wire        i_rst,
    // Instruction fetch goes through a read only instruction memory (imem)
    // port. The port accepts a 32-bit address (e.g. from the program counter)
    // per cycle and combinationally returns a 32-bit instruction word. This
    // is not representative of a realistic memory interface; it has been
    // modeled as more similar to a DFF or SRAM to simplify phase 3. In
    // later phases, you will replace this with a more realistic memory.
    //
    // 32-bit read address for the instruction memory. This is expected to be
    // 4 byte aligned - that is, the two LSBs should be zero.
    output wire [31:0] o_imem_raddr,
    // Instruction word fetched from memory, available on the same cycle.
    input  wire [31:0] i_imem_rdata,
    // Data memory accesses go through a separate read/write data memory (dmem)
    // that is shared between read (load) and write (stored). The port accepts
    // a 32-bit address, read or write enable, and mask (explained below) each
    // cycle. Reads are combinational - values are available immediately after
    // updating the address and asserting read enable. Writes occur on (and
    // are visible at) the next clock edge.
    //
    // Read/write address for the data memory. This should be 32-bit aligned
    // (i.e. the two LSB should be zero). See `o_dmem_mask` for how to perform
    // half-word and byte accesses at unaligned addresses.
    output wire [31:0] o_dmem_addr,
    // When asserted, the memory will perform a read at the aligned address
    // specified by `i_addr` and return the 32-bit word at that address
    // immediately (i.e. combinationally). It is illegal to assert this and
    // `o_dmem_wen` on the same cycle.
    output wire        o_dmem_ren,
    // When asserted, the memory will perform a write to the aligned address
    // `o_dmem_addr`. When asserted, the memory will write the bytes in
    // `o_dmem_wdata` (specified by the mask) to memory at the specified
    // address on the next rising clock edge. It is illegal to assert this and
    // `o_dmem_ren` on the same cycle.
    output wire        o_dmem_wen,
    // The 32-bit word to write to memory when `o_dmem_wen` is asserted. When
    // write enable is asserted, the byte lanes specified by the mask will be
    // written to the memory word at the aligned address at the next rising
    // clock edge. The other byte lanes of the word will be unaffected.
    output wire [31:0] o_dmem_wdata,
    // The dmem interface expects word (32 bit) aligned addresses. However,
    // WISC-25 supports byte and half-word loads and stores at unaligned and
    // 16-bit aligned addresses, respectively. To support this, the access
    // mask specifies which bytes within the 32-bit word are actually read
    // from or written to memory.
    //
    // To perform a half-word read at address 0x00001002, align `o_dmem_addr`
    // to 0x00001000, assert `o_dmem_ren`, and set the mask to 0b1100 to
    // indicate that only the upper two bytes should be read. Only the upper
    // two bytes of `i_dmem_rdata` can be assumed to have valid data; to
    // calculate the final value of the `lh[u]` instruction, shift the rdata
    // word right by 16 bits and sign/zero extend as appropriate.
    //
    // To perform a byte write at address 0x00002003, align `o_dmem_addr` to
    // `0x00002000`, assert `o_dmem_wen`, and set the mask to 0b1000 to
    // indicate that only the upper byte should be written. On the next clock
    // cycle, the upper byte of `o_dmem_wdata` will be written to memory, with
    // the other three bytes of the aligned word unaffected. Remember to shift
    // the value of the `sb` instruction left by 24 bits to place it in the
    // appropriate byte lane.
    output wire [ 3:0] o_dmem_mask,
    // The 32-bit word read from data memory. When `o_dmem_ren` is asserted,
    // this will immediately reflect the contents of memory at the specified
    // address, for the bytes enabled by the mask. When read enable is not
    // asserted, or for bytes not set in the mask, the value is undefined.
    input  wire [31:0] i_dmem_rdata,
	// The output `retire` interface is used to signal to the testbench that
    // the CPU has completed and retired an instruction. A single cycle
    // implementation will assert this every cycle; however, a pipelined
    // implementation that needs to stall (due to internal hazards or waiting
    // on memory accesses) will not assert the signal on cycles where the
    // instruction in the writeback stage is not retiring.
    //
    // Asserted when an instruction is being retired this cycle. If this is
    // not asserted, the other retire signals are ignored and may be left invalid.
    output wire        o_retire_valid,
    // The 32 bit instruction word of the instrution being retired. This
    // should be the unmodified instruction word fetched from instruction
    // memory.
    output wire [31:0] o_retire_inst,
    // Asserted if the instruction produced a trap, due to an illegal
    // instruction, unaligned data memory access, or unaligned instruction
    // address on a taken branch or jump.
    output wire        o_retire_trap,
    // Asserted if the instruction is an `ebreak` instruction used to halt the
    // processor. This is used for debugging and testing purposes to end
    // a program.
    output wire        o_retire_halt,
    // The first register address read by the instruction being retired. If
    // the instruction does not read from a register (like `lui`), this
    // should be 5'd0.
    output wire [ 4:0] o_retire_rs1_raddr,
    // The second register address read by the instruction being retired. If
    // the instruction does not read from a second register (like `addi`), this
    // should be 5'd0.
    output wire [ 4:0] o_retire_rs2_raddr,
    // The first source register data read from the register file (in the
    // decode stage) for the instruction being retired. If rs1 is 5'd0, this
    // should also be 32'd0.
    output wire [31:0] o_retire_rs1_rdata,
    // The second source register data read from the register file (in the
    // decode stage) for the instruction being retired. If rs2 is 5'd0, this
    // should also be 32'd0.
    output wire [31:0] o_retire_rs2_rdata,
    // The destination register address written by the instruction being
    // retired. If the instruction does not write to a register (like `sw`),
    // this should be 5'd0.
    output wire [ 4:0] o_retire_rd_waddr,
    // The destination register data written to the register file in the
    // writeback stage by this instruction. If rd is 5'd0, this field is
    // ignored and can be treated as a don't care.
    output wire [31:0] o_retire_rd_wdata,
    // The current program counter of the instruction being retired - i.e.
    // the instruction memory address that the instruction was fetched from.
    output wire [31:0] o_retire_pc,
    // the next program counter after the instruction is retired. For most
    // instructions, this is `o_retire_pc + 4`, but must be the branch or jump
    // target for *taken* branches and jumps.
    output wire [31:0] o_retire_next_pc,

    //other signals

    //raw bytes recieved from memory
    output wire [31:0] o_retire_dmem_addr,
    output wire        o_retire_dmem_ren,
    output wire        o_retire_dmem_wen,
    output wire [ 3:0] o_retire_dmem_mask,
    output wire [31:0] o_retire_dmem_wdata,
    output  wire [31:0] o_retire_dmem_rdata

`ifdef RISCV_FORMAL
    ,`RVFI_OUTPUTS,
`endif
);
    //ALU Output signals
    wire eq;
    wire slt;
    wire [31:0] alu_out;

    //Control Unit Signals
    wire c_halted; 
    wire c_is_jalr; 
    wire c_pc_mod; // EX STAGE
    wire c_use_pc_reg; 
    wire c_mem_write; 
    wire c_mem_read;
    wire c_reg_write; 
    wire [1:0] c_mem_size; 
    wire [1:0] c_write_sel; 
    wire [2:0] c_alu_op; 
    wire c_use_imm; 
    wire c_i_sub; 
    wire c_i_arith; 
    wire c_i_unsigned;

    wire [5:0] format;
    
    wire [31:0] branch_target_addr;
    wire [31:0] jalr_target_addr;

    wire [31:0] reg_write_data;

    // Aligned dmem output
    wire [31:0] dmem_rdata_aligned;

    //fetch output signals
    wire [31:0] PC;
    wire [31:0] pc_plus4;
    wire [31:0] next_pc;

    //decode output signals
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [31:0] imm_sext;

    //register file outputs
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    // Pipeline Registers
    // IF/ID
    reg [31:0] IF_ID_curr_pc;
    reg [31:0] IF_ID_pc_plus4;
    reg [31:0] IF_ID_instruction;
    reg [5:0] IF_ID_format;
    wire [4:0] IF_ID_rs1 = IF_ID_instruction[19:15];
    wire [4:0] IF_ID_rs2 = IF_ID_instruction[24:20];
    wire [4:0] IF_ID_rd = IF_ID_instruction[11:7];
    // FOR TB ONLY
    reg IF_ID_valid;

    // ID/EX
    reg [31:0] ID_EX_rs1_data;
    reg [31:0] ID_EX_rs2_data;
    reg [31:0] ID_EX_imm;
    reg [31:0] ID_EX_pc_plus4;
    reg [31:0] ID_EX_curr_pc;
    reg [4:0] ID_EX_write_reg;
    reg [6:0] ID_EX_opcode;
    reg [2:0] ID_EX_funct3;
    reg ID_EX_c_is_jalr;
    reg ID_EX_c_use_pc_reg;
    reg ID_EX_c_mem_write;
    reg ID_EX_c_mem_read;
    reg ID_EX_c_reg_write;
    reg [1:0] ID_EX_c_mem_size;
    reg [1:0] ID_EX_c_write_sel;
    reg [2:0] ID_EX_c_alu_op;
    reg ID_EX_c_use_imm;
    reg ID_EX_c_sub;
    reg ID_EX_c_arith;
    reg ID_EX_c_unsigned;
    reg [5:0] ID_EX_format;
    // FOR TB ONLY
    reg ID_EX_valid;
    reg [31:0] ID_EX_instruction;
    reg [4:0] ID_EX_rs1_raddr;
    reg [4:0] ID_EX_rs2_raddr;
    reg ID_EX_c_halted;

    // EX/MEM
    reg [31:0] EX_MEM_alu_out;
    reg [31:0] EX_MEM_rs2_data;
    reg [31:0] EX_MEM_imm;
    reg [31:0] EX_MEM_pc_plus4;
    reg [4:0] EX_MEM_write_reg;
    reg EX_MEM_c_unsigned;
    reg EX_MEM_c_mem_write;
    reg EX_MEM_c_mem_read;
    reg EX_MEM_c_reg_write;
    reg [1:0] EX_MEM_c_write_sel;
    reg [1:0] EX_MEM_c_mem_size;
    // FOR TB ONLY
    reg EX_MEM_valid;
    reg [31:0] EX_MEM_instruction;
    reg [31:0] EX_MEM_next_pc;
    reg [31:0] EX_MEM_curr_pc;
    reg [4:0] EX_MEM_rs1_raddr;
    reg [4:0] EX_MEM_rs2_raddr;
    reg [31:0] EX_MEM_rs1_data;
    reg EX_MEM_c_halted;

    // MEM/WB
    reg [31:0] MEM_WB_mem_out;
    reg [31:0] MEM_WB_imm;
    reg [31:0] MEM_WB_pc_plus4;
    reg [31:0] MEM_WB_alu_out;
    reg [4:0] MEM_WB_write_reg;
    reg [1:0] MEM_WB_c_write_sel;
    reg MEM_WB_c_reg_write;
    // FOR TB ONLY
    reg MEM_WB_valid;
    reg [31:0] MEM_WB_instruction;
    reg [31:0] MEM_WB_next_pc;
    reg [31:0] MEM_WB_curr_pc;
    reg [4:0] MEM_WB_rs1_raddr;
    reg [4:0] MEM_WB_rs2_raddr;
    reg [31:0] MEM_WB_rs1_data;
    reg [31:0] MEM_WB_rs2_data;
    reg MEM_WB_c_halted;
    reg MEM_WB_c_mem_read;
    reg MEM_WB_c_mem_write;
    reg [3:0] MEM_WB_dmem_mask;
    reg [31:0] MEM_WB_dmem_rdata;

    // EFFECTIVE HALT
    wire effective_halted = c_halted | ID_EX_c_halted;

    // stall signals
    wire flush_IF_ID;
    wire flush_ID_EX;
    wire stall_pc;
 
    // pipeline reg resets
    wire rst_IF_ID = i_rst | effective_halted | flush_IF_ID;
    wire rst_ID_EX = i_rst | flush_ID_EX;

    // retires
    assign o_retire_valid = MEM_WB_valid;
    assign o_retire_inst = MEM_WB_instruction;
    assign o_retire_next_pc = MEM_WB_next_pc;
    assign o_retire_pc = MEM_WB_curr_pc;
    assign o_retire_rs1_raddr = MEM_WB_rs1_raddr;
    assign o_retire_rs2_raddr = MEM_WB_rs2_raddr;
    assign o_retire_rd_waddr = MEM_WB_c_reg_write ? MEM_WB_write_reg : 5'd0; // if not writing to a register, set to 0
    assign o_retire_trap = 0;
    assign o_retire_rs1_rdata = MEM_WB_rs1_data;
    assign o_retire_rs2_rdata = MEM_WB_rs2_data;
    assign o_retire_halt = MEM_WB_c_halted;
    assign o_retire_rd_wdata = reg_write_data;
    assign o_retire_dmem_addr = MEM_WB_alu_out;
    assign o_retire_dmem_ren = MEM_WB_c_mem_read;
    assign o_retire_dmem_wen = MEM_WB_c_mem_write;
    assign o_retire_dmem_mask = MEM_WB_dmem_mask;
    assign o_retire_dmem_wdata = MEM_WB_rs2_data;
    assign o_retire_dmem_rdata = MEM_WB_dmem_rdata;

    // memory interfaces
    assign o_imem_raddr = PC;
    assign o_dmem_addr = {EX_MEM_alu_out[31:2], 2'b00}; // align to word boundary
    assign o_dmem_wen = EX_MEM_c_mem_write;
    assign o_dmem_ren = EX_MEM_c_mem_read;

    assign branch_target_addr = ID_EX_curr_pc + ID_EX_imm;
    assign jalr_target_addr = {alu_out[31:1], 1'b0}; // ensure target is even by zeroing LSB



    //control unit
    control_unit control_unit_state(
        ._eq(eq),
        ._slt(slt),
        ._instruction(IF_ID_instruction),
        .ID_EX_opcode(ID_EX_opcode),
        .ID_EX_funct3(ID_EX_funct3),
        .c_halted(c_halted),
        .c_is_jalr(c_is_jalr),
        .c_use_pc_reg(c_use_pc_reg),
        .c_mem_write(c_mem_write),
        .c_mem_read(c_mem_read),
        .c_reg_write(c_reg_write),
        .c_mem_size(c_mem_size),
        .c_write_sel(c_write_sel),
        .c_alu_op(c_alu_op),
        .c_use_imm(c_use_imm),
        .c_pc_mod(c_pc_mod),
        .c_i_sub(c_i_sub),
        .c_i_arith(c_i_arith),
        .c_i_unsigned(c_i_unsigned)
    );


    hazard_detector hazard_detector_state(
        .IF_ID_rs1(IF_ID_rs1),
        .IF_ID_rs2(IF_ID_rs2),
        .ID_format(IF_ID_format),
        .EX_format(ID_EX_format),
        .ID_EX_write_reg(ID_EX_write_reg),
        .EX_MEM_write_reg(EX_MEM_write_reg),
        .c_is_jalr(c_is_jalr),
        .ID_EX_c_is_jalr(ID_EX_c_is_jalr),
        .stall_pc(stall_pc),
        .flush_IF_ID(flush_IF_ID),
        .flush_ID_EX(flush_ID_EX)
    );

    
    //fetch unit
    fetch fetch_stage(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_pc_mod(c_pc_mod),
        .i_instr_op(i_imem_rdata[6:0]),
        .i_branch_target_addr(branch_target_addr),
        .i_jalr_target_addr(jalr_target_addr),
        .i_is_jalr(ID_EX_c_is_jalr),
        .i_halted(effective_halted),
        .i_stall(stall_pc),
        .o_PC(PC),
        .o_next_pc(next_pc),
        .o_pc_plus4(pc_plus4),
        .o_itype(format)
    );

    //pipeline register logic for IF/ID
    always @(posedge i_clk) begin
        if (rst_IF_ID) begin
            {IF_ID_curr_pc,
                IF_ID_instruction,
                IF_ID_pc_plus4,
                IF_ID_format,
                IF_ID_valid} <= 0;
        end else begin 
            IF_ID_instruction <= i_imem_rdata;
            IF_ID_pc_plus4 <= pc_plus4;
            IF_ID_curr_pc <= PC;
            IF_ID_format <= format;
            IF_ID_valid <= 1; // once we start fetching instructions, we can set valid bit to 1 and keep it there until reset
        end
    end
    
    //assign IF_ID_valid

    //decode
    decode decode_state(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_instruction(IF_ID_instruction),
        .i_format(IF_ID_format),
        .o_rd(rd),
        .o_rs1(rs1),
        .o_rs2(rs2),
        .o_imm_sext(imm_sext)
    );

    //check for registers beign the same as the ones in the next pipeline register

    //register file
    rf reg_file(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_rs1_raddr(rs1),
        .i_rs2_raddr(rs2),
        .i_rd_wen(MEM_WB_c_reg_write),
        .i_rd_waddr(MEM_WB_write_reg),
        .i_rd_wdata(reg_write_data),
        .o_rs1_rdata(rs1_data),
        .o_rs2_rdata(rs2_data)
    );

    //pipeline register logic for ID/EX
    always @(posedge i_clk) begin
        if (rst_ID_EX) begin
            {ID_EX_format,
                ID_EX_rs1_data,
                ID_EX_rs2_data,
                ID_EX_imm,
                ID_EX_curr_pc,
                ID_EX_pc_plus4,
                ID_EX_write_reg,
                ID_EX_opcode,
                ID_EX_funct3,
                ID_EX_c_is_jalr,
                ID_EX_c_use_pc_reg,
                ID_EX_c_mem_write,
                ID_EX_c_mem_read,
                ID_EX_c_reg_write,
                ID_EX_c_mem_size,
                ID_EX_c_write_sel,
                ID_EX_c_alu_op,
                ID_EX_c_use_imm,
                ID_EX_c_sub,
                ID_EX_c_arith,
                ID_EX_c_unsigned,
                // FOR TB
                ID_EX_valid,
                ID_EX_instruction,
                ID_EX_rs1_raddr,
                ID_EX_rs2_raddr,
                ID_EX_c_halted} <= 0;
        end else begin
            ID_EX_format <= IF_ID_format;
            ID_EX_rs1_data <= rs1_data;
            ID_EX_rs2_data <= rs2_data;
            ID_EX_imm <= imm_sext;
            ID_EX_curr_pc <= IF_ID_curr_pc;
            ID_EX_pc_plus4 <= IF_ID_pc_plus4;
            ID_EX_write_reg <= rd;
            ID_EX_opcode <= IF_ID_instruction[6:0];
            ID_EX_funct3 <= IF_ID_instruction[14:12];
            ID_EX_c_is_jalr <= c_is_jalr;
            ID_EX_c_use_pc_reg <= c_use_pc_reg;
            ID_EX_c_mem_write <= c_mem_write;
            ID_EX_c_mem_read <= c_mem_read;
            ID_EX_c_reg_write <= c_reg_write;
            ID_EX_c_mem_size <= c_mem_size;
            ID_EX_c_write_sel <= c_write_sel;
            ID_EX_c_alu_op <= c_alu_op;
            ID_EX_c_use_imm <= c_use_imm;
            ID_EX_c_sub <= c_i_sub;
            ID_EX_c_arith <= c_i_arith;
            ID_EX_c_unsigned <= c_i_unsigned;
            // FOR TB
            ID_EX_valid <= IF_ID_valid;
            ID_EX_instruction <= IF_ID_instruction;
            ID_EX_rs1_raddr <= rs1;
            ID_EX_rs2_raddr <= rs2;
            if (c_halted) ID_EX_c_halted <= 1; // Once halted, stay halted until reset
        end
    end

    //execute stage
    execute execute_state(
        .clk(i_clk),
        .read_data_1(ID_EX_rs1_data),
        .read_data_2(ID_EX_rs2_data),
        .PC(ID_EX_curr_pc),
        .imm_sext(ID_EX_imm),
        .use_pc_reg(ID_EX_c_use_pc_reg),
        .use_imm(ID_EX_c_use_imm),
        .alu_op(ID_EX_c_alu_op),
        .i_sub(ID_EX_c_sub),
        .i_arith(ID_EX_c_arith),
        .i_unsigned(ID_EX_c_unsigned),
        .alu_out(alu_out),
        .eq(eq),
        .slt(slt)
    );
    
    //EX/MEM pipeline register logic
    always @(posedge i_clk) begin
        if (i_rst) begin
            {EX_MEM_alu_out,
                EX_MEM_rs2_data,
                EX_MEM_imm,
                EX_MEM_pc_plus4,
                EX_MEM_write_reg,
                EX_MEM_c_unsigned,
                EX_MEM_c_mem_write,
                EX_MEM_c_mem_read,
                EX_MEM_c_reg_write,
                EX_MEM_c_write_sel,
                EX_MEM_c_mem_size,
                // FOR TB
                EX_MEM_valid,
                EX_MEM_instruction,
                EX_MEM_next_pc,
                EX_MEM_curr_pc,
                EX_MEM_rs1_raddr,
                EX_MEM_rs2_raddr,
                EX_MEM_rs1_data,
                EX_MEM_c_halted} <= 0;
        end else begin
            EX_MEM_alu_out <= alu_out;
            EX_MEM_rs2_data <= ID_EX_rs2_data;
            EX_MEM_imm <= ID_EX_imm;
            EX_MEM_pc_plus4 <= ID_EX_pc_plus4;
            EX_MEM_write_reg <= ID_EX_write_reg;
            EX_MEM_c_unsigned <= ID_EX_c_unsigned;
            EX_MEM_c_mem_write <= ID_EX_c_mem_write;
            EX_MEM_c_mem_read <= ID_EX_c_mem_read;
            EX_MEM_c_reg_write <= ID_EX_c_reg_write;
            EX_MEM_c_write_sel <= ID_EX_c_write_sel;
            EX_MEM_c_mem_size <= ID_EX_c_mem_size;
            // FOR TB
            EX_MEM_valid <= ID_EX_valid;
            EX_MEM_instruction <= ID_EX_instruction;
            EX_MEM_next_pc <= (ID_EX_c_is_jalr | c_pc_mod) ? next_pc : IF_ID_pc_plus4;
            EX_MEM_curr_pc <= ID_EX_curr_pc;
            EX_MEM_rs1_raddr <= ID_EX_rs1_raddr;
            EX_MEM_rs2_raddr <= ID_EX_rs2_raddr;
            EX_MEM_rs1_data <= ID_EX_rs1_data;
            EX_MEM_c_halted <= ID_EX_c_halted;
        end
    end

    dmem_mask mem_mask_unit(
        .mem_size(EX_MEM_c_mem_size),
        .mem_addr_lsb(EX_MEM_alu_out[1:0]),
        .mem_mask(o_dmem_mask)
    );

    dmem_rdata_aligner mem_rdata_align_unit(
        .mem_mask(o_dmem_mask),
        .mem_rdata(i_dmem_rdata),
        .i_unsigned(EX_MEM_c_unsigned),
        .mem_rdata_aligned(dmem_rdata_aligned)
    );

    dmem_wdata_aligner mem_wdata_align_unit(
        .mem_mask(o_dmem_mask),
        .mem_wdata(EX_MEM_rs2_data),
        .mem_wdata_aligned(o_dmem_wdata)
    );

    //MEM/WB pipeline register logic
    always @(posedge i_clk) begin
        if (i_rst) begin
            {MEM_WB_mem_out,
                MEM_WB_imm,
                MEM_WB_pc_plus4,
                MEM_WB_alu_out,
                MEM_WB_write_reg,
                MEM_WB_c_write_sel,
                MEM_WB_c_reg_write,
                // FOR TB
                MEM_WB_valid,
                MEM_WB_instruction,
                MEM_WB_next_pc,
                MEM_WB_curr_pc,
                MEM_WB_rs1_raddr,
                MEM_WB_rs2_raddr,
                MEM_WB_rs1_data,
                MEM_WB_rs2_data,
                MEM_WB_c_halted} <= 0;
        end else begin
            MEM_WB_mem_out <= o_dmem_wdata;
            MEM_WB_imm <= EX_MEM_imm;
            MEM_WB_pc_plus4 <= EX_MEM_pc_plus4;
            MEM_WB_alu_out <= EX_MEM_alu_out;
            MEM_WB_write_reg <= EX_MEM_write_reg;
            MEM_WB_c_write_sel <= EX_MEM_c_write_sel;
            MEM_WB_c_reg_write <= EX_MEM_c_reg_write;
            // FOR TB
            MEM_WB_valid <= EX_MEM_valid;
            MEM_WB_instruction <= EX_MEM_instruction;
            MEM_WB_next_pc <= EX_MEM_next_pc;
            MEM_WB_curr_pc <= EX_MEM_curr_pc;
            MEM_WB_rs1_raddr <= EX_MEM_rs1_raddr;
            MEM_WB_rs2_raddr <= EX_MEM_rs2_raddr;
            MEM_WB_rs1_data <= EX_MEM_rs1_data;
            MEM_WB_rs2_data <= EX_MEM_rs2_data;
            MEM_WB_c_halted <= EX_MEM_c_halted;
            MEM_WB_c_mem_read <= EX_MEM_c_mem_read;
            MEM_WB_c_mem_write <= EX_MEM_c_mem_write;
            MEM_WB_dmem_mask <= o_dmem_mask;
            MEM_WB_dmem_rdata <= i_dmem_rdata;
        end
    end

    //writeback stage - TODO: move to own module
    assign reg_write_data = (MEM_WB_c_write_sel == 0 ? MEM_WB_pc_plus4 : 
                            MEM_WB_c_write_sel == 1 ? dmem_rdata_aligned : 
                            MEM_WB_c_write_sel == 3 ? MEM_WB_imm:
                            MEM_WB_alu_out);
    
    //stalling conditions:
    // RAW hazards,
    //    - Check for RAW hazards 
    //          - Load to Use Stall //
    //          - Load and Store (MEM-MEM) 
    // Branch, Jump hazards(Branch stall til X, Jump stall till X)
    // Halt, make sure that we execute all instructions currently in the pipeline 
endmodule

`default_nettype wire
