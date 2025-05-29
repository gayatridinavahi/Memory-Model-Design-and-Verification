class generator;

bit [31:0] no_of_pkts;
packet pkt;
packet rand_obj;
mailbox #(packet) mbx;

function new (mailbox #(packet) mbx_in,bit [31:0] gen_pkts_no=1);
this.no_of_pkts= gen_pkts_no;
this.mbx       = mbx_in;
rand_obj=new;
endfunction

task run ;
bit [31:0] pkt_count;
$display("[Generator] run started at time=%0t",$time); 

//generate First packet as Reset packet
pkt=new;
pkt.kind=RESET;
pkt.reset_cycles=2;
$display("[Generator] Sending %0s packet to driver at time=%0t",pkt.kind.name(),$time); 
mbx.put(pkt);

//generate the NORMAL Stimulus
repeat(no_of_pkts) begin
void'(rand_obj.randomize());
pkt=new;
pkt.copy(rand_obj);
pkt.kind=STIMULUS;
mbx.put(pkt);
pkt_count++;
$display("[Generator] Sent %0s packet %0d to driver at time=%0t",pkt.kind.name(),pkt_count,$time); 
end

$display("[Generator] run ended at time=%0t",$time); 
endtask

function void report();
$display("[Generator]  Report: total_packets_generated=%0d ",no_of_pkts); 
endfunction

endclass
