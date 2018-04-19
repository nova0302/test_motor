
module edge_detect 
  (
   input      async_sig,
   input      clk,
   output reg rise,
   output reg fall
   );

   reg [2:0]  resync;

   always @(posedge clk)
     begin
	// detect rising and falling edges.
	rise <= resync[1] & ~resync[2];
	fall <= resync[2] & ~resync[1];
	// update history shifter.
	resync <= {resync[1:0], async_sig };
     end

endmodule
