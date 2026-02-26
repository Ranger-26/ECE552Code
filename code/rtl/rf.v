`default_nettype none

// The register file is effectively a single cycle memory with 32-bit words
// and depth 32. It has two asynchronous read ports, allowing two independent
// registers to be read at the same time combinationally, and one synchronous
// write port, allowing a register to be written to on the next clock edge.
// The register `x0` is hardwired to zero, and writes to it are ignored.
module rf #(
    // When this parameter is set to 1, "RF bypass" mode is enabled. This
    // allows data at the write port to be observed at the read ports
    // immediately without having to wait for the next clock edge. This is
    // a common forwarding optimization in a pipelined core (project 5), but
    // will cause a single-cycle processor to behave incorrectly.
    //
    // You are required to implement and test both modes. In project 3 and 4,
    // you will set this to 0, before enabling it in project 5.
    parameter BYPASS_EN = 0
) (
    // Global clock.
    input  wire        i_clk,
    // Synchronous active-high reset.
    input  wire        i_rst,
    // Both read register ports are asynchronous (zero-cycle). That is, read
    // data is visible combinationally without having to wait for a clock.
    //
    // Register read port 1, with input address [0, 31] and output data.
    input  wire [ 4:0] i_rs1_raddr,
    output wire [31:0] o_rs1_rdata,
    // Register read port 2, with input address [0, 31] and output data.
    input  wire [ 4:0] i_rs2_raddr,
    output wire [31:0] o_rs2_rdata,
    // The register write port is synchronous. When write is enabled, the
    // write data is visible after the next clock edge.
    //
    // Write register enable, address [0, 31] and input data.
    input  wire        i_rd_wen,
    input  wire [ 4:0] i_rd_waddr,
    input  wire [31:0] i_rd_wdata
);
    // TODO: Fill in your implementation here.
    reg [31:0] memory [31:0];
    reg wen;

    integer i;
    generate 
        if (BYPASS_EN == 1) begin : gen_logic_1
            assign o_rs1_rdata = ((i_rd_waddr == i_rs1_raddr) & i_rd_wen & (i_rd_waddr != 0)) ? i_rd_wdata : memory[i_rs1_raddr];
            assign o_rs2_rdata = ((i_rd_waddr == i_rs2_raddr) & i_rd_wen & (i_rd_waddr != 0)) ? i_rd_wdata : memory[i_rs2_raddr];
        end else begin : gen_logic_2
            assign o_rs1_rdata = memory[i_rs1_raddr];
            assign o_rs2_rdata = memory[i_rs2_raddr];
        end
    endgenerate
    

    always @(posedge i_clk) begin
        if (i_rst) begin
            memory[0] <= 0;
            memory[1] <= 0;
            memory[2] <= 0;
            memory[3] <= 0;
            memory[4] <= 0;
            memory[5] <= 0;
            memory[6] <= 0;
            //fill in the rest of the registers with 0 no loop
            memory[7] <= 0;
            memory[8] <= 0;
            memory[9] <= 0;
            memory[10] <= 0;
            memory[11] <= 0;
            memory[12] <= 0;
            memory[13] <= 0;
            memory[14] <= 0;
            memory[15] <= 0;
            memory[16] <= 0;
            memory[17] <= 0;
            memory[18] <= 0;
            memory[19] <= 0;
            memory[20] <= 0;
            memory[21] <= 0;
            memory[22] <= 0;
            memory[23] <= 0;
            memory[24] <= 0;
            memory[25] <= 0;
            memory[26] <= 0;
            memory[27] <= 0;
            memory[28] <= 0;
            memory[29] <= 0;
            memory[30] <= 0;
            memory[31] <= 0;
        end else begin
            wen <= i_rd_wen;
            
            if (wen) begin
                if (i_rd_waddr != 0) begin
                    memory[i_rd_waddr] <= i_rd_wdata;
                end
            end
        end
    end
endmodule

`default_nettype wire
