`default_nettype none

// The immediate generator is responsible for decoding the 32-bit sign-extended
// immediate from the incoming instruction word. It is a purely combinational
// block that is expected to be embedded in the instruction decoder.
module hazard_detector (
  input wire IF_ID_rs1,
  input wire IF_ID_rs2,
  input wire IF_ID_format,
  input wire ID_EX_format,
  input wire ID_EX_write_reg,
  input wire EX_MEM_write_reg,
);
  localparam R_TYPE = 6'b000001;
  localparam B_TYPE = 6'b001000;

  wire adjacent_hazard = (IF_ID_rs1 == ID_EX_write_reg) | ((IF_ID_rs2 == ID_EX_write_reg) & (IF_ID_format == R_TYPE));
  wire separated_hazard = (IF_ID_rs1 == EX_MEM_write_reg) | ((IF_ID_rs2 == EX_MEM_write_reg) & (IF_ID_format == R_TYPE));

  if (adjacent_hazard | separated_hazard | (ID_EX_format == B_TYPE)) begin
    // stall pc
    // insert nop -> IF/ID async reset
  end else if (IF_ID_format == B_TYPE) begin
    // stall pc
  end
endmodule

`default_nettype wire