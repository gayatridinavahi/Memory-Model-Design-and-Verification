`include "if_memory.sv"
`include "memory_rtl.sv"
`include "program_mem.sv"
module top;


parameter reg [15:0] ADDR_WIDTH=4;
parameter reg [15:0] DATA_WIDTH=32;
parameter reg [15:0] MEM_SIZE=16;

bit clk;

always #10 clk=!clk;


memory_if mem_if (clk);

memory_rtl  dut_inst 
 (
  .clk(clk),
  .reset(mem_if.reset),
  .wr(mem_if.wr),
  .rd(mem_if.rd), 
  .addr(mem_if.addr),
  .wdata(mem_if.wdata),
  .rdata(mem_if.rdata),
  .response(mem_if.slv_rsp)
 );
 
program_test ptest (mem_if);

endmodule
