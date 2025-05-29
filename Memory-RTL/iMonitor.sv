class iMonitor ;

bit [15:0] no_of_pkts_recvd;
packet   pkt;
virtual memory_if.tb_mon_in vif;
mailbox #(packet) mbx;//will be connected to input of scoreboard


function new (input mailbox #(packet) mbx_in,
              input virtual memory_if.tb_mon_in vif_in
	         );
this.mbx = mbx_in;
this.vif = vif_in;
endfunction

task run() ;

$display("[iMonitor] run started at time=%0t ",$time); 
while(1) begin
@(vif.cb_mon_in.wdata);
if(vif.cb_mon.wr==0) continue;
pkt=new;
pkt.addr  = vif.cb_mon_in.addr;
pkt.data  = vif.cb_mon_in.wdata;//write data

mbx.put(pkt);
no_of_pkts_recvd++;
pkt.print();
$display("[iMonitor] Sent packet %0d to scoreboard at time=%0t ",no_of_pkts_recvd,$time); 
end

$display("[iMonitor] run ended at time=%0t ",$time);//monitor will never end 
endtask

function void report();
$display("[iMonitor] Report: total_packets_received=%0d ",no_of_pkts_recvd); 
endfunction

endclass
