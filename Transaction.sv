class transaction;
  //only input signals for randomisation and no ports
  bit rst,clk;
  rand bit [31:0] data_in;
  rand bit wr_en,rd_en;	
  bit[31:0]data_op;
  bit full,empty;
  
  constraint wr_rd_en{wr_en != rd_en;};

endclass

