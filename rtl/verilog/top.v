module top 
  (
   input  CLK, RST1, IR1, IR2, IR3, SW,
   output STEP, DIR, EN
   );

   /*
    localparam async_input_size = 3;

    wire [async_input_size-1:0] rise, fall;

    edge_detect_array #(.N(async_input_size)) edge_detect_array_inst
    (
    .async_array( {IR1, IR2, IR3 })
    ,.clk       ( CLK            )
    ,.rise_array( rise           )
    ,.fall_array( fall           ));
    */
   wire   SP;

   Dir_test Dir_test0
     (
      .CLK  (  CLK    )         
      ,.RSTn(  RST1   )        
      ,.IR1 (  IR1    )        
      ,.IR2 (  IR2    )        
      ,.IR3 (  IR3    )        
      ,.SW  (  SW     )        
      ,.dir (  DIR    )        
      ,.en  (  EN     ));

   led_test #(.NUM_COUNT(1500)) led_test0
     (
      .clk    (  CLK   )
      ,.rst_n (  RST1  )
      ,.led   (  SP    ) 
      );

   Pulse_test #(.NUM_COUNT(50)) Pulse_test0
     (
      .CLK  (  CLK   )
      ,.RSTn(  RST1  )
      ,.SP  (  SP    )
      ,.STEP(  STEP  )
      );
   
endmodule // top
