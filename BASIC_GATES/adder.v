module half_adder(
  input a,
  input b,
  output carry,
  output sum
);
  assign carry = a & b;
  assign sum = a ^ b;

endmodule

module full_adder(
  input a,
  input b,
  input c,
  output carry,
  output sum 
);
  wire s1, c1, c2;

  half_adder HA_1 (
    .a(a),
    .b(b),
    .carry(c1),
    .sum(s1)
  );

  half_adder HA_2 (
    .a(s1),
    .b(c),
    .carry(c2),
    .sum(sum)
  );
  assign carry = c1 | c2;
endmodule
