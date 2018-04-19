`define SV
`timescale 1ns/10ps
module  Dir_test
  (
   input      CLK, RSTn, IR1, IR2, IR3, SW,
   output reg dir, en
   );
   reg 	      IR1Dly, IR2Dly, IR3Dly;

   localparam FW = 1'b1, BW = 1'b0;

`ifdef SV
   typedef enum reg [1:0] {sHOME = 2'b00, sFW = 2'b01, sBW = 2'b10, sEND = 2'b11}theState;
   theState  State, nState;
`else
   localparam sHOME = 2'b00, sFW = 2'b01, sBW = 2'b10, sEND = 2'b11;
   reg [1:0] 		  State, nState;
`endif
   localparam async_input_size = 3;
   wire [async_input_size-1:0] rise, fall;

   edge_detect_array #(.N(async_input_size)) edge_detect_array_inst
     (
      .async_array( {IR1, IR2, IR3 })
      ,.clk       ( CLK            )
      ,.rise_array( rise           )
      ,.fall_array( fall           ));

   wire 		       start = fall[0];
   wire 		       end_ir = fall[2];
   wire 		       toHome = rise[0];

   // State Regster
   always@(posedge CLK, negedge RSTn)
     if(!RSTn) 
       State <= sHOME;
     else 
       State <= nState;

   // Next State Comb Logic
   always@*
     begin
	nState = State; // Default 
	case(State)
	  sHOME: 
	    if(start)
	      nState = sFW;
	  sFW:
	    if(end_ir)
	      nState = sEND;
	  sEND:
	    nState = sBW;
	  sBW:
	    if(end_ir)
	      nState = sHOME;
	endcase // case (State)
     end

   always@(posedge CLK, negedge RSTn)
     if(!RSTn)
       dir <= FW;
     else
       if(State == sEND)
	 dir <= BW;
   
endmodule // Dir_test

