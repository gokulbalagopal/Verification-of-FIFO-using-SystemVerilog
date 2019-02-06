//`include "transaction.sv"
class scoreboard;
 mailbox mon2scb;
 int no_trans;
 bit[7:0]ram[4];
 bit wr_ptr;
 bit rd_ptr;
 
 function new(mailbox mon2scb);
   this.mon2scb = mon2scb;
   foreach(ram[i])begin
    ram[i] = 8'hff;
   end
 endfunction 
 
  task main;
   forever begin   
    transaction trans;
    #50
    mon2scb.get(trans);
    if(trans.wr_en)begin
      ram[wr_ptr] = trans.data_in;
      wr_ptr++;
    end  
    if(trans.rd_en)begin
      if(trans.data_op == ram[rd_ptr])begin
        rd_ptr++;
        $display("yup");
      end
      else begin
        $display("nop");
      end
    end
    if(trans.full)begin
      $display("fifo is full");
    end
    if(trans.empty)begin
      $display("fifo is empty");
    end
    no_trans++;
   end
  endtask
endclass
