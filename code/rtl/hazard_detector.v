
`default_nettype none

// The immediate generator is responsible for decoding the 32-bit sign-extended
// immediate from the incoming instruction word. It is a purely combinational
// block that is expected to be embedded in the instruction decoder.
module hazard_detector (
  input wire [4:0] i_IF_ID_rs1,
  input wire [4:0] i_IF_ID_rs2,
  input wire [5:0] i_IF_ID_format,
  input wire [5:0] i_ID_EX_format,
  input wire [4:0] i_ID_EX_write_reg,
  input wire [4:0] i_EX_MEM_write_reg,
  input wire [5:0] i_EX_MEM_format,
  input wire i_EX_MEM_c_mem_read,
  input wire i_ID_EX_mem_read,
  input wire i_c_is_jalr,
  input wire i_o_eq,
  input wire i_o_slt,
  input wire i_EX_MEM_c_unsigned,
  input wire [2:0] i_ID_EX_funct3,
  input wire i_ID_EX_c_is_jalr,
  //stall for memory latency
  input wire i_imem_valid,
  input wire i_dmem_valid,
  input wire i_dmem_ready,
  output wire o_stall_pc,
  output wire o_stall_IF,
  output wire o_stall_ID,
  output wire o_stall_MEM
);
  localparam J_TYPE = 6'b100000;
  localparam B_TYPE = 6'b001000;
  localparam S_TYPE = 6'b000100;
  localparam R_TYPE = 6'b000001;
  localparam I_TYPE = 6'b000010;

  wire Branch_taken = (i_ID_EX_format == B_TYPE) &
    (i_ID_EX_funct3[0] ^ (i_ID_EX_funct3[2] ? i_o_slt : i_o_eq)); // same convenient logic as control unit for branch conditions

  //detect load to use stalls and branch/jump stalls(need to remove stalls that will be fixed by forwarding)

  //input the alu output signals to the control unit, pipeline the funct3 and the instruction type,
  //then match the alu output signals to the funct3 condition and then stall and flush based on that

  wire ID_control_flow = (i_IF_ID_format == J_TYPE) | (i_c_is_jalr); // if jalr, then we know for sure that it's a control flow instruction, so we can use the control signal directly instead of checking the instruction type
  wire EX_control_flow = (i_ID_EX_format == J_TYPE) | (i_ID_EX_c_is_jalr) | (i_ID_EX_format == B_TYPE & Branch_taken); // same for EX stage
  wire load_to_use_stall = (i_ID_EX_format == I_TYPE) & (i_ID_EX_mem_read) //check if instruction in execute is a load
                          & ((i_ID_EX_write_reg == i_IF_ID_rs1) | (i_ID_EX_write_reg == i_IF_ID_rs2 & (i_IF_ID_format == R_TYPE | i_IF_ID_format == S_TYPE | i_IF_ID_format == B_TYPE)))
                          & (i_ID_EX_write_reg != 0)
                          & (i_IF_ID_format != 6'b111111);


  assign o_stall_IF = ((ID_control_flow | EX_control_flow) & (~o_stall_ID | Branch_taken)) | ~i_imem_valid; // can't nop decode for a decode stall
  assign o_stall_ID = load_to_use_stall | Branch_taken;
  assign o_stall_MEM = (i_EX_MEM_format == S_TYPE & ~i_dmem_ready) | (i_EX_MEM_format == I_TYPE & i_EX_MEM_c_mem_read & ~i_dmem_valid); // check if i_dmem_valid is low and if the EX_MEM instruction is a store or load, if so stall MEM stage until dmem is valid to prevent memory access until data is ready
  assign o_stall_pc = o_stall_IF | o_stall_ID | o_stall_MEM | Branch_taken; // if branch taken, need to stall pc to prevent wrong instruction fetch
endmodule

`default_nettype wire
