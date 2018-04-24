module top 
  (
   input      CLK, RSTn, IR1, IR2, IR3, SW,
   output reg dir, en
   );

   localparam async_input_size = 3;

   wire [async_input_size-1:0] rise, fall;

   edge_detect_array #(.N(async_input_size)) edge_detect_array_inst
     (
      .async_array( {IR1, IR2, IR3 })
      ,.clk       ( CLK            )
      ,.rise_array( rise           )
      ,.fall_array( fall           ));

   Dir_test Dir_test0
     (
      .CLK  (  CLK    )         
      ,.RSTn(  RSTn   )        
      ,.IR1 (  IR1    )        
      ,.IR2 (  IR2    )        
      ,.IR3 (  IR3    )        
      ,.SW  (  SW     )        
      ,.dir (  dir    )        
      ,.en  (  en     ));
   
endmodule // top
