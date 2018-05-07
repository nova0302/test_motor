`define SV
`timescale 1ns/10ps
module  Dir_test
  (
   input      CLK, RSTn, IR1, IR2, IR3, SW,
   output     en,
   output reg dir
   );

   localparam FW = 1'b1, BW = 1'b0;

`ifdef SV
   typedef enum reg [3:0] {sHOME = 4'd0, 
			   sFW1 , sFW2 , sFW3 , sFW4 , sFW5 , 
			   sBW1 , sBW2 , sBW3 , sBW4 , sBW5 , 
			   sEND, sDLY}theState;
   theState  State, nState;
`else
   localparam sHOME = 4'd0, 
     sFW1 = 4'd1, sFW2 = 4'd2, sFW3 = 4'd3, sFW4 = 4'd4, sFW5 = 4'd5, 
     sBW1 = 4'd6, sBW2 = 4'd7, sBW3 = 4'd8, sBW4 = 4'd9, sBW5 = 4'd10, 
     sEND = 4'd11;
   reg [3:0] 		  State, nState;
`endif

   localparam async_input_size = 3;

   reg[20:0] dly_cnt;
   wire [async_input_size-1:0] rise, fall;

   edge_detect_array #(.N(async_input_size)) edge_detect_array_inst
     (
      .async_array( {IR1, IR2, IR3 })
      ,.clk       ( CLK            )
      ,.rise_array( rise           )
      ,.fall_array( fall           ));

   assign en = (State != sHOME); 

   always@(posedge CLK, negedge RSTn)
     if(!RSTn)
       dir <= FW;
     else
       if(State == sEND)
	 dir <= BW;

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
	  sHOME: if(fall[2]) nState = sFW1;
	  sFW1:  if(fall[1]) nState = sFW2;
	  sFW2:  if(fall[0]) nState = sFW3;
	  sFW3:  if(rise[2]) nState = sFW4;
	  sFW4:  if(rise[1]) nState = sFW5;
	  sFW5:  if(rise[0]) nState = sEND;
	  sEND:  if(fall[0]) nState = sDLY;
	  sDLY:  if(dly_cnt[20]) nState = sBW1;
	  sBW1:  if(fall[1]) nState = sBW2;
	  sBW2:  if(fall[2]) nState = sBW3;
	  sBW3:  if(rise[0]) nState = sBW4;
	  sBW4:  if(rise[1]) nState = sBW5;
	  sBW5:  if(rise[2]) nState = sHOME;
	endcase // case (State)
     end
   
   always@(posedge CLK, posedge RSTn)
     if(!RSTn)
       dly_cnt <= 0;
     else
       if(State == sDLY)
	 dly_cnt <=dly_cnt + 1;
       else
	 dly_cnt <= 0;



   
endmodule // Dir_test

