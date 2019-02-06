//Generator generates signals and declares the transaction class handles
//Randomise transactions
//`include "transaction.sv"
class generator;
  //declaring transaction class 
  rand transaction trans;
  mailbox gen2drv;
  int repeat_count;
  event drv2gen;

  function new( mailbox gen2drv, event drv2gen);
    this.gen2drv = gen2drv;
    this.drv2gen = drv2gen;  
  endfunction
  
  task main();
   repeat(repeat_count)begin 
    trans = new();
    if(!trans.randomize()) $fatal("Gen::trans randomization failed"); 
     gen2drv.put(trans);
   end 
   ->drv2gen;
  endtask

endclass
