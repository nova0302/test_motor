`define SV
`timescale 1ns/10ps

module Dir_test_tb (/*AUTOARG*/) ;

   reg      CLK = 1'b0, RSTn = 1'b0, IR1 = 1'b1, IR2 = 1'b1, IR3 = 1'b1, SW = 1'b0;
   wire     dir, en;

   task tDrv (input integer nDly,
	      output IR);
      begin
	 repeat(nDly)@(posedge CLK);
	 IR <= 1'b0;
	 repeat(3)@(posedge CLK);
	 IR <= 1'b1;
      end
   endtask // repeat
   
   task tDrv1 (input integer nDly);
      begin
	 repeat(nDly)@(posedge CLK);
	 IR1 <= 1'b0;
	 repeat(13)@(posedge CLK);
	 IR1 <= 1'b1;
      end
   endtask // repeat
   
   task tDrv2 (input integer nDly);
      begin
	 repeat(nDly)@(posedge CLK);
	 IR2 <= 1'b0;
	 repeat(13)@(posedge CLK);
	 IR2 <= 1'b1;
      end
   endtask // repeat

   task tDrv3 (input integer nDly);
      begin
	 repeat(nDly)@(posedge CLK);
	 IR3 <= 1'b0;
	 repeat(13)@(posedge CLK);
	 IR3 <= 1'b1;
      end
   endtask // repeat

   
   initial begin:my_initial
      integer i;
      repeat(1) @(posedge CLK);
      RSTn <= 1'b1;
      repeat(1) @(posedge CLK);
      fork 
	 tDrv1(1);
	 tDrv2(4);
	 tDrv3(8);
      join
      repeat(2) @(posedge CLK);
      fork 
	 tDrv3(1);
	 tDrv2(4);
	 tDrv1(8);
      join
      repeat(5) @(posedge CLK);
      $stop;
      //$finish;
   end // block: my_initial

   always@(posedge CLK)
`ifdef SV
     $display("@%4t IR1:%b IR2:%b IR3:%b State:%s", 
	      $time, IR1, IR2, IR3, dut.State);
`else
   $display("@%4t IR1:%b IR2:%b IR3:%b State:%4b", 
	    $time, IR1, IR2, IR3, dut.State);
`endif

   
   initial begin
      forever #5 CLK <= ~ CLK;
   end
   
   Dir_test dut(.*);

   
endmodule // Dir_test_tb

