module forwarding_unit (
  //ex to ex forwarding
  input wire [4:0] ID_EX_rs1,
  input wire [4:0] ID_EX_rs2,
  input wire [4:0] EX_MEM_write_reg,
  input wire EX_MEM_wen,
  
  //mem to ex forwarding
  input wire [4:0] MEM_WB_write_reg,
  input wire MEM_WB_wen,

  output wire [1:0] forward_A,
  output wire [1:0] forward_B

);
    //For ex to ex forwarding, we need id_ex_rs1, id_ex_rs2, and ex_mem_write_reg to do out comparisons, also need to check if ex_mem_wen == 1 and that registers arent 0
    //for mem to ex forwarding, we need id_ex_rs1, id_ex_rs2, and mem_wb_write_reg, also need to check is mem_wb_wen is 1 and that registers arent 0
    //for load to use stall, we need to check if the  id_ex_format is a load and if if_id_rs1 or if_id_rs2 is equal to the load register in execute 

    //load word and store word combo stall???
endmodule