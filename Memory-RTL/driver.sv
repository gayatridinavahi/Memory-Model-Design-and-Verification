class driver;

packet   pkt;
mailbox #(packet) mbx;
virtual memory_if.tb vif;
bit [15:0] no_of_pkts_recvd;

  
function new (input mailbox #(packet) mbx_in,
	      input virtual memory_if.tb vif_in);
this.mbx  = mbx_in;
this.vif  = vif_in;
endfunction

extern task run();
extern task drive(packet pkt);
extern task drive_reset(packet pkt);
extern task drive_stimulus(packet pkt);
extern task write(packet pkt);
extern task read(packet pkt);
extern function void report();

endclass

task driver::run();
$display("[Driver] run started at time=%0t",$time); 
while(1) begin //driver runs forever 
mbx.get(pkt);
no_of_pkts_recvd++;
$display("[Driver] Received  %0s packet %0d from generator at time=%0t",pkt.kind.name(),no_of_pkts_recvd,$time); 
drive(pkt);
$display("[Driver] Done with %0s packet %0d from generator at time=%0t",pkt.kind.name(),no_of_pkts_recvd,$time); 
end//end_of_while
endtask

task driver::drive(packet pkt);
case (pkt.kind)
    RESET      : drive_reset(pkt);
    STIMULUS   : drive_stimulus(pkt);
	default    : $display("[Error] Unknown packet received in driver");
endcase
endtask

task driver::drive_reset(packet pkt);
$display("[Driver] Driving Reset transaction into DUT at time=%0t",$time); 
vif.reset      <= 1'b1;
repeat(pkt.reset_cycles) @(vif.cb);
vif.reset      <= 1'b0;
$display("[Driver] Driving Reset transaction completed at time=%0t",$time); 
endtask


task driver::drive_stimulus(packet pkt);
    write(pkt);
    read(pkt);
endtask

task driver::write(packet pkt);
@(vif.cb);
$display("[Driver] write operation started with addr=%0d data=%0d at time=%0t",pkt.addr,pkt.data,$time); 
vif.cb.wr      <= 1'b1;
vif.cb.addr    <= pkt.addr;
vif.cb.wdata   <= pkt.data;
@(vif.cb);
vif.cb.wr      <= 1'b0;
$display("[Driver] write operation ended with addr=%0d data=%0d at time=%0t",pkt.addr,pkt.data,$time); 
endtask

task driver::read(packet pkt);
$display("[Driver] read operation started with addr=%0d at time=%0t",pkt.addr,$time); 
vif.cb.rd      <= 1'b1;
vif.cb.addr    <= pkt.addr;
@(vif.cb);
vif.cb.rd  <= 1'b0;
$display("[Driver] read operation ended with addr=%0d at time=%0t",pkt.addr,$time); 
endtask

function void driver::report();
$display("Report: total_packets_driven=%0d ",no_of_pkts_recvd); 
endfunction
