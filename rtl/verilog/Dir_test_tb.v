`define SV
`timescale 1ns/10ps

module Dir_test_tb (/*AUTOARG*/) ;

   reg      CLK = 1'b0, RSTn = 1'b0, IR1 = 1'b1, IR2 = 1'b1, IR3 = 1'b1, SW = 1'b0;
   wire     dir, en;

`ifdef SV
   task automatic tDrv (input integer nDly,
			ref  IR);
      begin
	 repeat(nDly)@(posedge CLK);
	 IR = 1'b0;
	 repeat(43)@(posedge CLK);
	 IR = 1'b1;
      end
   endtask // repeat
`else
   task tDrv1 (input integer nDly);
      begin
	 repeat(nDly)@(posedge CLK);
	 IR1 <= 1'b0;
	 repeat(43)@(posedge CLK);
	 IR1 <= 1'b1;
      end
   endtask // repeat
   
   task tDrv2 (input integer nDly);
      begin
	 repeat(nDly)@(posedge CLK);
	 IR2 <= 1'b0;
	 repeat(43)@(posedge CLK);
	 IR2 <= 1'b1;
      end
   endtask // repeat

   task tDrv3 (input integer nDly);
      begin
	 repeat(nDly)@(posedge CLK);
	 IR3 <= 1'b0;
	 repeat(43)@(posedge CLK);
	 IR3 <= 1'b1;
      end
   endtask // repeat
   
`endif
   
   initial begin:my_initial
      integer i;
      repeat(1) @(posedge CLK);
      RSTn <= 1'b1;
      repeat(1) @(posedge CLK);
`ifdef SV
      fork 
	 tDrv(1, IR1);
	 tDrv(4, IR2);
	 tDrv(8, IR3);
      join
      repeat(32) @(posedge CLK);
      fork 
	 tDrv(1, IR3);
	 tDrv(4, IR2);
	 tDrv(8, IR1);
      join
`else
      fork 
	 tDrv1(1);
	 tDrv2(4);
	 tDrv3(8);
      join
      repeat(32) @(posedge CLK);
      fork 
	 tDrv3(1);
	 tDrv2(4);
	 tDrv1(8);
      join
`endif
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
