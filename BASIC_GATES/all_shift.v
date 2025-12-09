module dynamic_shifters#(
  parameter width = 8
) (
  input signed [width-1 : 0] a,
  input [1:0] b,
  output signed [width-1 : 0] r_shift,
  output signed [width-1 : 0] l_shift 
);
  assign r_shift = a >>> b;
  assign l_shift = a <<< b;
endmodule

// the above code is for arithmetic shift that preserves the sign


 /*dynamic_shifters #(.width(8)) u_shift (
 / ...........
)*/
// lines 16, 17 and 18 are for the test bench part with the dynamic input
