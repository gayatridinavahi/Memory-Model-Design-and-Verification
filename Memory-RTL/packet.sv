typedef enum {IDLE,STIMULUS,RESET} pkt_type_t;

class packet;

rand bit [3:0]  addr;
rand bit [31:0] data;
rand bit        wr,rd;
pkt_type_t      kind;
bit slv_rsp;//Value 0 indicates Error
	        //Value 1 indicates OK (Transaction successfully sampled by the RTL)

bit [3:0] reset_cycles;

bit [3:0]  prev_addr;
bit [31:0] prev_data;

constraint valid {
addr inside {[0:15]};//valid address space for memory RTL is 0-15
data inside {[10:9999]};
data != prev_data;
addr != prev_addr;
}

function void post_randomize();
    prev_addr=addr;
    prev_data=data;
endfunction


extern function void print();
extern function void copy(packet rhs);
extern function bit compare(packet rhs);
endclass

function void packet::print ();
$display("[Packet] addr=%0d data=%0d at time=%0t",addr,data,$time);
endfunction

function void packet::copy (packet rhs);
if(rhs==null) begin
    $display("[Packet] Error Null object passed to copy method ");
    return;
end
this.addr=rhs.addr;
this.data=rhs.data;
endfunction

function bit packet::compare (packet rhs);
bit result;

if(rhs==null) begin
    $display("[Packet] Error Null object passed to compare method ");
    return 0;
end
result = (this.addr == rhs.addr) && (this.data == rhs.data);
return result;
endfunction
