`default_nettype none

module cache (
  // Global clock.
  input  wire        i_clk,
  // Synchronous active-high reset.
  input  wire        i_rst,
  // External memory interface. See hart interface for details. This
  // interface is nearly identical to the phase 5 memory interface, with the
  // exception that the byte mask (`o_mem_mask`) has been removed. This is
  // no longer needed as the cache will only access the memory at word
  // granularity, and implement masking internally.
  input  wire        i_mem_ready,
  output wire [31:0] o_mem_addr,
  output wire        o_mem_ren,
  output wire        o_mem_wen,
  output wire [31:0] o_mem_wdata,
  input  wire [31:0] i_mem_rdata,
  input  wire        i_mem_valid,
  // Interface to CPU hart. This is nearly identical to the phase 5 hart memory
  // interface, but includes a stall signal (`o_busy`), and the input/output
  // polarities are swapped for obvious reasons.
  //
  // The CPU should use this as a stall signal for both instruction fetch
  // (IF) and memory (MEM) stages, from the instruction or data cache
  // respectively. If a memory request is made (`i_req_ren` for instruction
  // cache, or either `i_req_ren` or `i_req_wen` for data cache), this
  // should be asserted *combinationally* if the request results in a cache
  // miss.
  //
  // In case of a cache miss, the CPU must stall the respective pipeline
  // stage and deassert ren/wen on subsequent cycles, until the cache
  // deasserts `o_busy` to indicate it has serviced the cache miss. However,
  // the CPU must keep the other request lines constant. For example, the
  // CPU should not change the request address while stalling.
  output wire        o_busy,
  // 32-bit read/write address to access from the cache. This should be
  // 32-bit aligned (i.e. the two LSBs should be zero). See `i_req_mask` for
  // how to perform half-word and byte accesses to unaligned addresses.
  input  wire [31:0] i_req_addr,
  // When asserted, the cache should perform a read at the aligned address
  // specified by `i_req_addr` and return the 32-bit word at that address,
  // either immediately (i.e. combinationally) on a cache hit, or
  // synchronously on a cache miss. It is illegal to assert this and
  // `i_dmem_wen` on the same cycle.
  input  wire        i_req_ren,
  // When asserted, the cache should perform a write at the aligned address
  // specified by `i_req_addr` with the 32-bit word provided in
  // `o_req_wdata` (specified by the mask). This is necessarily synchronous,
  // but may either happen on the next clock edge (on a cache hit) or after
  // multiple cycles of latency (cache miss). As the cache is write-through
  // and write-allocate, writes must be applied to both the cache and
  // underlying memory.
  // It is illegal to assert this and `i_dmem_ren` on the same cycle.
  input  wire        i_req_wen,
  // The memory interface expects word (32 bit) aligned addresses. However,
  // WISC-25 supports byte and half-word loads and stores at unaligned and
  // 16-bit aligned addresses, respectively. To support this, the access
  // mask specifies which bytes within the 32-bit word are actually read
  // from or written to memory.
  input  wire [ 3:0] i_req_mask,
  // The 32-bit word to write to memory, if the request is a write
  // (i_req_wen is asserted). Only the bytes corresponding to set bits in
  // the mask should be written into the cache (and to backing memory).
  input  wire [31:0] i_req_wdata,
  // THe 32-bit data word read from memory on a read request.
  output wire [31:0] o_res_rdata
);
  // These parameters are equivalent to those provided in the project
  // 6 specification. Feel free to use them, but hardcoding these numbers
  // rather than using the localparams is also permitted, as long as the
  // same values are used (and consistent with the project specification).
  //
  // 32 sets * 2 ways per set * 16 bytes per way = 1K cache
  localparam O = 4;            // 4 bit offset => 16 byte cache line
  localparam S = 5;            // 5 bit set index => 32 sets
  localparam DEPTH = 32;   // 32 sets
  localparam W = 2;            // 2 way set associative, NMRU
  localparam T = 23;   // 23 bit tag
  localparam D = 4;   // 16 bytes per line / 4 bytes per word = 4 words per line

  // The following memory arrays model the cache structure. As this is
  // an internal implementation detail, you are *free* to modify these
  // arrays as you please.

  // Backing memory, modeled as two separate ways.
  reg [   31:0] datas0 [DEPTH - 1:0][D - 1:0];
  reg [   31:0] datas1 [DEPTH - 1:0][D - 1:0];
  reg [T - 1:0] tags0  [DEPTH - 1:0];
  reg [T - 1:0] tags1  [DEPTH - 1:0];
  reg [1:0] valid [DEPTH - 1:0];
  reg       lru   [DEPTH - 1:0];

  // Fill in your implementation here.
  localparam IDLE = 2'b00, ALLOCATE = 2'b01, WRITEBACK = 2'b10;
  reg [1:0] state;
  reg req_RW; // 0 for read, 1 for write, only needed for cache misses to remember request type
  reg [2:0] word_cnt; // 3 bits to allow value to reach D, for i_mem_ren cond: (word_cnt < D)
  reg [1:0] word_rcv_cnt;
  reg prev_i_mem_ready, prev_i_mem_valid;

  wire [T - 1:0] req_tag; // 23
  wire [S - 1:0] req_set; // 5
  wire [O - 1:0] req_offset; // 4
  wire [O - 3:0] req_word_offset; // 2
  wire req_active;
  wire way0_hit, way1_hit;
  wire cache_miss, cache_hit;

  wire [31:0] curr_word;
  wire [31:0] eff_wdata;

  always @(posedge i_clk) begin
    if (i_rst) begin
    
      //shorten this
      valid[1]  <= 2'b00; lru[1]  <= 1'b0;
      valid[0]  <= 2'b00; lru[0]  <= 1'b0;
      valid[2]  <= 2'b00; lru[2]  <= 1'b0;
      valid[3]  <= 2'b00; lru[3]  <= 1'b0;
      valid[4]  <= 2'b00; lru[4]  <= 1'b0;
      valid[5]  <= 2'b00; lru[5]  <= 1'b0;
      valid[6]  <= 2'b00; lru[6]  <= 1'b0;
      valid[7]  <= 2'b00; lru[7]  <= 1'b0;
      valid[8]  <= 2'b00; lru[8]  <= 1'b0;
      valid[9]  <= 2'b00; lru[9]  <= 1'b0;
      valid[10] <= 2'b00; lru[10] <= 1'b0;
      valid[11] <= 2'b00; lru[11] <= 1'b0;
      valid[12] <= 2'b00; lru[12] <= 1'b0;
      valid[13] <= 2'b00; lru[13] <= 1'b0;
      valid[14] <= 2'b00; lru[14] <= 1'b0;
      valid[15] <= 2'b00; lru[15] <= 1'b0;
      valid[16] <= 2'b00; lru[16] <= 1'b0;
      valid[17] <= 2'b00; lru[17] <= 1'b0;
      valid[18] <= 2'b00; lru[18] <= 1'b0;
      valid[19] <= 2'b00; lru[19] <= 1'b0;
      valid[20] <= 2'b00; lru[20] <= 1'b0;
      valid[21] <= 2'b00; lru[21] <= 1'b0;
      valid[22] <= 2'b00; lru[22] <= 1'b0;
      valid[23] <= 2'b00; lru[23] <= 1'b0;
      valid[24] <= 2'b00; lru[24] <= 1'b0;
      valid[25] <= 2'b00; lru[25] <= 1'b0;
      valid[26] <= 2'b00; lru[26] <= 1'b0;
      valid[27] <= 2'b00; lru[27] <= 1'b0;
      valid[28] <= 2'b00; lru[28] <= 1'b0;
      valid[29] <= 2'b00; lru[29] <= 1'b0;
      valid[30] <= 2'b00; lru[30] <= 1'b0;
      valid[31] <= 2'b00; lru[31] <= 1'b0;

      
    // tags
      tags0[0]  <= 0; tags1[0]  <= 0;
      tags0[1]  <= 0; tags1[1]  <= 0;
      tags0[2]  <= 0; tags1[2]  <= 0;
      tags0[3]  <= 0; tags1[3]  <= 0;
      tags0[4]  <= 0; tags1[4]  <= 0;
      tags0[5]  <= 0; tags1[5]  <= 0;
      tags0[6]  <= 0; tags1[6]  <= 0;
      tags0[7]  <= 0; tags1[7]  <= 0;
      tags0[8]  <= 0; tags1[8]  <= 0;
      tags0[9]  <= 0; tags1[9]  <= 0;
      tags0[10] <= 0; tags1[10] <= 0;
      tags0[11] <= 0; tags1[11] <= 0;
      tags0[12] <= 0; tags1[12] <= 0;
      tags0[13] <= 0; tags1[13] <= 0;
      tags0[14] <= 0; tags1[14] <= 0;
      tags0[15] <= 0; tags1[15] <= 0;
      tags0[16] <= 0; tags1[16] <= 0;
      tags0[17] <= 0; tags1[17] <= 0;
      tags0[18] <= 0; tags1[18] <= 0;
      tags0[19] <= 0; tags1[19] <= 0;
      tags0[20] <= 0; tags1[20] <= 0;
      tags0[21] <= 0; tags1[21] <= 0;
      tags0[22] <= 0; tags1[22] <= 0;
      tags0[23] <= 0; tags1[23] <= 0;
      tags0[24] <= 0; tags1[24] <= 0;
      tags0[25] <= 0; tags1[25] <= 0;
      tags0[26] <= 0; tags1[26] <= 0;
      tags0[27] <= 0; tags1[27] <= 0;
      tags0[28] <= 0; tags1[28] <= 0;
      tags0[29] <= 0; tags1[29] <= 0;
      tags0[30] <= 0; tags1[30] <= 0;
      tags0[31] <= 0; tags1[31] <= 0;
  
      // datas (DEPTH=32, D=4)
      datas0[0][0]  <= 0; datas0[0][1]  <= 0; datas0[0][2]  <= 0; datas0[0][3]  <= 0;
      datas1[0][0]  <= 0; datas1[0][1]  <= 0; datas1[0][2]  <= 0; datas1[0][3]  <= 0;
      datas0[1][0]  <= 0; datas0[1][1]  <= 0; datas0[1][2]  <= 0; datas0[1][3]  <= 0;
      datas1[1][0]  <= 0; datas1[1][1]  <= 0; datas1[1][2]  <= 0; datas1[1][3]  <= 0;
      datas0[2][0]  <= 0; datas0[2][1]  <= 0; datas0[2][2]  <= 0; datas0[2][3]  <= 0;
      datas1[2][0]  <= 0; datas1[2][1]  <= 0; datas1[2][2]  <= 0; datas1[2][3]  <= 0;
      datas0[3][0]  <= 0; datas0[3][1]  <= 0; datas0[3][2]  <= 0; datas0[3][3]  <= 0;
      datas1[3][0]  <= 0; datas1[3][1]  <= 0; datas1[3][2]  <= 0; datas1[3][3]  <= 0;
      datas0[4][0]  <= 0; datas0[4][1]  <= 0; datas0[4][2]  <= 0; datas0[4][3]  <= 0;
      datas1[4][0]  <= 0; datas1[4][1]  <= 0; datas1[4][2]  <= 0; datas1[4][3]  <= 0;
      datas0[5][0]  <= 0; datas0[5][1]  <= 0; datas0[5][2]  <= 0; datas0[5][3]  <= 0;
      datas1[5][0]  <= 0; datas1[5][1]  <= 0; datas1[5][2]  <= 0; datas1[5][3]  <= 0;
      datas0[6][0]  <= 0; datas0[6][1]  <= 0; datas0[6][2]  <= 0; datas0[6][3]  <= 0;
      datas1[6][0]  <= 0; datas1[6][1]  <= 0; datas1[6][2]  <= 0; datas1[6][3]  <= 0;
      datas0[7][0]  <= 0; datas0[7][1]  <= 0; datas0[7][2]  <= 0; datas0[7][3]  <= 0;
      datas1[7][0]  <= 0; datas1[7][1]  <= 0; datas1[7][2]  <= 0; datas1[7][3]  <= 0;
      datas0[8][0]  <= 0; datas0[8][1]  <= 0; datas0[8][2]  <= 0; datas0[8][3]  <= 0;
      datas1[8][0]  <= 0; datas1[8][1]  <= 0; datas1[8][2]  <= 0; datas1[8][3]  <= 0;
      datas0[9][0]  <= 0; datas0[9][1]  <= 0; datas0[9][2]  <= 0; datas0[9][3]  <= 0;
      datas1[9][0]  <= 0; datas1[9][1]  <= 0; datas1[9][2]  <= 0; datas1[9][3]  <= 0;
      datas0[10][0] <= 0; datas0[10][1] <= 0; datas0[10][2] <= 0; datas0[10][3] <= 0;
      datas1[10][0] <= 0; datas1[10][1] <= 0; datas1[10][2] <= 0; datas1[10][3] <= 0;
      datas0[11][0] <= 0; datas0[11][1] <= 0; datas0[11][2] <= 0; datas0[11][3] <= 0;
      datas1[11][0] <= 0; datas1[11][1] <= 0; datas1[11][2] <= 0; datas1[11][3] <= 0;
      datas0[12][0] <= 0; datas0[12][1] <= 0; datas0[12][2] <= 0; datas0[12][3] <= 0;
      datas1[12][0] <= 0; datas1[12][1] <= 0; datas1[12][2] <= 0; datas1[12][3] <= 0;
      datas0[13][0] <= 0; datas0[13][1] <= 0; datas0[13][2] <= 0; datas0[13][3] <= 0;
      datas1[13][0] <= 0; datas1[13][1] <= 0; datas1[13][2] <= 0; datas1[13][3] <= 0;
      datas0[14][0] <= 0; datas0[14][1] <= 0; datas0[14][2] <= 0; datas0[14][3] <= 0;
      datas1[14][0] <= 0; datas1[14][1] <= 0; datas1[14][2] <= 0; datas1[14][3] <= 0;
      datas0[15][0] <= 0; datas0[15][1] <= 0; datas0[15][2] <= 0; datas0[15][3] <= 0;
      datas1[15][0] <= 0; datas1[15][1] <= 0; datas1[15][2] <= 0; datas1[15][3] <= 0;
      datas0[16][0] <= 0; datas0[16][1] <= 0; datas0[16][2] <= 0; datas0[16][3] <= 0;
      datas1[16][0] <= 0; datas1[16][1] <= 0; datas1[16][2] <= 0; datas1[16][3] <= 0;
      datas0[17][0] <= 0; datas0[17][1] <= 0; datas0[17][2] <= 0; datas0[17][3] <= 0;
      datas1[17][0] <= 0; datas1[17][1] <= 0; datas1[17][2] <= 0; datas1[17][3] <= 0;
      datas0[18][0] <= 0; datas0[18][1] <= 0; datas0[18][2] <= 0; datas0[18][3] <= 0;
      datas1[18][0] <= 0; datas1[18][1] <= 0; datas1[18][2] <= 0; datas1[18][3] <= 0;
      datas0[19][0] <= 0; datas0[19][1] <= 0; datas0[19][2] <= 0; datas0[19][3] <= 0;
      datas1[19][0] <= 0; datas1[19][1] <= 0; datas1[19][2] <= 0; datas1[19][3] <= 0;
      datas0[20][0] <= 0; datas0[20][1] <= 0; datas0[20][2] <= 0; datas0[20][3] <= 0;
      datas1[20][0] <= 0; datas1[20][1] <= 0; datas1[20][2] <= 0; datas1[20][3] <= 0;
      datas0[21][0] <= 0; datas0[21][1] <= 0; datas0[21][2] <= 0; datas0[21][3] <= 0;
      datas1[21][0] <= 0; datas1[21][1] <= 0; datas1[21][2] <= 0; datas1[21][3] <= 0;
      datas0[22][0] <= 0; datas0[22][1] <= 0; datas0[22][2] <= 0; datas0[22][3] <= 0;
      datas1[22][0] <= 0; datas1[22][1] <= 0; datas1[22][2] <= 0; datas1[22][3] <= 0;
      datas0[23][0] <= 0; datas0[23][1] <= 0; datas0[23][2] <= 0; datas0[23][3] <= 0;
      datas1[23][0] <= 0; datas1[23][1] <= 0; datas1[23][2] <= 0; datas1[23][3] <= 0;
      datas0[24][0] <= 0; datas0[24][1] <= 0; datas0[24][2] <= 0; datas0[24][3] <= 0;
      datas1[24][0] <= 0; datas1[24][1] <= 0; datas1[24][2] <= 0; datas1[24][3] <= 0;
      datas0[25][0] <= 0; datas0[25][1] <= 0; datas0[25][2] <= 0; datas0[25][3] <= 0;
      datas1[25][0] <= 0; datas1[25][1] <= 0; datas1[25][2] <= 0; datas1[25][3] <= 0;
      datas0[26][0] <= 0; datas0[26][1] <= 0; datas0[26][2] <= 0; datas0[26][3] <= 0;
      datas1[26][0] <= 0; datas1[26][1] <= 0; datas1[26][2] <= 0; datas1[26][3] <= 0;
      datas0[27][0] <= 0; datas0[27][1] <= 0; datas0[27][2] <= 0; datas0[27][3] <= 0;
      datas1[27][0] <= 0; datas1[27][1] <= 0; datas1[27][2] <= 0; datas1[27][3] <= 0;
      datas0[28][0] <= 0; datas0[28][1] <= 0; datas0[28][2] <= 0; datas0[28][3] <= 0;
      datas1[28][0] <= 0; datas1[28][1] <= 0; datas1[28][2] <= 0; datas1[28][3] <= 0;
      datas0[29][0] <= 0; datas0[29][1] <= 0; datas0[29][2] <= 0; datas0[29][3] <= 0;
      datas1[29][0] <= 0; datas1[29][1] <= 0; datas1[29][2] <= 0; datas1[29][3] <= 0;
      datas0[30][0] <= 0; datas0[30][1] <= 0; datas0[30][2] <= 0; datas0[30][3] <= 0;
      datas1[30][0] <= 0; datas1[30][1] <= 0; datas1[30][2] <= 0; datas1[30][3] <= 0;
      datas0[31][0] <= 0; datas0[31][1] <= 0; datas0[31][2] <= 0; datas0[31][3] <= 0;
      datas1[31][0] <= 0; datas1[31][1] <= 0; datas1[31][2] <= 0; datas1[31][3] <= 0;
      
      
      state <= IDLE;
      req_RW <= 1'b0;
      word_cnt <= 3'b000;
      word_rcv_cnt <= 2'b00;
      prev_i_mem_ready <= 1'b0;
      prev_i_mem_valid <= 1'b0;
    end else begin
      prev_i_mem_ready <= i_mem_ready;
      prev_i_mem_valid <= i_mem_valid;

      case (state)
        IDLE: begin
          if (~i_req_wen && ~i_req_ren) begin
            state <= IDLE; // stay in IDLE if no request
          end else if (cache_hit) begin
            lru[req_set] <= way0_hit; // if way0 hit, way1 is LRU, else way0 is LRU

            if (i_req_wen) begin
              // write to cache and memory
              if (way0_hit) begin
                datas0[req_set][req_word_offset] <= eff_wdata;
              end else begin
                datas1[req_set][req_word_offset] <= eff_wdata;
              end
            end
          end else if (cache_miss) begin
            req_RW <= i_req_wen;

            word_cnt <= 3'b000;
            word_rcv_cnt <= 2'b00;
            state <= ALLOCATE;
          end
        end
        ALLOCATE: begin
          if (prev_i_mem_ready & ~i_mem_ready) word_cnt <= word_cnt + 1; // falling edge of i_mem_ready -> request next word
          if (~prev_i_mem_valid & i_mem_valid) begin // forget if mem_valid lasts >1 cycle
            // overwrite older way's data
            if (lru[req_set]) begin
              datas1[req_set][word_rcv_cnt] <= i_mem_rdata;
            end else begin
              datas0[req_set][word_rcv_cnt] <= i_mem_rdata;
            end

            word_rcv_cnt <= word_rcv_cnt + 1;
          end
          
          if (&word_rcv_cnt & i_mem_valid) begin
            // overwrite older way's tag and valid
            if (lru[req_set]) begin
              tags1[req_set] <= req_tag;
              valid[req_set][1] <= 1'b1;

              if (req_RW) datas1[req_set][req_word_offset] <= eff_wdata;
            end else begin
              tags0[req_set] <= req_tag;
              valid[req_set][0] <= 1'b1;

              if (req_RW) datas0[req_set][req_word_offset] <= eff_wdata;
            end

            // update LRU
            lru[req_set] <= ~lru[req_set]; // Lucky for 2 ways, can simply flip LRU on a miss

            state <= req_RW ? WRITEBACK : IDLE; // no need to visit WRITEBACK if miss was a read
          end
        end
        WRITEBACK: begin
          // wait for mem_wen request to occur, then return to IDLE
          if (o_mem_wen) state <= IDLE;
        end
        default: state <= IDLE; // for invalid state 2'b11
      endcase
    end
  end

  assign curr_word = way0_hit ? datas0[req_set][req_word_offset] : datas1[req_set][req_word_offset]; // will update immediately with allocs
  assign eff_wdata = {i_req_mask[3] ? i_req_wdata[31:24] : curr_word[31:24],
      i_req_mask[2] ? i_req_wdata[23:16] : curr_word[23:16],
      i_req_mask[1] ? i_req_wdata[15:8] : curr_word[15:8],
      i_req_mask[0] ? i_req_wdata[7:0] : curr_word[7:0]};

  assign o_mem_ren = i_mem_ready & (state == ALLOCATE) & (word_cnt < 4); // Using 4 in place of D to suppress warnings
  assign o_mem_wen = i_mem_ready & (((state == WRITEBACK) & req_RW) | (cache_hit & i_req_wen));
  // If accessing mem in ALLOCATE, word_cnt helps iterate over all 4 words in the line
  assign o_mem_addr = {req_tag, req_set, (state == ALLOCATE) ? word_cnt[1:0] : req_word_offset, 2'b00};
  assign o_mem_wdata = eff_wdata;

  assign req_tag = i_req_addr[31:O + S]; // 31:9
  assign req_set = i_req_addr[O + S - 1:O]; // 8:4
  assign req_offset = i_req_addr[O - 1:0]; // 3:0
  assign req_word_offset = req_offset[O - 1:2]; // 3:2

  assign req_active = i_req_ren | i_req_wen;

  assign way0_hit = (tags0[req_set] == req_tag) & valid[req_set][0];
  assign way1_hit = (tags1[req_set] == req_tag) & valid[req_set][1];
  assign cache_miss = req_active & ~(way0_hit | way1_hit);
  assign cache_hit = req_active & (way0_hit | way1_hit);

  assign o_busy = cache_miss | (state != IDLE);

  // output is don't care unless: o_busy == 0 AND i_req_en == 1  -- so don't need to check, also o_busy=0 implies a matching cache line.
  assign o_res_rdata = curr_word;
endmodule

`default_nettype wire

