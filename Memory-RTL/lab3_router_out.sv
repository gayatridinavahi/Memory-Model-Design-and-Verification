//Section 8: Collecting DUT output
initial begin
bit [15:0] cnt;
  forever begin
    @(posedge outp_valid);
    while(1) begin
      @(posedge clk);
        if(outp_valid==0) begin
	      cnt++; 
	      unpack(outp_stream,dut_pkt);
	      $display("[TB Output Monitor] Packet %0d collected size=%0d time=%0t",cnt,outp_stream.size(),$time);  
          outp_stream.delete();
	      break;
        end
  
      outp_stream.push_back(dut_outp);
      //$display("[TB outp] dut_outp=%0d time=%0t",dut_outp,$time);      
    end//end_of_while	
  end//end_of_forever
end//end_of_initial
  