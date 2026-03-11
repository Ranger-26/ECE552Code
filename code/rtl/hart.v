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
    // Fill in your implementation here.
    
    //ALU Output signals
    wire eq;
    wire slt;
    wire [31:0] alu_out;

    //Control Unit Signals
    wire c_halted; 
    wire c_is_jal_r; 
    wire c_pc_mod; 
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

    
    wire [31:0] branch_target_addr;
    wire [31:0] jalr_target_addr;

    wire [31:0] reg_write_data;

    // Aligned dmem output
    wire [31:0] dmem_rdata_aligned;

    //fetch output signals
    wire [31:0] PC;

    //decode output signals
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [31:0] imm_sext;

    //register file outputs
    wire [31:0] rs1_data;
    wire [31:0] rs2_data; 

    //Pipeline registers
    reg [63:0] FD; //store the current PC, and the current instruction bitss
    reg [200:0]  DX; //store register read 1, register read 2, reg 1 value, reg 2 value, write register, immediate, opcode+funct3, next pc, branch target address,WReg, Every Control Signal
    reg [1:0] XM; //ALUOUT, imm, next pc - CONTROL: i_uns, MemW, MemR, RegWriteSel, MemSize
    reg [1:0] MW; // MemOut, WriteSel, AluOut, Imm, Nextpc
    
    //assigning signals for outputs
    assign o_retire_valid = 1; // wrong, needs to be in an always block?
    assign o_retire_inst = i_imem_rdata;
    assign o_imem_raddr = PC;
    assign o_retire_pc = PC;
    assign o_retire_rs1_raddr = rs1;
    assign o_retire_rs2_raddr = rs2;
    assign o_retire_rd_waddr = c_reg_write ? rd : 5'd0; // if not writing to a register, set to 0
    assign o_retire_trap = 0;
    assign o_retire_halt = c_halted;
    assign o_retire_rs1_rdata = rs1_data;
    assign o_retire_rs2_rdata = rs2_data;
    assign o_retire_rd_wdata = reg_write_data;
    assign o_dmem_addr = {alu_out[31:2], 2'b00}; // align to word boundary
    assign o_dmem_wen = c_mem_write;
    assign o_dmem_ren = c_mem_read;


    assign branch_target_addr = PC + imm_sext;
    assign jalr_target_addr = {alu_out[31:1], 1'b0}; // ensure target is even by zeroing LSB



    //control unit
    control_unit control_unit_state(
        ._eq(eq),
        ._slt(slt),
        ._instruction(i_imem_rdata),
        .c_halted(c_halted),
        .c_is_jal_r(c_is_jal_r),
        .c_pc_mod(c_pc_mod),
        .c_use_pc_reg(c_use_pc_reg),
        .c_mem_write(c_mem_write),
        .c_mem_read(c_mem_read),
        .c_reg_write(c_reg_write),
        .c_mem_size(c_mem_size),
        .c_write_sel(c_write_sel),
        .c_alu_op(c_alu_op),
        .c_use_imm(c_use_imm),
        .c_i_sub(c_i_sub),
        .c_i_arith(c_i_arith),
        .c_i_unsigned(c_i_unsigned)
    );



    
    //fetch unit
    fetch fetch_stage(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .pcmod(c_pc_mod),
        .branch_target_addr(branch_target_addr),
        .jalr_target_addr(jalr_target_addr),
        .is_jal_r(c_is_jal_r),
        .halted(c_halted),
        .PC(PC),
        .nxt_pc(o_retire_next_pc)
    );

    //decode
    decode decode_state(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .instruction(i_imem_rdata),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .imm_sext(imm_sext)
    );

    //register file
    rf reg_file(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_rs1_raddr(rs1),
        .i_rs2_raddr(rs2),
        .i_rd_wen(c_reg_write),
        .i_rd_waddr(rd),
        .i_rd_wdata(reg_write_data),
        .o_rs1_rdata(rs1_data),
        .o_rs2_rdata(rs2_data)
    );

    //execute stage
    execute execute_state(
        .clk(i_clk),
        .rst(i_rst),
        .read_data_1(rs1_data),
        .read_data_2(rs2_data),
        .PC(PC),
        .imm_sext(imm_sext),
        .use_pc_reg(c_use_pc_reg),
        .use_imm(c_use_imm),
        .alu_op(c_alu_op),
        .i_sub(c_i_sub),
        .i_arith(c_i_arith),
        .i_unsigned(c_i_unsigned),
        .alu_out(alu_out),
        .eq(eq),
        .slt(slt)
    );
    
    dmem_mask mem_mask_unit(
        .mem_size(c_mem_size),
        .mem_addr_lsb(alu_out[1:0]),
        .mem_mask(o_dmem_mask)
    );

    dmem_rdata_aligner mem_rdata_align_unit(
        .mem_mask(o_dmem_mask),
        .mem_rdata(i_dmem_rdata),
        .i_unsigned(c_i_unsigned),
        .mem_rdata_aligned(dmem_rdata_aligned)
    );

    dmem_wdata_aligner mem_wdata_align_unit(
        .mem_mask(o_dmem_mask),
        .mem_wdata(rs2_data),
        .mem_wdata_aligned(o_dmem_wdata)
    );
    //writeback stage - TODO: move to own module
    assign reg_write_data = (c_write_sel == 0 ? PC + 4 : 
                            c_write_sel == 1 ? dmem_rdata_aligned : 
                            c_write_sel == 3 ? imm_sext:
                            alu_out);
    //stalling conditions:
    // RAW hazards,
    //    - Check for RAW hazards 
    //          - Load to Use Stall //
    //          - Load and Store (MEM-MEM) 
    // Branch, Jump hazards(Branch stall til X, Jump stall till X)
    // Halt, make sure that we execute all instructions currently in the pipeline 
endmodule

`default_nettype wire
