module alu(
  input wire [3:0] a,
  input wire [3:0] b,
  input wire [1:0] opcode,
  output reg overflow,
  output reg zero,
  output reg [3:0] data_out,
  output reg carry,
  output reg [7:0] product 
);
  localparam ADD = 2'b00;
  localparam SUB = 2'b01;
  localparam MUL = 2'b10;
  localparam DIV = 2'b11;

  reg [4:0] result;

  always @(*) begin
    carry = 0;
    overflow = 0;
    data_out = 0;
    product = 0;
    result = 0;

    case (opcode)
      ADD : begin
        result = {1'b0, a} + {1'b0,b};
        carry = result[4];
        data_out = result[3:0];
        if ((a[3] == b[3]) && (data_out[3] != a[3]) ) begin
          overflow = 1;
        end
      end

      SUB : begin
        result = {1'b0,a} - {1'b0, b};
        carry = result[4];
        data_out = result[3:0] ;
        if ((a[3] != b[3]) && (data_out[3] != a[3]) ) begin
          overflow = 1;
        end
      end
      
      MUL : begin
        product = a * b;
      end

      DIV : begin
        if (b == 4'b0000) begin
          data_out = 0;
        end
        else begin
          data_out = a/b;
        end
      end

      default : begin
        product = 4'b0000;
        data_out = 4'b0000;
      end
    endcase
    zero = (data_out == 0 && product == 0);
  end  
endmodule


