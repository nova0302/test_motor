module edge_detect_array 
  #(parameter N=3)
   (
    input [N-1:0]  async_array,
    input 	   clk,
    output [N-1:0] rise_array,
    output [N-1:0] fall_array
    ) ;
   genvar 	   i;
   generate
      for(i=0; i<N; i=i+1)begin : edge_detect_gen
	 edge_detect edge_detect_inst
	    (
	     .async_sig(async_array[i])
	     ,.clk(clk)
	     ,.rise(rise_array[i])
	     ,.fall(fall_array[i]));
	   end
   endgenerate
   


endmodule // edge_detect_array
