class scoreboard;

bit [15:0] total_pkts_recvd;
packet   ref_pkt;
packet   got_pkt;
mailbox #(packet) mbx_in; //will be connected to input monitor
mailbox #(packet) mbx_out;//will be connected to output monitor
bit [15:0] m_matches;
bit [15:0] m_mismatches;

function new (input mailbox #(packet) mbx_in,
              input mailbox #(packet) mbx_out);

this.mbx_in  = mbx_in;
this.mbx_out = mbx_out;
endfunction

task run ;

$display("[Scoreboard] run started at time=%0t",$time); 
while(1) begin
mbx_in.get(ref_pkt);
mbx_out.get(got_pkt);
total_pkts_recvd++;
$display("[Scoreboard] Packet %0d received at time=%0t",total_pkts_recvd,$time); 
if (ref_pkt.compare(got_pkt) )
begin
    m_matches++;
$display("[Scoreboard] Packet %0d Matched ",total_pkts_recvd); 
end
    else
    begin
    m_mismatches++;
    
$display("[Scoreboard] ERROR :: Packet %0d Not_Matched at time=%0t",total_pkts_recvd,$time); 
$display("[Scoreboard] *** Expected addr=%0d data=%0d but Received addr=%0d data=%0d ****",$time,ref_pkt.addr,ref_pkt.data,got_pkt.addr,got_pkt.data); 
end
    
end

$display("[Scoreboard] run ended at time=%0t",$time); 
endtask

function void report();
$display("[Scoreboard] Report: total_packets_received=%0d ",total_pkts_recvd); 
$display("[Scoreboard] Report: Matches=%0d Mis_Matches=%0d ",m_matches,m_mismatches); 
endfunction

endclass
