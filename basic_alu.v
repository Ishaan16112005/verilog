module alu #(
  parameter width = 4
) (
  input [width -1 : 0] a,
  input [width -1 : 0] b,
  input [2:0] opcode,
  output reg [width -1 : 0] result,
  output reg zero,
  output reg carry,
  output reg overflow 
);
  localparam add = 3'b000;
  localparam sub = 3'b001;
  localparam And = 3'b010;
  localparam Xor = 3'b011;
  localparam Nand = 3'b100;
  localparam Or = 3'b101;
  localparam Nor = 3'b110;
  localparam Shift = 3'b111; //right shift logical

  reg [width : 0] temp_result; // for the carry detection

  always @(*) begin
    carry = 0;
    overflow = 0;
    temp_result = 0;
  
  
  case (opcode)
    add: begin
      temp_result = a + b;
      result = temp_result[width -1 : 0];
      carry = temp_result[width];
      overflow = (a[width -1] == b[width -1]) && (result[width -1] != a[width -1]);
    
    sub: begin
      temp_result = a-b;
      result = temp_result[width -1 : 0];
      carry = temp_result[width];
      overflow = (a[width - 1] != b[width -1] ) && (result[width -1 ] != a[width -1]);
    end
    And: begin
      result = a & b;
    end
    Xor : begin
      result = a ^ b;
    end
    Nand : begin
      result = ~(a & b);
    end
    Or : begin
      result = a | b;
    end
    Nor : begin
      result = ~(a | b);
    end
    Shift : begin
      result = a >> b[2:0] // shift by lower bits of b
    end
    default : begin
      result = {width{1'b0}};
    end
    end
  
  endcase
  
  zero = (result == 0);
  end
endmodule 
