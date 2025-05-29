class environment;

bit [31:0] no_of_pkts;//assigned in testcase

mailbox #(packet) gen_drv_mbox; //will be connected to generator and driver
mailbox #(packet) mon_in_scb_mbox;//will be connected to input monitor and mon_in in scoreborad
mailbox #(packet) mon_out_scb_mbox;//will be connected to output monitor and mon_out in scoreborad

virtual memory_if.tb     vif;
virtual memory_if.tb_mon_in vif_mon_in;
virtual memory_if.tb_mon_out vif_mon_out;

generator  gen;
driver     drvr;
iMonitor   mon_in;
oMonitor   mon_out;
scoreboard scb;


function new (input virtual memory_if.tb vif_in,
              input virtual memory_if.tb_mon_in  vif_mon_in,
              input virtual memory_if.tb_mon_out vif_mon_out,
			input bit [31:0] no_of_pkts);
this.vif= vif_in;
this.vif_mon_in=vif_mon_in;
this.vif_mon_out=vif_mon_out;
this.no_of_pkts=no_of_pkts;
endfunction

function void build();//construction and connection
$display("[Environment] build started at time=%0t",$time); 
gen_drv_mbox      = new(1);
mon_in_scb_mbox   = new;
mon_out_scb_mbox  = new;
gen               = new(gen_drv_mbox,no_of_pkts);
drvr              = new(gen_drv_mbox,vif);
mon_in            = new(mon_in_scb_mbox,vif_mon_in);
mon_out           = new(mon_out_scb_mbox,vif_mon_out);
scb               = new(mon_in_scb_mbox,mon_out_scb_mbox);

$display("[Environment] build ended at time=%0t",$time); 
endfunction

task run ;
$display("[Environment] run started at time=%0t",$time); 


//Start all the components of environment
fork
gen.run();//start the generator
drvr.run();
mon_in.run();
mon_out.run();
scb.run();
join_any
  
  wait(scb.total_pkts_recvd == no_of_pkts);//Test termination
 
repeat(10) @(vif.cb);
report();
$display("[Environment] run ended at time=%0t",$time); 
endtask

function void report();
$display("\n[Environment] ****** Report Started ********** "); 
gen.report();
drvr.report();
mon_in.report();
mon_out.report();
scb.report();


$display("\n***********************"); 
if(scb.m_mismatches ==0 && (no_of_pkts == scb.total_pkts_recvd) ) begin
$display("***********TEST PASSED ************ ");
$display("*******Matches=%0d Mis_matches=%0d ********* \n",scb.m_matches,scb.m_mismatches); 
end
else begin
$display("*********TEST FAILED ************ "); 
$display("*******Matches=%0d Mis_matches=%0d ********* \n",scb.m_matches,scb.m_mismatches); 
end

$display("*************************\n "); 

$display("[Environment] ******** Report ended******** \n"); 
endfunction

endclass
