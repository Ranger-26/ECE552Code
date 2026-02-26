`default_nettype none

module dmem_rdata_aligner (
    input wire [3:0] mem_mask,
    input wire [31:0] mem_rdata,
    input wire i_unsigned,
    output wire [31:0] mem_rdata_aligned
);
    assign mem_rdata_aligned = (mem_mask == 4'b0001) ? {i_unsigned ? 24'b0 : {24{mem_rdata[7]}}, mem_rdata[7:0]} :
        (mem_mask == 4'b0010) ? {i_unsigned ? 24'b0 : {24{mem_rdata[15]}}, mem_rdata[15:8]} :
        (mem_mask == 4'b0100) ? {i_unsigned ? 24'b0 : {24{mem_rdata[23]}}, mem_rdata[23:16]} :
        (mem_mask == 4'b1000) ? {i_unsigned ? 24'b0 : {24{mem_rdata[31]}}, mem_rdata[31:24]} :
        (mem_mask == 4'b0011) ? {i_unsigned ? 16'b0 : {16{mem_rdata[15]}}, mem_rdata[15:0]} :
        (mem_mask == 4'b1100) ? {i_unsigned ? 16'b0 : {16{mem_rdata[31]}}, mem_rdata[31:16]} :
        mem_rdata[31:0];

endmodule

`default_nettype wire
