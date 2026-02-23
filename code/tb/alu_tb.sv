`timescale 1ns/1ps

module tb_alu_slt;

    // DUT signals
    logic [2:0]  i_opsel;
    logic        i_sub;
    logic        i_unsigned;
    logic        i_arith;
    logic [31:0] i_op1;
    logic [31:0] i_op2;
    wire  [31:0] o_result;
    wire         o_eq;
    wire         o_slt;

    // Instantiate DUT
    alu dut (
        .i_opsel    (i_opsel),
        .i_sub      (i_sub),
        .i_unsigned (i_unsigned),
        .i_arith    (i_arith),
        .i_op1      (i_op1),
        .i_op2      (i_op2),
        .o_result   (o_result),
        .o_eq       (o_eq),
        .o_slt      (o_slt)
    );

    task run_test(
        input int        testnum,
        input logic [2:0] opsel,
        input logic       sub,
        input logic       is_unsigned,
        input logic       arith,
        input logic [31:0] op1,
        input logic [31:0] op2,
        input logic [31:0] exp_result,
        input logic       exp_eq,
        input logic       exp_slt
    );
        begin
            i_opsel    = opsel;
            i_sub      = sub;
            i_unsigned = is_unsigned;
            i_arith    = arith;
            i_op1      = op1;
            i_op2      = op2;

            #1;

            if (o_result !== exp_result || o_eq !== exp_eq || o_slt !== exp_slt) begin
                $display("[FAIL] Test %0d: opsel=%b, sub=%0d, is_unsigned=%0d, arith=%0d, op1=%h, op2=%h",
                         testnum, opsel, sub, is_unsigned, arith, op1, op2);
                if (o_result !== exp_result)
                    $display("       Result mismatch: got %h, expected %h",
                             o_result, exp_result);
                if (o_eq !== exp_eq)
                    $display("       EQ mismatch: got %0d, expected %0d",
                             o_eq, exp_eq);
                if (o_slt !== exp_slt)
                    $display("       SLT mismatch: got %0d, expected %0d",
                             o_slt, exp_slt);
            end else begin
                $display("[PASS] Test %0d: opsel=%b, sub=%0d, is_unsigned=%0d, arith=%0d, op1=%h, op2=%h -> result=%h, eq=%0d, slt=%0d",
                         testnum, opsel, sub, is_unsigned, arith, op1, op2,
                         o_result, o_eq, o_slt);
            end
        end
    endtask

    initial begin
        // ---------- opsel = 010 ----------
        run_test(31, 3'b010, 0, 0, 0, 32'h00000000, 32'h00000000, 32'h00000000, 1, 0);
        run_test(32, 3'b010, 0, 0, 0, 32'h00000001, 32'h00000002, 32'h00000001, 0, 1);
        run_test(33, 3'b010, 0, 0, 0, 32'h00000002, 32'h00000001, 32'h00000000, 0, 0);
        run_test(34, 3'b010, 0, 0, 0, 32'hfffffffe, 32'hffffffff, 32'h00000001, 0, 1);
        run_test(35, 3'b010, 0, 0, 0, 32'hffffffff, 32'hfffffffe, 32'h00000000, 0, 0);
        run_test(36, 3'b010, 0, 0, 0, 32'hffffffff, 32'h00000001, 32'h00000001, 0, 1);
        run_test(37, 3'b010, 0, 0, 0, 32'h00000001, 32'hffffffff, 32'h00000000, 0, 0);

        // ---------- opsel = 011 ----------
        run_test(38, 3'b011, 0, 0, 0, 32'h00000000, 32'h00000000, 32'h00000000, 1, 0);
        run_test(39, 3'b011, 0, 0, 0, 32'h00000001, 32'h00000002, 32'h00000001, 0, 1);
        run_test(40, 3'b011, 0, 0, 0, 32'h00000002, 32'h00000001, 32'h00000000, 0, 0);
        run_test(41, 3'b011, 0, 0, 0, 32'hfffffffe, 32'hffffffff, 32'h00000001, 0, 1);
        run_test(42, 3'b011, 0, 0, 0, 32'hffffffff, 32'hfffffffe, 32'h00000000, 0, 0);
        run_test(43, 3'b011, 0, 0, 0, 32'hffffffff, 32'h00000001, 32'h00000001, 0, 1);
        run_test(44, 3'b011, 0, 0, 0, 32'h00000001, 32'hffffffff, 32'h00000000, 0, 0);

        $display("All tests completed.");
        $stop;
    end

endmodule

module tb_alu_slt_unsigned;

    logic [2:0]  i_opsel;
    logic        i_sub;
    logic        i_unsigned;
    logic        i_arith;
    logic [31:0] i_op1;
    logic [31:0] i_op2;
    wire  [31:0] o_result;
    wire         o_eq;
    wire         o_slt;

    alu dut (
        .i_opsel    (i_opsel),
        .i_sub      (i_sub),
        .i_unsigned (i_unsigned),
        .i_arith    (i_arith),
        .i_op1      (i_op1),
        .i_op2      (i_op2),
        .o_result   (o_result),
        .o_eq       (o_eq),
        .o_slt      (o_slt)
    );

    task run_test(
        input int        testnum,
        input logic [2:0] opsel,
        input logic [31:0] op1,
        input logic [31:0] op2,
        input logic [31:0] exp_result,
        input logic       exp_eq,
        input logic       exp_slt
    );
        begin
            i_opsel    = opsel;
            i_sub      = 0;
            i_unsigned = 1;
            i_arith    = 0;
            i_op1      = op1;
            i_op2      = op2;

            #1;

            if (o_result !== exp_result || o_eq !== exp_eq || o_slt !== exp_slt) begin
                $display("[FAIL] Test %0d: opsel=%b, unsigned=1, op1=%h, op2=%h",
                         testnum, opsel, op1, op2);
                if (o_result !== exp_result)
                    $display("       Result mismatch: got %h, expected %h",
                             o_result, exp_result);
                if (o_eq !== exp_eq)
                    $display("       EQ mismatch: got %0d, expected %0d",
                             o_eq, exp_eq);
                if (o_slt !== exp_slt)
                    $display("       SLT mismatch: got %0d, expected %0d",
                             o_slt, exp_slt);
            end else begin
                $display("[PASS] Test %0d: opsel=%b, op1=%h, op2=%h -> result=%h, eq=%0d, slt=%0d",
                         testnum, opsel, op1, op2, o_result, o_eq, o_slt);
            end
        end
    endtask

    initial begin
        // ---------- Basic ----------
        run_test(0,  3'b010, 32'h00000000, 32'h00000000, 32'h0, 1, 0);
        run_test(1,  3'b010, 32'h00000000, 32'h00000000, 32'h0, 1, 0);
        run_test(2,  3'b010, 32'h00000001, 32'h00000002, 32'h1, 0, 1);
        run_test(3,  3'b010, 32'h00000002, 32'h00000001, 32'h0, 0, 0);

        // ---------- MSB-heavy (key unsigned cases) ----------
        run_test(4,  3'b010, 32'hffffffff, 32'h00000001, 32'h0, 0, 0); // max < 1 false
        run_test(5,  3'b010, 32'h00000001, 32'hffffffff, 32'h1, 0, 1); // 1 < max true
        run_test(6,  3'b010, 32'h80000000, 32'h7fffffff, 32'h0, 0, 0);
        run_test(7,  3'b010, 32'h7fffffff, 32'h80000000, 32'h1, 0, 1);

        // ---------- Edge values ----------
        run_test(8,  3'b010, 32'hffffffff, 32'hffffffff, 32'h0, 1, 0);
        run_test(9,  3'b010, 32'h00000000, 32'hffffffff, 32'h1, 0, 1);
        run_test(10, 3'b010, 32'hffffffff, 32'h00000000, 32'h0, 0, 0);

        // ---------- Near-boundary ----------
        run_test(11, 3'b010, 32'hfffffffe, 32'hffffffff, 32'h1, 0, 1);
        run_test(12, 3'b010, 32'hffffffff, 32'hfffffffe, 32'h0, 0, 0);

        // ---------- Random-ish ----------
        run_test(13, 3'b010, 32'h12345678, 32'h9abcdef0, 32'h1, 0, 1);
        run_test(14, 3'b010, 32'h9abcdef0, 32'h12345678, 32'h0, 0, 0);

        // ---------- Same tests, opsel = 011 ----------
        run_test(15, 3'b011, 32'h00000001, 32'hffffffff, 32'h1, 0, 1);
        run_test(16, 3'b011, 32'hffffffff, 32'h00000001, 32'h0, 0, 0);
        run_test(17, 3'b011, 32'h80000000, 32'h00000000, 32'h0, 0, 0);
        run_test(18, 3'b011, 32'h00000000, 32'h80000000, 32'h1, 0, 1);

        $display("Unsigned SLT tests complete.");
        $finish;
    end

endmodule

`timescale 1ns/1ps

`timescale 1ns/1ps

module shifter_tb;

    reg  [31:0] i_op;
    reg  [4:0]  shamt;
    reg         left;
    reg         arith;

    wire [31:0] shifted_value;

    // Instantiate DUT
    shiffter dut (
        .i_op(i_op),
        .shamt(shamt),
        .left(left),
        .arith(arith),
        .shifted_value(shifted_value)
    );

    reg [31:0] expected;
    integer errors = 0;

    task run_test;
        begin
            #1; // allow combinational logic to settle

            if (shifted_value !== expected) begin
                $display("FAIL: i_op=%h shamt=%0d | got=%h expected=%h",
                         i_op, shamt, shifted_value, expected);
                errors = errors + 1;
            end else begin
                $display("PASS: i_op=%h shamt=%0d | result=%h",
                         i_op, shamt, shifted_value);
            end
        end
    endtask


    initial begin
        $display("Starting LEFT SHIFT Tests...");
        
        left  = 1;
        arith = 0;   // irrelevant for left shift

        // Basic tests
        i_op = 32'h00000001; shamt = 1;
        expected = i_op << shamt;
        run_test();

        i_op = 32'h00000001; shamt = 8;
        expected = i_op << shamt;
        run_test();

        i_op = 32'h0000FFFF; shamt = 4;
        expected = i_op << shamt;
        run_test();

        // Edge cases
        i_op = 32'h12345678; shamt = 0;
        expected = i_op;
        run_test();

        i_op = 32'hFFFFFFFF; shamt = 31;
        expected = i_op << shamt;
        run_test();

        i_op = 32'h80000000; shamt = 1;
        expected = i_op << shamt;
        run_test();

        // Random tests
        repeat (20) begin
            i_op  = $random;
            shamt = $random % 32;
            expected = i_op << shamt;
            run_test();
        end

        if (errors == 0)
            $display("ALL LEFT SHIFT TESTS PASSED ✅");
        else
            $display("LEFT SHIFT TESTS FAILED ❌ Errors = %0d", errors);

        $finish;
    end

endmodule

`timescale 1ns/1ps

module alu_sll_tb;

    reg  [2:0]  i_opsel;
    reg         i_sub;
    reg         i_unsigned;
    reg         i_arith;
    reg  [31:0] i_op1;
    reg  [31:0] i_op2;

    wire [31:0] o_result;
    wire        o_eq;
    wire        o_slt;

    // Instantiate DUT
    alu dut (
        .i_opsel(i_opsel),
        .i_sub(i_sub),
        .i_unsigned(i_unsigned),
        .i_arith(i_arith),
        .i_op1(i_op1),
        .i_op2(i_op2),
        .o_result(o_result),
        .o_eq(o_eq),
        .o_slt(o_slt)
    );

    reg [31:0] expected;
    integer errors = 0;

    task run_test;
        begin
            #1; // allow combinational settle

            if (o_result !== expected) begin
                $display("FAIL: op1=%h shamt=%0d | got=%h expected=%h",
                         i_op1, i_op2[4:0], o_result, expected);
                errors = errors + 1;
            end else begin
                $display("PASS: op1=%h shamt=%0d | result=%h",
                         i_op1, i_op2[4:0], o_result);
            end
        end
    endtask


    initial begin
        $display("Starting ALU Shift-Left Tests...");

        // Select Shift Left Logical
        i_opsel    = 3'b001;
        i_sub      = 0;
        i_unsigned = 0;
        i_arith    = 0;

        // -----------------------------
        // Basic tests
        // -----------------------------
        i_op1 = 32'h00000001; i_op2 = 32'd1;
        expected = i_op1 << i_op2[4:0];
        run_test();

        i_op1 = 32'h00000001; i_op2 = 32'd8;
        expected = i_op1 << i_op2[4:0];
        run_test();

        i_op1 = 32'h0000FFFF; i_op2 = 32'd4;
        expected = i_op1 << i_op2[4:0];
        run_test();

        // -----------------------------
        // Edge cases
        // -----------------------------
        i_op1 = 32'h12345678; i_op2 = 32'd0;
        expected = i_op1;
        run_test();

        i_op1 = 32'hFFFFFFFF; i_op2 = 32'd31;
        expected = i_op1 << 31;
        run_test();

        i_op1 = 32'h80000000; i_op2 = 32'd1;
        expected = i_op1 << 1;
        run_test();

        // -----------------------------
        // Random tests
        // -----------------------------
        repeat (25) begin
            i_op1 = $random;
            i_op2 = $random;
            expected = i_op1 << i_op2[4:0];
            run_test();
        end

        if (errors == 0)
            $display("ALL SLL TESTS PASSED ✅");
        else
            $display("SLL TESTS FAILED ❌ Errors = %0d", errors);

        $finish;
    end

endmodule

`timescale 1ns/1ps

module alu_shift_right_tb;

    reg  [2:0]  i_opsel;
    reg         i_sub;
    reg         i_unsigned;
    reg         i_arith;
    reg  [31:0] i_op1;
    reg  [31:0] i_op2;

    wire [31:0] o_result;
    wire        o_eq;
    wire        o_slt;

    // Instantiate DUT
    alu dut (
        .i_opsel(i_opsel),
        .i_sub(i_sub),
        .i_unsigned(i_unsigned),
        .i_arith(i_arith),
        .i_op1(i_op1),
        .i_op2(i_op2),
        .o_result(o_result),
        .o_eq(o_eq),
        .o_slt(o_slt)
    );

    reg [31:0] expected;
    integer errors = 0;

    task run_test;
        begin
            #1; // combinational settle

            if (o_result !== expected) begin
                $display("FAIL: op1=%h shamt=%0d arith=%b | got=%h expected=%h",
                         i_op1, i_op2[4:0], i_arith, o_result, expected);
                errors = errors + 1;
            end
            else begin
                $display("PASS: op1=%h shamt=%0d arith=%b | result=%h",
                         i_op1, i_op2[4:0], i_arith, o_result);
            end
        end
    endtask


    initial begin
        $display("Starting ALU Shift-Right Tests...");

        // Select shift right operation
        i_opsel    = 3'b101;
        i_sub      = 0;
        i_unsigned = 0;

        // =====================================================
        // LOGICAL RIGHT SHIFT (SRL)
        // =====================================================
        i_arith = 0;

        i_op1 = 32'h80000000; i_op2 = 1;
        expected = i_op1 >> i_op2[4:0];
        run_test();

        i_op1 = 32'hF0000000; i_op2 = 4;
        expected = i_op1 >> 4;
        run_test();

        i_op1 = 32'h12345678; i_op2 = 0;
        expected = i_op1;
        run_test();

        i_op1 = 32'hFFFFFFFF; i_op2 = 31;
        expected = i_op1 >> 31;
        run_test();


        // =====================================================
        // ARITHMETIC RIGHT SHIFT (SRA)
        // =====================================================
        i_arith = 1;

        i_op1 = 32'h80000000; i_op2 = 1;
        expected = $signed(i_op1) >>> 1;
        run_test();

        i_op1 = 32'hF0000000; i_op2 = 4;
        expected = $signed(i_op1) >>> 4;
        run_test();

        i_op1 = 32'h7FFFFFFF; i_op2 = 4;
        expected = $signed(i_op1) >>> 4;
        run_test();

        i_op1 = 32'h80000000; i_op2 = 31;
        expected = $signed(i_op1) >>> 31;
        run_test();


        // =====================================================
        // RANDOM TESTING
        // =====================================================
        repeat (30) begin
            i_op1 = $random;
            i_op2 = $random;

            // Test logical
            i_arith = 0;
            expected = i_op1 >> i_op2[4:0];
            run_test();

            // Test arithmetic
            i_arith = 1;
            expected = $signed(i_op1) >>> i_op2[4:0];
            run_test();
        end


        if (errors == 0)
            $display("ALL SHIFT-RIGHT TESTS PASSED ✅");
        else
            $display("SHIFT-RIGHT TESTS FAILED ❌ Errors = %0d", errors);

        $finish;
    end

endmodule