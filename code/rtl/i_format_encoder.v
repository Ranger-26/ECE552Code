`default_nettype none

module i_format_encoder (
    input  wire [6:0] opcode,
    output wire [5:0] itype
);

    assign itype = (opcode == 7'b0110011) ? 6'b000001 : //R
                   ((opcode == 7'b0010011) | (opcode == 7'b0000011) | (opcode == 7'b0000011) | (opcode == 7'b1100111)) ? 6'b000010 : //I
                   (opcode == 7'b0100011) ? 6'b000100: //S
                   (opcode == 7'b1100011) ? 6'b001000: //B
                   (opcode == 7'b0110111) ? 6'b010000: //U
                   (opcode == 7'b1101111) ? 6'b100000://J
                   5'b11111; //invalid


endmodule

`default_nettype wire
