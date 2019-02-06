//`include "transaction.sv"
`define MONITOR_IF fifo_intf.MONITOR.monitor_cb
class monitor; 
 virtual fifo_intf vif_fifo;
 mailbox mon2scb;
 
 function new(virtual fifo_intf vif_fifo,mailbox mon2scb);
  this.vif_fifo = vif_fifo;
  this.mon2scb = mon2scb;
 endfunction
 
 task main;
  forever begin
   transaction trans;
   trans = new();
   @(posedge `MONITOR_IF.clk);
   wait(`MONITOR_IF.wr_en||`MONITOR_IF.rd_en);
   if(`MONITOR_IF.wr_en)begin
    trans.wr_en = `MONITOR_IF.wr_en ;
    trans.data_in = `MONITOR_IF.data_in; 
    trans.full = `MONITOR_IF.full;
    trans.empty = `MONITOR_IF.empty;
    $display("\t ADDR= %0h \t DATA IN = %0h",trans.wr_en,trans.data_in);
   end
   @(posedge `MONITOR_IF.clk);
   if(`MONITOR_IF.rd_en)begin
    trans.rd_en = `MONITOR_IF.rd_en ;
    @(posedge `MONITOR_IF.clk);
     trans.data_op = `MONITOR_IF.data_op;
     trans.full = `MONITOR_IF.full;
     trans.empty = `MONITOR_IF.empty;
    $display("\t ADDR= %0h \t DATA IN = %0h",trans.wr_en,trans.data_in);
   end
   mon2scb.put(trans);
  end   
 endtask
endclass
  
