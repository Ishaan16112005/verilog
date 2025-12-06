`timescale 1ns/1ps
module tb_alu;
  localparam ADD = 2'b00;
  localparam SUB = 2'b01;
  localparam MUL = 2'b10;
  localparam DIV = 2'b11;

  reg [3:0]a;
  reg [3:0]b;
  reg [1:0]opcode;
  wire overflow, zero, carry;
  wire [3:0] data_out;
  wire [7:0] product; //only for multiplication
  
  alu uut (
    .a(a),
    .b(b),
    .opcode(opcode),
    .overflow(overflow),
    .zero(zero),
    .carry(carry),
    .data_out(data_out),
    .product(product)
  );
  
  integer i;
  reg [4:0]expected_result;
  reg [3:0]expected_data_out;
  reg expected_overflow;
  reg expected_carry;
  reg expected_zero;
  reg [7:0] expected_product;

  initial begin
    $display("----------------");
    $display("RANDOM NUMBERS WILL NOW BE USED TO TEST THE DESIGN");
    $display(" --------------- ");
    for (i = 0; i < 16; i = i + 1) begin //total of 16 loops 
      a = $random % 16;
      b = $random % 16;
      opcode = $random % 4;
      #10;

      expected_product = 0;
      expected_zero = 0;
      expected_carry = 0;
      expected_result = 0;
      expected_overflow = 0;
      expected_data_out = 0;

      case(opcode) 
        ADD : begin
          expected_result = {1'b0, a} + {1'b0, b};
          expected_carry = expected_result[4];
          expected_data_out = expected_result[3:0];
          if ((a[3] == b[3]) && (expected_data_out[3]!= a[3]) ) begin
            expected_overflow = 1;
          end
        end

        SUB : begin
          expected_result = {1'b0, a} - {1'b0, b};
          expected_carry = expected_result[4]; // this is for borrow
          expected_data_out = expected_result[3:0];
          if ((a[3]!=b[3]) && (expected_data_out[3] != a[3]) ) begin
            expected_overflow = 1;
          end
        end

        MUL : begin
          expected_product = a * b;
        end

        DIV : begin
          if (b == 0) begin
            expected_data_out = 0;
          end
          else begin
            expected_data_out = a/b;
          end
        end
      endcase
      expected_zero = ((expected_data_out == 0) && (expected_product == 0) );
      
      if (expected_data_out !== data_out || expected_product !== product || expected_zero !== zero || expected_overflow !== overflow || expected_carry !== carry) begin
        $display("THERE WAS AN ERROR");
        $stop;
      end else begin
        $display(" %4t | %b  | %d %d | %d %d | PASS ",
        $time, opcode, $signed(a), $signed(b), 
        (opcode == MUL) ? product : data_out,
        (opcode == MUL) ? expected_product : expected_data_out);
        
      end 
    end
    $display("ALL THE TESTS ARE CLEARED");
    $finish;
  end 
  
endmodule
    
    









