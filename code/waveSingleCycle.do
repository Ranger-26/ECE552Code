onerror {resume}
quietly WaveActivateNextPane {} 0
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
add wave -noupdate -radix hexadecimal -childformat {{{/hart_tb/inst[31]} -radix hexadecimal} {{/hart_tb/inst[30]} -radix hexadecimal} {{/hart_tb/inst[29]} -radix hexadecimal} {{/hart_tb/inst[28]} -radix hexadecimal} {{/hart_tb/inst[27]} -radix hexadecimal} {{/hart_tb/inst[26]} -radix hexadecimal} {{/hart_tb/inst[25]} -radix hexadecimal} {{/hart_tb/inst[24]} -radix hexadecimal} {{/hart_tb/inst[23]} -radix hexadecimal} {{/hart_tb/inst[22]} -radix hexadecimal} {{/hart_tb/inst[21]} -radix hexadecimal} {{/hart_tb/inst[20]} -radix hexadecimal} {{/hart_tb/inst[19]} -radix hexadecimal} {{/hart_tb/inst[18]} -radix hexadecimal} {{/hart_tb/inst[17]} -radix hexadecimal} {{/hart_tb/inst[16]} -radix hexadecimal} {{/hart_tb/inst[15]} -radix hexadecimal} {{/hart_tb/inst[14]} -radix hexadecimal} {{/hart_tb/inst[13]} -radix hexadecimal} {{/hart_tb/inst[12]} -radix hexadecimal} {{/hart_tb/inst[11]} -radix hexadecimal} {{/hart_tb/inst[10]} -radix hexadecimal} {{/hart_tb/inst[9]} -radix hexadecimal} {{/hart_tb/inst[8]} -radix hexadecimal} {{/hart_tb/inst[7]} -radix hexadecimal} {{/hart_tb/inst[6]} -radix hexadecimal} {{/hart_tb/inst[5]} -radix hexadecimal} {{/hart_tb/inst[4]} -radix hexadecimal} {{/hart_tb/inst[3]} -radix hexadecimal} {{/hart_tb/inst[2]} -radix hexadecimal} {{/hart_tb/inst[1]} -radix hexadecimal} {{/hart_tb/inst[0]} -radix hexadecimal}} -subitemconfig {{/hart_tb/inst[31]} {-height 15 -radix hexadecimal} {/hart_tb/inst[30]} {-height 15 -radix hexadecimal} {/hart_tb/inst[29]} {-height 15 -radix hexadecimal} {/hart_tb/inst[28]} {-height 15 -radix hexadecimal} {/hart_tb/inst[27]} {-height 15 -radix hexadecimal} {/hart_tb/inst[26]} {-height 15 -radix hexadecimal} {/hart_tb/inst[25]} {-height 15 -radix hexadecimal} {/hart_tb/inst[24]} {-height 15 -radix hexadecimal} {/hart_tb/inst[23]} {-height 15 -radix hexadecimal} {/hart_tb/inst[22]} {-height 15 -radix hexadecimal} {/hart_tb/inst[21]} {-height 15 -radix hexadecimal} {/hart_tb/inst[20]} {-height 15 -radix hexadecimal} {/hart_tb/inst[19]} {-height 15 -radix hexadecimal} {/hart_tb/inst[18]} {-height 15 -radix hexadecimal} {/hart_tb/inst[17]} {-height 15 -radix hexadecimal} {/hart_tb/inst[16]} {-height 15 -radix hexadecimal} {/hart_tb/inst[15]} {-height 15 -radix hexadecimal} {/hart_tb/inst[14]} {-height 15 -radix hexadecimal} {/hart_tb/inst[13]} {-height 15 -radix hexadecimal} {/hart_tb/inst[12]} {-height 15 -radix hexadecimal} {/hart_tb/inst[11]} {-height 15 -radix hexadecimal} {/hart_tb/inst[10]} {-height 15 -radix hexadecimal} {/hart_tb/inst[9]} {-height 15 -radix hexadecimal} {/hart_tb/inst[8]} {-height 15 -radix hexadecimal} {/hart_tb/inst[7]} {-height 15 -radix hexadecimal} {/hart_tb/inst[6]} {-height 15 -radix hexadecimal} {/hart_tb/inst[5]} {-height 15 -radix hexadecimal} {/hart_tb/inst[4]} {-height 15 -radix hexadecimal} {/hart_tb/inst[3]} {-height 15 -radix hexadecimal} {/hart_tb/inst[2]} {-height 15 -radix hexadecimal} {/hart_tb/inst[1]} {-height 15 -radix hexadecimal} {/hart_tb/inst[0]} {-height 15 -radix hexadecimal}} /hart_tb/inst
add wave -noupdate -radix unsigned /hart_tb/rs1_raddr
add wave -noupdate -radix unsigned /hart_tb/rs2_raddr
add wave -noupdate /hart_tb/rs1_rdata
add wave -noupdate /hart_tb/rs2_rdata
add wave -noupdate -radix unsigned /hart_tb/rd_waddr
add wave -noupdate /hart_tb/rd_wdata
add wave -noupdate -radix hexadecimal /hart_tb/pc
add wave -noupdate -radix hexadecimal /hart_tb/next_pc
add wave -noupdate /hart_tb/cycles
add wave -noupdate /hart_tb/run
add wave -noupdate -divider Fetch
add wave -noupdate -radix hexadecimal /hart_tb/dut/fetch_stage/PC
add wave -noupdate -radix hexadecimal /hart_tb/dut/fetch_stage/nxt_pc
add wave -noupdate -radix hexadecimal /hart_tb/dut/fetch_stage/ProgramCounter
add wave -noupdate -radix binary /hart_tb/dut/fetch_stage/pcmod
add wave -noupdate -radix binary /hart_tb/dut/fetch_stage/is_jal_r
add wave -noupdate -radix binary /hart_tb/dut/fetch_stage/halted
add wave -noupdate -divider ControlUnit
add wave -noupdate /hart_tb/dut/control_unit_state/_eq
add wave -noupdate /hart_tb/dut/control_unit_state/_slt
add wave -noupdate /hart_tb/dut/control_unit_state/_instruction
add wave -noupdate /hart_tb/dut/control_unit_state/c_halted
add wave -noupdate /hart_tb/dut/control_unit_state/c_is_jal_r
add wave -noupdate /hart_tb/dut/control_unit_state/c_pc_mod
add wave -noupdate /hart_tb/dut/control_unit_state/c_use_pc_reg
add wave -noupdate /hart_tb/dut/control_unit_state/c_mem_write
add wave -noupdate /hart_tb/dut/control_unit_state/c_mem_read
add wave -noupdate /hart_tb/dut/control_unit_state/c_reg_write
add wave -noupdate /hart_tb/dut/control_unit_state/c_mem_size
add wave -noupdate /hart_tb/dut/control_unit_state/c_write_sel
add wave -noupdate /hart_tb/dut/control_unit_state/c_alu_op
add wave -noupdate /hart_tb/dut/control_unit_state/c_use_imm
add wave -noupdate /hart_tb/dut/control_unit_state/c_i_sub
add wave -noupdate /hart_tb/dut/control_unit_state/c_i_arith
add wave -noupdate /hart_tb/dut/control_unit_state/c_i_unsigned
add wave -noupdate /hart_tb/dut/control_unit_state/opcode
add wave -noupdate /hart_tb/dut/control_unit_state/funct3
add wave -noupdate /hart_tb/dut/control_unit_state/funct7
add wave -noupdate /hart_tb/dut/control_unit_state/opcode
add wave -noupdate /hart_tb/dut/control_unit_state/funct3
add wave -noupdate /hart_tb/dut/control_unit_state/funct7
add wave -noupdate -divider ALU
add wave -noupdate /hart_tb/dut/execute_state/alu_main/i_opsel
add wave -noupdate /hart_tb/dut/execute_state/alu_main/i_sub
add wave -noupdate /hart_tb/dut/execute_state/alu_main/i_unsigned
add wave -noupdate /hart_tb/dut/execute_state/alu_main/i_arith
add wave -noupdate /hart_tb/dut/execute_state/alu_main/i_op1
add wave -noupdate /hart_tb/dut/execute_state/alu_main/i_op2
add wave -noupdate /hart_tb/dut/execute_state/alu_main/o_result
add wave -noupdate /hart_tb/dut/execute_state/alu_main/o_eq
add wave -noupdate /hart_tb/dut/execute_state/alu_main/o_slt
add wave -noupdate /hart_tb/dut/execute_state/alu_main/addition
add wave -noupdate /hart_tb/dut/execute_state/alu_main/subtraction
add wave -noupdate /hart_tb/dut/execute_state/alu_main/shiftLeftLogical
add wave -noupdate /hart_tb/dut/execute_state/alu_main/exclusiveOr
add wave -noupdate /hart_tb/dut/execute_state/alu_main/shiftRightLogical
add wave -noupdate /hart_tb/dut/execute_state/alu_main/orResult
add wave -noupdate /hart_tb/dut/execute_state/alu_main/andResult
add wave -noupdate /hart_tb/dut/execute_state/alu_main/unsignedLessThan
add wave -noupdate /hart_tb/dut/execute_state/alu_main/signedLessThan
add wave -noupdate /hart_tb/dut/execute_state/alu_main/overflowOccured
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {39 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 338
configure wave -valuecolwidth 241
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
WaveRestoreZoom {0 ps} {193 ps}
