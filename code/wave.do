onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Testbench
add wave -noupdate /hart_tb/clk
add wave -noupdate /hart_tb/rst
add wave -noupdate /hart_tb/imem_rdata
add wave -noupdate /hart_tb/dmem_rdata
add wave -noupdate /hart_tb/imem_raddr
add wave -noupdate /hart_tb/dmem_addr
add wave -noupdate /hart_tb/dmem_ren
add wave -noupdate /hart_tb/dmem_wen
add wave -noupdate /hart_tb/dmem_wdata
add wave -noupdate /hart_tb/dmem_mask
add wave -noupdate /hart_tb/valid
add wave -noupdate /hart_tb/trap
add wave -noupdate /hart_tb/halt
add wave -noupdate /hart_tb/inst
add wave -noupdate /hart_tb/rs1_raddr
add wave -noupdate /hart_tb/rs2_raddr
add wave -noupdate /hart_tb/rs1_rdata
add wave -noupdate /hart_tb/rs2_rdata
add wave -noupdate /hart_tb/rd_waddr
add wave -noupdate /hart_tb/rd_wdata
add wave -noupdate /hart_tb/pc
add wave -noupdate /hart_tb/next_pc
add wave -noupdate /hart_tb/retire_dmem_addr
add wave -noupdate /hart_tb/retire_dmem_ren
add wave -noupdate /hart_tb/retire_dmem_wen
add wave -noupdate /hart_tb/retire_dmem_mask
add wave -noupdate /hart_tb/retire_dmem_rdata
add wave -noupdate /hart_tb/retire_dmem_wdata
add wave -noupdate /hart_tb/cycles
add wave -noupdate /hart_tb/run
add wave -noupdate /hart_tb/num_instructions
add wave -noupdate /hart_tb/watchdog
add wave -noupdate -divider HartInterface
add wave -noupdate /hart_tb/dut/i_clk
add wave -noupdate /hart_tb/dut/i_rst
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_imem_raddr
add wave -noupdate -radix hexadecimal /hart_tb/dut/i_imem_rdata
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_dmem_addr
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_dmem_ren
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_dmem_wen
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_dmem_wdata
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_dmem_mask
add wave -noupdate -radix hexadecimal /hart_tb/dut/i_dmem_rdata
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_retire_valid
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_retire_inst
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_retire_trap
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_retire_halt
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_retire_rs1_raddr
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_retire_rs2_raddr
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_retire_rs1_rdata
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_retire_rs2_rdata
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_retire_rd_waddr
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_retire_rd_wdata
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_retire_next_pc
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_retire_dmem_addr
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_retire_dmem_ren
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_retire_dmem_wen
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_retire_dmem_mask
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_retire_dmem_wdata
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_retire_dmem_rdata
add wave -noupdate -radix hexadecimal /hart_tb/dut/eq
add wave -noupdate -radix hexadecimal /hart_tb/dut/slt
add wave -noupdate -radix hexadecimal /hart_tb/dut/alu_out
add wave -noupdate -radix hexadecimal /hart_tb/dut/c_halted
add wave -noupdate -radix hexadecimal /hart_tb/dut/c_is_jalr
add wave -noupdate -radix hexadecimal /hart_tb/dut/c_pc_mod
add wave -noupdate -radix hexadecimal /hart_tb/dut/c_use_pc_reg
add wave -noupdate -radix hexadecimal /hart_tb/dut/c_mem_write
add wave -noupdate -radix hexadecimal /hart_tb/dut/c_mem_read
add wave -noupdate -radix hexadecimal /hart_tb/dut/c_reg_write
add wave -noupdate -radix hexadecimal /hart_tb/dut/c_mem_size
add wave -noupdate -radix hexadecimal /hart_tb/dut/c_write_sel
add wave -noupdate -radix hexadecimal /hart_tb/dut/c_alu_op
add wave -noupdate -radix hexadecimal /hart_tb/dut/c_use_imm
add wave -noupdate -radix hexadecimal /hart_tb/dut/c_i_sub
add wave -noupdate -radix hexadecimal /hart_tb/dut/c_i_arith
add wave -noupdate -radix hexadecimal /hart_tb/dut/c_i_unsigned
add wave -noupdate -radix hexadecimal /hart_tb/dut/branch_target_addr
add wave -noupdate -radix hexadecimal /hart_tb/dut/jalr_target_addr
add wave -noupdate -radix hexadecimal /hart_tb/dut/reg_write_data
add wave -noupdate -radix hexadecimal /hart_tb/dut/dmem_rdata_aligned
add wave -noupdate -radix hexadecimal /hart_tb/dut/PC
add wave -noupdate -radix hexadecimal /hart_tb/dut/pc_plus4
add wave -noupdate -radix hexadecimal /hart_tb/dut/next_pc
add wave -noupdate -radix hexadecimal /hart_tb/dut/rd
add wave -noupdate -radix hexadecimal /hart_tb/dut/rs1
add wave -noupdate -radix hexadecimal /hart_tb/dut/rs2
add wave -noupdate -radix hexadecimal /hart_tb/dut/imm_sext
add wave -noupdate -radix hexadecimal /hart_tb/dut/rs1_data
add wave -noupdate -radix hexadecimal /hart_tb/dut/rs2_data
add wave -noupdate -radix hexadecimal /hart_tb/dut/IF_ID_curr_pc
add wave -noupdate -radix hexadecimal /hart_tb/dut/IF_ID_pc_plus4
add wave -noupdate -radix hexadecimal /hart_tb/dut/IF_ID_instruction
add wave -noupdate -radix hexadecimal /hart_tb/dut/IF_ID_format
add wave -noupdate -radix hexadecimal /hart_tb/dut/IF_ID_rs1
add wave -noupdate -radix hexadecimal /hart_tb/dut/IF_ID_rs2
add wave -noupdate -radix hexadecimal /hart_tb/dut/IF_ID_rd
add wave -noupdate -radix hexadecimal /hart_tb/dut/IF_ID_valid
add wave -noupdate -radix hexadecimal /hart_tb/dut/ID_EX_rs1_data
add wave -noupdate -radix hexadecimal /hart_tb/dut/ID_EX_rs2_data
add wave -noupdate -radix hexadecimal /hart_tb/dut/ID_EX_imm
add wave -noupdate -radix hexadecimal /hart_tb/dut/ID_EX_pc_plus4
add wave -noupdate -radix hexadecimal /hart_tb/dut/ID_EX_curr_pc
add wave -noupdate /hart_tb/dut/ID_EX_write_reg
add wave -noupdate /hart_tb/dut/ID_EX_opcode
add wave -noupdate /hart_tb/dut/ID_EX_funct3
add wave -noupdate /hart_tb/dut/ID_EX_c_is_jalr
add wave -noupdate /hart_tb/dut/ID_EX_c_use_pc_reg
add wave -noupdate /hart_tb/dut/ID_EX_c_mem_write
add wave -noupdate /hart_tb/dut/ID_EX_c_mem_read
add wave -noupdate /hart_tb/dut/ID_EX_c_reg_write
add wave -noupdate /hart_tb/dut/ID_EX_c_mem_size
add wave -noupdate /hart_tb/dut/ID_EX_c_write_sel
add wave -noupdate /hart_tb/dut/ID_EX_c_alu_op
add wave -noupdate /hart_tb/dut/ID_EX_c_use_imm
add wave -noupdate /hart_tb/dut/ID_EX_c_sub
add wave -noupdate -radix hexadecimal /hart_tb/dut/ID_EX_c_arith
add wave -noupdate -radix hexadecimal /hart_tb/dut/ID_EX_c_unsigned
add wave -noupdate -radix hexadecimal /hart_tb/dut/ID_EX_valid
add wave -noupdate -radix hexadecimal /hart_tb/dut/ID_EX_instruction
add wave -noupdate -radix hexadecimal /hart_tb/dut/ID_EX_rs1_raddr
add wave -noupdate -radix hexadecimal /hart_tb/dut/ID_EX_rs2_raddr
add wave -noupdate -radix hexadecimal /hart_tb/dut/ID_EX_c_halted
add wave -noupdate -radix hexadecimal /hart_tb/dut/EX_MEM_alu_out
add wave -noupdate -radix hexadecimal /hart_tb/dut/EX_MEM_rs2_data
add wave -noupdate -radix hexadecimal /hart_tb/dut/EX_MEM_imm
add wave -noupdate -radix hexadecimal /hart_tb/dut/EX_MEM_pc_plus4
add wave -noupdate -radix hexadecimal /hart_tb/dut/EX_MEM_write_reg
add wave -noupdate -radix hexadecimal /hart_tb/dut/EX_MEM_c_unsigned
add wave -noupdate -radix hexadecimal /hart_tb/dut/EX_MEM_c_mem_write
add wave -noupdate -radix hexadecimal /hart_tb/dut/EX_MEM_c_mem_read
add wave -noupdate -radix hexadecimal /hart_tb/dut/EX_MEM_c_reg_write
add wave -noupdate -radix hexadecimal /hart_tb/dut/EX_MEM_c_write_sel
add wave -noupdate -radix hexadecimal /hart_tb/dut/EX_MEM_c_mem_size
add wave -noupdate -radix hexadecimal /hart_tb/dut/EX_MEM_valid
add wave -noupdate -radix hexadecimal /hart_tb/dut/EX_MEM_instruction
add wave -noupdate -radix hexadecimal /hart_tb/dut/EX_MEM_next_pc
add wave -noupdate -radix hexadecimal /hart_tb/dut/EX_MEM_curr_pc
add wave -noupdate -radix hexadecimal /hart_tb/dut/EX_MEM_rs1_raddr
add wave -noupdate -radix hexadecimal /hart_tb/dut/EX_MEM_rs2_raddr
add wave -noupdate -radix hexadecimal /hart_tb/dut/EX_MEM_rs1_data
add wave -noupdate -radix hexadecimal /hart_tb/dut/EX_MEM_c_halted
add wave -noupdate -radix hexadecimal /hart_tb/dut/MEM_WB_mem_out
add wave -noupdate -radix hexadecimal /hart_tb/dut/MEM_WB_imm
add wave -noupdate -radix hexadecimal /hart_tb/dut/MEM_WB_pc_plus4
add wave -noupdate -radix hexadecimal /hart_tb/dut/MEM_WB_alu_out
add wave -noupdate -radix hexadecimal /hart_tb/dut/MEM_WB_write_reg
add wave -noupdate -radix hexadecimal /hart_tb/dut/MEM_WB_c_write_sel
add wave -noupdate -radix hexadecimal /hart_tb/dut/MEM_WB_c_reg_write
add wave -noupdate -radix hexadecimal /hart_tb/dut/MEM_WB_valid
add wave -noupdate -radix hexadecimal /hart_tb/dut/MEM_WB_instruction
add wave -noupdate -radix hexadecimal /hart_tb/dut/MEM_WB_next_pc
add wave -noupdate -radix hexadecimal /hart_tb/dut/MEM_WB_curr_pc
add wave -noupdate -radix hexadecimal /hart_tb/dut/MEM_WB_rs1_raddr
add wave -noupdate -radix hexadecimal /hart_tb/dut/MEM_WB_rs2_raddr
add wave -noupdate -radix hexadecimal /hart_tb/dut/MEM_WB_rs1_data
add wave -noupdate -radix hexadecimal /hart_tb/dut/MEM_WB_rs2_data
add wave -noupdate -radix hexadecimal /hart_tb/dut/MEM_WB_c_halted
add wave -noupdate /hart_tb/dut/effective_halted
add wave -noupdate -radix hexadecimal /hart_tb/dut/o_retire_pc
add wave -noupdate -divider {Register FIle}
add wave -noupdate /hart_tb/dut/reg_file/i_clk
add wave -noupdate /hart_tb/dut/reg_file/i_rst
add wave -noupdate -radix hexadecimal /hart_tb/dut/reg_file/i_rs1_raddr
add wave -noupdate -radix hexadecimal /hart_tb/dut/reg_file/o_rs1_rdata
add wave -noupdate -radix hexadecimal /hart_tb/dut/reg_file/i_rs2_raddr
add wave -noupdate -radix hexadecimal /hart_tb/dut/reg_file/o_rs2_rdata
add wave -noupdate -radix hexadecimal /hart_tb/dut/reg_file/i_rd_wen
add wave -noupdate -radix hexadecimal /hart_tb/dut/reg_file/i_rd_waddr
add wave -noupdate -radix hexadecimal /hart_tb/dut/reg_file/i_rd_wdata
add wave -noupdate -radix hexadecimal -childformat {{{/hart_tb/dut/reg_file/memory[31]} -radix hexadecimal -childformat {{{/hart_tb/dut/reg_file/memory[31][31]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][30]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][29]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][28]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][27]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][26]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][25]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][24]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][23]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][22]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][21]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][20]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][19]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][18]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][17]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][16]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][15]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][14]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][13]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][12]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][11]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][10]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][9]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][8]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][7]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][6]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][5]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][4]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][3]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][2]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][1]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][0]} -radix hexadecimal}}} {{/hart_tb/dut/reg_file/memory[30]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[29]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[28]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[27]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[26]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[25]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[24]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[23]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[22]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[21]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[20]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[19]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[18]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[17]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[16]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[15]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[14]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[13]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[12]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[11]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[10]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[9]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[8]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[7]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[6]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[5]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[4]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[3]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[2]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[1]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[0]} -radix hexadecimal}} -subitemconfig {{/hart_tb/dut/reg_file/memory[31]} {-height 15 -radix hexadecimal -childformat {{{/hart_tb/dut/reg_file/memory[31][31]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][30]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][29]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][28]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][27]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][26]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][25]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][24]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][23]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][22]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][21]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][20]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][19]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][18]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][17]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][16]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][15]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][14]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][13]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][12]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][11]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][10]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][9]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][8]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][7]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][6]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][5]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][4]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][3]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][2]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][1]} -radix hexadecimal} {{/hart_tb/dut/reg_file/memory[31][0]} -radix hexadecimal}}} {/hart_tb/dut/reg_file/memory[31][31]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][30]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][29]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][28]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][27]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][26]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][25]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][24]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][23]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][22]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][21]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][20]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][19]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][18]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][17]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][16]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][15]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][14]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][13]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][12]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][11]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][10]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][9]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][8]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][7]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][6]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][5]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][4]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][3]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][2]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][1]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[31][0]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[30]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[29]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[28]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[27]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[26]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[25]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[24]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[23]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[22]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[21]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[20]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[19]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[18]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[17]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[16]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[15]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[14]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[13]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[12]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[11]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[10]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[9]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[8]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[7]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[6]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[5]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[4]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[3]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[2]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[1]} {-height 15 -radix hexadecimal} {/hart_tb/dut/reg_file/memory[0]} {-height 15 -radix hexadecimal}} /hart_tb/dut/reg_file/memory
add wave -noupdate -divider Forwarding
add wave -noupdate /hart_tb/dut/forwarding_unit_state/ID_EX_rs1
add wave -noupdate /hart_tb/dut/forwarding_unit_state/ID_EX_rs2
add wave -noupdate /hart_tb/dut/forwarding_unit_state/EX_MEM_write_reg
add wave -noupdate /hart_tb/dut/forwarding_unit_state/EX_MEM_wen
add wave -noupdate /hart_tb/dut/forwarding_unit_state/MEM_WB_write_reg
add wave -noupdate /hart_tb/dut/forwarding_unit_state/MEM_WB_wen
add wave -noupdate /hart_tb/dut/forwarding_unit_state/forward_A
add wave -noupdate /hart_tb/dut/forwarding_unit_state/forward_B
add wave -noupdate -divider {Hazard Detector}
add wave -noupdate /hart_tb/dut/hazard_detector_state/IF_ID_rs1
add wave -noupdate /hart_tb/dut/hazard_detector_state/IF_ID_rs2
add wave -noupdate /hart_tb/dut/hazard_detector_state/IF_ID_format
add wave -noupdate /hart_tb/dut/hazard_detector_state/ID_EX_format
add wave -noupdate /hart_tb/dut/hazard_detector_state/ID_EX_write_reg
add wave -noupdate /hart_tb/dut/hazard_detector_state/EX_MEM_write_reg
add wave -noupdate /hart_tb/dut/hazard_detector_state/ID_EX_mem_read
add wave -noupdate /hart_tb/dut/hazard_detector_state/c_is_jalr
add wave -noupdate /hart_tb/dut/hazard_detector_state/i_o_eq
add wave -noupdate /hart_tb/dut/hazard_detector_state/i_o_slt
add wave -noupdate /hart_tb/dut/hazard_detector_state/EX_MEM_c_unsigned
add wave -noupdate /hart_tb/dut/hazard_detector_state/ID_EX_funct3
add wave -noupdate /hart_tb/dut/hazard_detector_state/ID_EX_c_is_jalr
add wave -noupdate /hart_tb/dut/hazard_detector_state/stall_pc
add wave -noupdate /hart_tb/dut/hazard_detector_state/stall_IF
add wave -noupdate /hart_tb/dut/hazard_detector_state/stall_ID
add wave -noupdate /hart_tb/dut/hazard_detector_state/ID_control_flow
add wave -noupdate /hart_tb/dut/hazard_detector_state/EX_control_flow
add wave -noupdate /hart_tb/dut/hazard_detector_state/load_to_use_stall
add wave -noupdate /hart_tb/dut/hazard_detector_state/Branch_taken
add wave -noupdate -divider Execute
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/clk
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/read_data_1
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/read_data_2
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/PC
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/imm_sext
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/use_pc_reg
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/use_imm
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/alu_op
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/i_sub
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/i_arith
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/i_unsigned
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/forward_A
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/forward_B
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/i_EX_TO_EX_data
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/i_MEM_TO_EX_data
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/alu_out
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/eq
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/slt
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/op1
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/op2
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/forwardless_op1
add wave -noupdate -radix hexadecimal /hart_tb/dut/execute_state/forwardless_op2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {253015 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 574
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {117030 ps} {343433 ps}
