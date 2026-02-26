`default_nettype none

// The arithmetic logic unit (ALU) is responsible for performing the core
// calculations of the processor. It takes two 32-bit operands and outputs
// a 32 bit result based on the selection operation - addition, comparison,
// shift, or logical operation. This ALU is a purely combinational block, so
// you should not attempt to add any registers or pipeline it.
module alu (
  // NOTE: Both 3'b010 and 3'b011 are used for set less than operations and
  // your implementation should output the same result for both codes. The
  // reason for this will become clear in project 3.
  //
  // Major operation selection.
  // 3'b000: addition/subtraction if `i_sub` asserted
  // 3'b001: shift left logical
  // 3'b010,
  // 3'b011: set less than/unsigned if `i_unsigned` asserted
  // 3'b100: exclusive or
  // 3'b101: shift right logical/arithmetic if `i_arith` asserted
  // 3'b110: or
  // 3'b111: and
  input  wire [ 2:0] i_opsel,
  // When asserted, addition operations should subtract instead.
  // This is only used for `i_opsel == 3'b000` (addition/subtraction).
  input  wire        i_sub,
  // When asserted, comparison operations should be treated as unsigned.
  // This is used for branch comparisons and set less than unsigned. For
  // b ranch operations, the ALU result is not used, only the comparison
  // results.
  input  wire        i_unsigned,
  // When asserted, right shifts should be treated as arithmetic instead of
  // logical. This is only used for `i_opsel == 3'b101` (shift right).
  input  wire        i_arith,
  // First 32-bit input operand.
  input  wire [31:0] i_op1,
  // Second 32-bit input operand.
  input  wire [31:0] i_op2,
  // 32-bit output result. Any carry out should be ignored.
  output wire [31:0] o_result,
  // Equality result. This is used externally to determine if a branch
  // should be taken.
  output wire        o_eq,
  // Set less than result. This is used externally to determine if a branch
  // should be taken.
  output wire        o_slt
);
  wire [31:0] sum;
  wire [31:0] shift_res, shift_1, shift_2, shift_3, shift_4;
  wire shift_fill, shift_right;

  assign sum = i_sub ? i_op1 - i_op2 : i_op1 + i_op2;

  // Barrel shift for each possible shift type
  assign shift_right = i_opsel == 3'b101; // 0 left, 1 right
  assign shift_fill = i_arith & i_op1[31];
  assign shift_1 = i_op2[0] ? (shift_right ? {shift_fill, i_op1[31:1]} : i_op1 << 1) : i_op1;
  assign shift_2 = i_op2[1] ? (shift_right ? {{2{shift_fill}}, shift_1[31:2]} : shift_1 << 2) : shift_1;
  assign shift_3 = i_op2[2] ? (shift_right ? {{4{shift_fill}}, shift_2[31:4]} : shift_2 << 4) : shift_2;
  assign shift_4 = i_op2[3] ? (shift_right ? {{8{shift_fill}}, shift_3[31:8]} : shift_3 << 8) : shift_3;
  assign shift_res = i_op2[4] ? (shift_right ? {{16{shift_fill}}, shift_4[31:16]} : shift_4 << 16) : shift_4;

  assign o_eq = i_op1 == i_op2;
  assign o_slt = (i_unsigned | (i_op1[31] ~^ i_op2[31])) ? (i_op1 < i_op2) : (i_op1[31]);
  assign o_result =
      (i_opsel == 3'b000) ? sum :
      ((i_opsel == 3'b001) | shift_right) ? shift_res :
      ((i_opsel == 3'b010) | (i_opsel == 3'b011)) ? {31'b0, o_slt} :
      (i_opsel == 3'b100) ? (i_op1 ^ i_op2) :
      (i_opsel == 3'b110) ? (i_op1 | i_op2) :
      (i_opsel == 3'b111) ? (i_op1 & i_op2) :
      32'b0; // should be unreachable -> removed from synthesis
endmodule

`default_nettype wire
