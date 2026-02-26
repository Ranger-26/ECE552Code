`default_nettype none

module dmem_wdata_aligner (
    input wire [3:0] mem_mask,
    input wire [31:0] mem_wdata,
    output wire [31:0] mem_wdata_aligned
);
    assign mem_wdata_aligned = (mem_mask == 4'b0001) ? {24'b0, mem_wdata[7:0]} :
        (mem_mask == 4'b0010) ? {16'b0, mem_wdata[15:8], 8'b0} :
        (mem_mask == 4'b0100) ? {8'b0, mem_wdata[23:16], 16'b0} :
        (mem_mask == 4'b1000) ? {mem_wdata[31:24], 24'b0} :
        (mem_mask == 4'b0011) ? {16'b0, mem_wdata[15:0]} :
        (mem_mask == 4'b1100) ? {mem_wdata[31:16], 16'b0} :
        mem_wdata[31:0];

endmodule

`default_nettype wire
