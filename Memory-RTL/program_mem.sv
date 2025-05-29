`include "mem_env_pkg.sv"

program program_test (memory_if vif);

import mem_env_pkg::*;
`include "test.sv"
  
base_test test;

initial begin
$display("[Program Block] simulation Started at time=%0t",$time);
test=new(vif.tb,vif.tb_mon_in,vif.tb_mon_out);
test.run();
$display("[Program Block] simulation finished at time=%0t",$time);
end

endprogram
