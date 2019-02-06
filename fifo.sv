module fifo(data_op,full,empty,data_in,wr_en,rd_en,clk,rst);
  
  input[31:0] data_in;
  input rst,wr_en,rd_en,clk;
  output reg [31:0] data_op,full,empty;
  reg [7:0]ram[31:0];
  integer wr_ptr;
  integer rd_ptr;
  //wire tmp_full,tmp_empty;
  
  always @(posedge clk)begin
      
    if(rst)begin
      data_op <= 32'b0;
      wr_ptr <= 1'b0;
      rd_ptr <= 1'b0;
    end  
    
    else if((wr_en == 1) && (~full)&&(rd_en == 0)) begin
      ram[wr_ptr] <= data_in;
      wr_ptr = wr_ptr+1;
      empty <= 1'b0;
      if(wr_ptr == rd_ptr) begin
        full <= 1'b1;
        empty <= 1'b0; 
      end
    end
    
    else if((rd_en == 1) && (~empty)&&(wr_en == 0))begin
      data_op <= ram[rd_ptr];
      rd_ptr = rd_ptr+1;
	if(wr_ptr == rd_ptr) begin
        full <= 1'b0;
        empty <= 1'b1; 
      end
    end
    
  end   
endmodule
