interface fifo_intf(input logic clk,rst);
  logic [31:0]data_in;
  logic wr_en,rd_en;
  logic [31:0]data_op;
  logic full,empty;
  
  clocking driver_cb@(posedge clk);
    default input #1 output #1;
    output data_in;
    output wr_en,rd_en;
    input data_op;
    input full,empty;
  endclocking

  clocking monitor_cb@(posedge clk);
    default input #1 output #1;
    input data_in;
    input wr_en,rd_en;
    input data_op;
    input full,empty;
  endclocking
  
  modport DRIVER(clocking driver_cb,input clk,rst);
  modport MONITOR(clocking monitor_cb,input clk,rst);
    
endinterface  
