module forwarding_unit (
  //ex to ex forwarding
  input wire [4:0] ID_EX_rs1,
  input wire [4:0] ID_EX_rs2,
  input wire [4:0] EX_MEM_write_reg,
  input wire EX_MEM_wen,
  
  //mem to ex forwarding
  input wire [4:0] MEM_WB_write_reg,
  input wire MEM_WB_wen,

  input wire [5:0] format,

  output wire [1:0] forward_A,
  output wire [1:0] forward_B

);

  // 00 = No Forwarding, 01 = EX-to-EX Forwarding, 10 = MEM-to-EX Forwarding

  // ALU Input 1
  assign forward_A = (EX_MEM_wen & (EX_MEM_write_reg != 0) & (EX_MEM_write_reg == ID_EX_rs1)) ? 2'b01 : // EX-to-EX Forwarding
                     (MEM_WB_wen & (MEM_WB_write_reg != 0) & (MEM_WB_write_reg == ID_EX_rs1)) ? 2'b10 : // MEM-to-EX Forwarding
                     2'b00; // No Forwarding

  // ALU Input 2
  wire inst_contains_rs2 = (format == 6'b000001) | (format == 6'b000100) | (format == 6'b001000); // Only do forwarding for rs2 if instruction format is R, S, or B (any format that contains rs2)

  assign forward_B = (EX_MEM_wen & (EX_MEM_write_reg != 0) & (EX_MEM_write_reg == ID_EX_rs2) & inst_contains_rs2) ? 2'b01 : // EX-to-EX Forwarding
                     (MEM_WB_wen & (MEM_WB_write_reg != 0) & (MEM_WB_write_reg == ID_EX_rs2) & inst_contains_rs2) ? 2'b10 : // MEM-to-EX Forwarding
                     2'b00; // No Forwarding
                     
endmodule