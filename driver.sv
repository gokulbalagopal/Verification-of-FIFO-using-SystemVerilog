`include "transaction.sv"
//`include "transaction.sv"
`define DRIVER_IF fifo_intf.DRIVER.driver_cb
//DRIVER_IF ponts to the DRIVER modport in interface
class driver;
  
  int no_trans;
  virtual fifo_intf vif_fifo;
  mailbox gen2drv;
  
  function new(virtual fifo_intf vif_fifo,mailbox gen2drv);
    this.vif_fifo = vif_fifo;
    this.gen2drv = gen2drv;
  endfunction  
  
  task reset;
    $display("resetting");
    wait(vif_fifo.rst);
    `DRIVER_IF.data_in <= 0;
    `DRIVER_IF.wr_en <= 0;
    `DRIVER_IF.rd_en <= 0;
    wait(!vif_fifo.rst);
    $display("done resetting");
  endtask
  
  task drive;
    forever begin
      transaction trans;
     `DRIVER_IF.wr_en <=0;
     `DRIVER_IF.rd_en <=0;
     gen2drv.get(trans);
     $display("no: of transactions = ",no_trans);
     
     @(posedge `DRIVER_IF.clk);
     if(trans.wr_en)begin
      `DRIVER_IF.wr_en <= trans.wr_en;
      `DRIVER_IF.data_in <= trans.data_in;
       trans.full =`DRIVER_IF.full;
       trans.empty =`DRIVER_IF.empty;
      $display("\t write enable = %0h \t data input = %0h",trans.wr_en,trans.data_in);
     end
     
     if(trans.rd_en)begin
      `DRIVER_IF.rd_en <= trans.rd_en;
      @(posedge `DRIVER_IF.clk);
      `DRIVER_IF.rd_en <= 0;
      @(posedge `DRIVER_IF.clk);
       trans.data_op =`DRIVER_IF.data_op  ;
       trans.full = `DRIVER_IF.full;
       trans.empty =`DRIVER_IF.empty;

      $display("\t read enable = %0h \t data output = %0h",trans.rd_en,trans.data_op);
     end
    no_trans++;
    end
  endtask
  
  task main;
   
   forever begin
    fork 
     begin
      wait(vif_fifo.reset);
     end
    
     begin
      drive();
     end
    join_any
    disable fork;
   end
  endtask
    
endclass
