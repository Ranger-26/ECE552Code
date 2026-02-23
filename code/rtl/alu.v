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
    // 3'b011: set less than/un signed if `i_unsigned` asserted
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

    wire [31:0] unsignedOp1;
    wire [31:0] unsignedOp2;

    wire [31:0] addition;
    wire [31:0] subtraction;
    wire [31:0] shiftLeftLogical;
    wire [31:0] exclusiveOr;
    wire [31:0] shiftRightLogical;
    wire [31:0] orResult;
    wire [31:0] andResult;

    wire [31:0] unsignedLessThan;
    wire [31:0] signedLessThan;
    wire [31:0] unsignedDifference;
    wire [31:0] unsignedSum;

    wire overflowOccured;
    

    assign addition = i_op1 + i_op2;
    assign subtraction = i_op1 + (~(i_op2) + 1);
    assign exclusiveOr = i_op1 ^ i_op2;
    assign orResult = i_op1 | i_op2;
    assign andResult = i_op1 & i_op2;
    assign overflowOccured = (i_op1[31] == 0 && i_op2[31] == 1) && (subtraction[31] != 0) || (i_op1[31] == 1 && i_op2[31] == 0) && (subtraction[31] != 1);

    assign signedLessThan = overflowOccured ? (i_op1[31] == 1 ? 1 : 0) : (subtraction[31]);
    assign unsignedLessThan = (i_op1 < i_op2);

    shiffter shiftLeftLogicalUnit (
        .i_op(i_op1),
        .shamt(i_op2[4:0]),
        .left(1'b1),
        .arith(1'b0),
        .shifted_value(shiftLeftLogical)
    );

    shiffter shiftRightLogicalUnit (
        .i_op(i_op1),
        .shamt(i_op2[4:0]),
        .left(1'b0),
        .arith(i_arith),
        .shifted_value(shiftRightLogical)
    );

    assign o_result = (i_opsel == 3'b000) ? (i_sub ? subtraction : addition):
                      (i_opsel == 3'b010) ? (i_unsigned ? unsignedLessThan : signedLessThan) :
                      (i_opsel == 3'b011) ? (i_unsigned ? unsignedLessThan : signedLessThan) :
                      (i_opsel == 3'b001) ? shiftLeftLogical:
                      (i_opsel == 3'b100) ? exclusiveOr:
                      (i_opsel == 3'b101) ? shiftRightLogical:
                      (i_opsel == 3'b110) ? orResult:
                      (i_opsel == 3'b111) ? andResult:
                      0;

    assign o_eq = (subtraction == 0);
    
    assign o_slt = i_unsigned ? unsignedLessThan : signedLessThan;




endmodule

`default_nettype wire
