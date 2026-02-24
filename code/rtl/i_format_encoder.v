`default_nettype none

module i_format_encoder (
    input  wire [6:0] opcode,
    output wire [4:0] itype
);

    assign itype = (opcode == 7'b0110011) ? 0 : //R
                   (opcode == 7'b0010011 || opcode == 7'b0000011 || opcode == 7'b0000011 || opcode == 7'b1100111) ? 1 : //I
                   (opcode == 7'b0100011) ? 2: //S
                   (opcode == 7'b1100011) ? 4: //B
                   (opcode == 7'b0110111) ? 8: //U
                   (opcode == 7'b1101111) ? 16://J
                   5'b11111; //invalid


endmodule

`default_nettype wire
