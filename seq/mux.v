module mux2_1(
    input wire a,
    input wire b,
    input wire cs,
    output wire y
);
    assign y = cs ? a : b;
endmodule 
