class oMonitor ;

bit [15:0] no_of_pkts_recvd;
packet   pkt;
virtual memory_if.tb_mon_out vif;
mailbox #(packet) mbx;//will be connected to Output of scoreboard


function new (input mailbox #(packet) mbx_in,
              input virtual memory_if.tb_mon_out vif_in
	         );
this.mbx = mbx_in;
this.vif = vif_in;

endfunction

task run() ;
bit [15:0] addr;
$display("[oMonitor] run started at time=%0t ",$time); 
while(1) begin
@(vif.cb_mon_out.rdata);

//skip the loop when data_out is in high impedance state
if(vif.cb_mon_out.rdata === 'z || vif.cb_mon_out.rdata === 'x)
begin
//$display("@%0t [oMonitor] DEBUG 1 data_out=%0d \n",$time,vif.cb_mon_out.data_out); 
    continue;
end

//$display("@%0t [oMonitor] data_out=%0d \n",$time,vif.cb_mon_out.data_out); 
pkt=new;
pkt.addr  = vif.cb_mon_out.addr;
pkt.data  = vif.cb_mon_out.rdata;//read data

mbx.put(pkt);
no_of_pkts_recvd++;
pkt.print();
$display("[oMonitor] Sent packet %0d to scoreboard at time=%0t ",no_of_pkts_recvd,$time); 
end

$display("[oMonitor] run ended at time=%0t ",$time);//monitor will never end 
endtask

function void report();
$display("[oMonitor] Report: total_packets_received=%0d ",no_of_pkts_recvd); 
endfunction



endclass
