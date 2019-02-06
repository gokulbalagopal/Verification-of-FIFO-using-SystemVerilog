`include "interface.sv"
module tb_top;
 bit clk,rst;
 
 always #5 clk = ~ clk;
 
 initial begin
  rst = 1;
  #5 rst = 0;
 end
 
 fifo_intf intf(clk,rst) ;
 test t1(intf);
 fifo DUT(.data_op(intf.data_op),
          .full(intf.full),
          .empty(intf.empty),
          .data_in(intf.data_in),
          .wr_en(intf.wr_en),
          .rd_en(intf.rd_en),
          .clk(intf.clk),
          .rst(intf.rst));
endmodule
