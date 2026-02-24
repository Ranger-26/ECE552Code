module fetch (
    input wire i_clk,
    input wire i_rst,
    input wire pcmod,
    input wire [31:0] branch_target_addr,
    input wire [31:0] jalr_target_addr,
    input wire is_jal_r,
    input wire halted,
    output wire [31:0] PC
);

reg [31:0] ProgramCounter;

always @(posedge i_clk, posedge i_rst) begin
    if (i_rst) begin
        ProgramCounter <= 32'b0;
    end else begin
        ProgramCounter <= halted ? ProgramCounter : (is_jal_r ? jalr_target_addr : (pcmod ? branch_target_addr : ProgramCounter + 4));
    end
end

assign PC = ProgramCounter;

endmodule

`default_nettype wire
