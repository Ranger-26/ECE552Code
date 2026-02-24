`default_nettype none

module mem_mask (
    input  wire [1:0] mem_size,
    input  wire [1:0] mem_addr_lsb,
    output wire [3:0] mem_mask
);
    wire [3:0] byte_mask = (mem_addr_lsb == 2'b00) ? 4'b0001 :
        (mem_addr_lsb == 2'b01) ? 4'b0010 :
        (mem_addr_lsb == 2'b10) ? 4'b0100 :
        4'b1000;

    // Coerces invalid address alignments, but does not ignore invalid mem_size:
    // mem_size: 00 = byte, 01 = halfword, 10 = word
    assign mem_mask = (mem_size == 2'b10) ? 4'b1111 :
        (mem_size == 2'b01) ? (mem_addr_lsb[1] ? 4'b1100 : 4'b0011) :
        (mem_size == 2'b00) ? byte_mask :
        4'b0000; // invalid mem_size -> invalid mask

endmodule

`default_nettype wire
