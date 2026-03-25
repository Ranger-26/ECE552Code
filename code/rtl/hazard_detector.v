`default_nettype none

// The immediate generator is responsible for decoding the 32-bit sign-extended
// immediate from the incoming instruction word. It is a purely combinational
// block that is expected to be embedded in the instruction decoder.
module hazard_detector (
  input wire [4:0] IF_ID_rs1,
  input wire [4:0] IF_ID_rs2,
  input wire [5:0] IF_ID_format,
  input wire [5:0] ID_EX_format,
  input wire [4:0] ID_EX_write_reg,
  input wire [4:0] EX_MEM_write_reg,
  input wire ID_EX_mem_read,
  input wire c_is_jalr,
  input wire i_o_eq,
  input wire i_o_slt,
  input wire EX_MEM_c_unsigned,
  input wire [2:0] ID_EX_funct3,
  input wire ID_EX_c_is_jalr,
  output wire stall_pc,
  output wire stall_IF,
  output wire stall_ID
);
  localparam J_TYPE = 6'b100000;
  localparam B_TYPE = 6'b001000;
  localparam S_TYPE = 6'b000100;
  localparam R_TYPE = 6'b000001;
  localparam I_TYPE = 6'b000010;


  //detect load to use stalls and branch/jump stalls(need to remove stalls that will be fixed by forwarding)

  //input the alu output signals to the control unit, pipeline the funct3 and the instruction type,
  //then match the alu output signals to the funct3 condition and then stall and flush based on that

  wire ID_control_flow = (IF_ID_format == J_TYPE) | (c_is_jalr); // if jalr, then we know for sure that it's a control flow instruction, so we can use the control signal directly instead of checking the instruction type
  wire EX_control_flow = (ID_EX_format == J_TYPE) | (ID_EX_c_is_jalr) | (ID_EX_format == B_TYPE); // same for EX stage
  wire load_to_use_stall = (ID_EX_format == I_TYPE) & (ID_EX_mem_read) //check if instruction in execute is a load
                          & (ID_EX_write_reg == IF_ID_rs1 || ID_EX_write_reg == IF_ID_rs2)
                          & (ID_EX_write_reg != 0);
  //TODO: implement check for load to use stall
  
  wire Branch_taken = (ID_EX_format == B_TYPE) &
    (ID_EX_funct3[0] ^ (ID_EX_funct3[2] ? i_o_slt : i_o_eq)); // same convenient logic as control unit for branch conditions


  assign stall_IF = (ID_control_flow | EX_control_flow) & (~stall_ID | Branch_taken); // can't nop decode for a decode stall
  assign stall_ID = load_to_use_stall | Branch_taken;
  assign stall_pc = stall_IF | stall_ID | Branch_taken; // if branch taken, need to stall pc to prevent wrong instruction fetch
endmodule

`default_nettype wire