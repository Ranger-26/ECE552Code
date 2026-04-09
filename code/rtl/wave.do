onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /hart_tb_sta/clk
add wave -noupdate /hart_tb_sta/rst
add wave -noupdate /hart_tb_sta/imem_rdata
add wave -noupdate /hart_tb_sta/dmem_rdata
add wave -noupdate /hart_tb_sta/imem_raddr
add wave -noupdate /hart_tb_sta/dmem_addr
add wave -noupdate /hart_tb_sta/dmem_ren
add wave -noupdate /hart_tb_sta/dmem_wen
add wave -noupdate /hart_tb_sta/dmem_wdata
add wave -noupdate /hart_tb_sta/dmem_mask
add wave -noupdate /hart_tb_sta/o_dmem_done
add wave -noupdate /hart_tb_sta/o_imem_done
add wave -noupdate /hart_tb_sta/o_dmem_addr
add wave -noupdate /hart_tb_sta/o_imem_addr
add wave -noupdate /hart_tb_sta/valid
add wave -noupdate /hart_tb_sta/trap
add wave -noupdate /hart_tb_sta/halt
add wave -noupdate /hart_tb_sta/inst
add wave -noupdate /hart_tb_sta/rs1_raddr
add wave -noupdate /hart_tb_sta/rs2_raddr
add wave -noupdate /hart_tb_sta/rs1_rdata
add wave -noupdate /hart_tb_sta/rs2_rdata
add wave -noupdate /hart_tb_sta/rd_waddr
add wave -noupdate /hart_tb_sta/rd_wdata
add wave -noupdate /hart_tb_sta/pc
add wave -noupdate /hart_tb_sta/next_pc
add wave -noupdate /hart_tb_sta/retire_dmem_addr
add wave -noupdate /hart_tb_sta/retire_dmem_ren
add wave -noupdate /hart_tb_sta/retire_dmem_wen
add wave -noupdate /hart_tb_sta/retire_dmem_mask
add wave -noupdate /hart_tb_sta/retire_dmem_rdata
add wave -noupdate /hart_tb_sta/retire_dmem_wdata
add wave -noupdate /hart_tb_sta/imem_ready
add wave -noupdate /hart_tb_sta/imem_ren
add wave -noupdate /hart_tb_sta/imem_valid
add wave -noupdate /hart_tb_sta/dmem_ready
add wave -noupdate /hart_tb_sta/dmem_valid
add wave -noupdate /hart_tb_sta/cycles
add wave -noupdate /hart_tb_sta/run
add wave -noupdate /hart_tb_sta/num_instructions
add wave -noupdate /hart_tb_sta/watchdog
add wave -noupdate -divider DUT
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/i_clk
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/i_rst
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/i_imem_ready
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_imem_raddr
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_imem_ren
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/i_imem_valid
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/i_imem_rdata
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/stall_pc
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/i_dmem_ready
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_dmem_addr
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_dmem_ren
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_dmem_wen
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_dmem_wdata
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_dmem_mask
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/i_dmem_valid
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/i_dmem_rdata
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_retire_valid
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_retire_inst
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_retire_trap
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_retire_halt
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_retire_rs1_raddr
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_retire_rs2_raddr
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_retire_rs1_rdata
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_retire_rs2_rdata
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_retire_rd_waddr
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_retire_rd_wdata
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_retire_dmem_addr
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_retire_dmem_mask
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_retire_dmem_ren
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_retire_dmem_wen
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_retire_dmem_rdata
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_retire_dmem_wdata
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_retire_pc
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/o_retire_next_pc
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/eq
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/slt
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/alu_out
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_TO_EX_data
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/c_halted
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/c_is_jalr
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/c_pc_mod
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/c_use_pc_reg
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/c_mem_write
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/c_mem_read
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/c_reg_write
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/c_mem_size
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/c_write_sel
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/c_alu_op
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/c_use_imm
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/c_i_sub
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/c_i_arith
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/c_i_unsigned
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/format
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/branch_target_addr
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/jalr_target_addr
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/reg_write_data
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/dmem_rdata_aligned
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/PC
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/pc_plus4
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/next_pc
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/rd
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/rs1
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/rs2
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/imm_sext
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/rs1_data
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/rs2_data
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/IF_ID_curr_pc
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/IF_ID_pc_plus4
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/IF_ID_instruction
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/IF_ID_format
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/IF_ID_rs1
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/IF_ID_rs2
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/IF_ID_rd
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/IF_ID_valid
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_rs1_data
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_rs2_data
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_imm
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_pc_plus4
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_curr_pc
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_write_reg
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_opcode
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_funct3
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_c_is_jalr
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_c_use_pc_reg
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_c_mem_write
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_c_mem_read
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_c_reg_write
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_c_mem_size
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_c_write_sel
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_c_alu_op
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_c_use_imm
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_c_sub
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_c_arith
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_c_unsigned
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_format
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_valid
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_instruction
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_rs1_raddr
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_rs2_raddr
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/ID_EX_c_halted
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_alu_out
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_rs2_data
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_imm
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_pc_plus4
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_write_reg
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_funct3
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_c_unsigned
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_c_mem_write
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_c_mem_read
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_c_reg_write
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_c_write_sel
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_c_mem_size
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_valid
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_instruction
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_next_pc
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_curr_pc
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_rs1_raddr
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_rs2_raddr
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_rs1_data
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_c_halted
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_op2
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/op1
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/op2
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_mem_out
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_imm
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_pc_plus4
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_alu_out
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_write_reg
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_dmem_rdata_aligned
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_c_write_sel
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_c_reg_write
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_valid
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_instruction
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_next_pc
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_curr_pc
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_rs1_raddr
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_rs2_raddr
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_rs1_data
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_rs2_data
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_c_halted
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_c_mem_read
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_c_mem_write
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_dmem_mask
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_dmem_rdata
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_dmem_addr
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/MEM_WB_dmem_wdata_aligned
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/effective_halted
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/stall_IF
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/stall_ID
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/stall_MEM
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/rst_IF_ID
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/rst_ID_EX
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/rst_MEM_WB
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/forward_A
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/forward_B
add wave -noupdate -radix hexadecimal /hart_tb_sta/dut/EX_MEM_opcode
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {35000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 557
configure wave -valuecolwidth 111
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
WaveRestoreZoom {54688402 ps} {65179558 ps}
