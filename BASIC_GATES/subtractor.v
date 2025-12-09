module half_subtractor(
  input a,
  input b,
  output diff, //difference between the two numbers
  output bor   //borrow 
);
  assign diff = a ^ b;
  assign bor = (~a) & b;
endmodule

module full_subtractor (
  input a,
  input b,
  input c,
  output diff,
  output bor 
);
  wire d1, b1, b2;
  half_subtractor HS_1 (
    .a(a),
    .b(b),
    .diff(d1),
    .bor(b1)
  );

  half_subtractor HS_2 (
    .a(d1),
    .b(c),
    .diff(diff),
    .bor(b2)
  );
  assign bor = b1 | b2;
endmodule
