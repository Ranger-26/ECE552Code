`default_nettype none

// The immediate generator is responsible for decoding the 32-bit sign-extended
// immediate from the incoming instruction word. It is a purely combinational
// block that is expected to be embedded in the instruction decoder.
module hazard_detector (
  input wire [4:0] IF_ID_rs1,
  input wire [4:0] IF_ID_rs2,
  input wire [5:0] ID_format,
  input wire [5:0] EX_format,
  input wire [4:0] ID_EX_write_reg,
  input wire [4:0] EX_MEM_write_reg,
  input wire c_is_jalr,
  input wire ID_EX_c_is_jalr,
  output wire stall_pc,
  output wire flush_IF_ID
);
  localparam R_TYPE = 6'b000001;
  localparam B_TYPE = 6'b001000;
  localparam J_TYPE = 6'b100000;

  wire ID_control_flow = (ID_format == J_TYPE) | (ID_format == B_TYPE) | (c_is_jalr);
  wire EX_control_flow = (EX_format == J_TYPE) | (EX_format == B_TYPE) | (ID_EX_c_is_jalr);

  wire adjacent_hazard = (IF_ID_rs1 == ID_EX_write_reg) | ((IF_ID_rs2 == ID_EX_write_reg) & (ID_format == R_TYPE));
  wire separated_hazard = (IF_ID_rs1 == EX_MEM_write_reg) | ((IF_ID_rs2 == EX_MEM_write_reg) & (ID_format == R_TYPE));

  assign flush_IF_ID = (adjacent_hazard | separated_hazard | (EX_format == B_TYPE));
  assign stall_pc = flush_IF_ID | (ID_format == B_TYPE);
endmodule

`default_nettype wire