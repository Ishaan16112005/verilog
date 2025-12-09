`timescale 1ns/1ps
module tb_test;
  parameter data_width = 4;
  parameter mem_depth = 16;
  parameter add_width = 4;

  reg clk, rst;
  reg cs, we, re;
  reg [data_width-1:0] data_in;
  reg [add_width-1:0] addr_location;
  wire [data_width-1:0] data_out;

  sram #(
    .data_width(data_width),
    .mem_depth(mem_depth),
    .add_width(add_width)
  ) uut(
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .write_enable(we),
    .read_enable(re),
    .chip_select(cs),
    .addr_location(addr_location),
    .data_out(data_out)
  );
  always #5 clk = ~clk;
  reg [data_width-1:0] expected [0:mem_depth-1];
  integer i;
  initial begin
    re = 0;
    clk = 0;
    rst = 0;
    we = 0;
    cs = 0;
    #10;
    rst = 1;
    cs = 1;

    cs = 1;
    $display("The Write operations");
    for (i = 0; i < mem_depth; i = i + 1) begin
      @(posedge clk)
      addr_location = i;

      data_in = $random % (1<<4);
      expected[i] = data_in;
      we = 1;
      re = 0;
      $display("The data %0d has been added to the location %0d", data_in, addr_location);
    end
    we = 0;
    $display("The Read operations ");
    for (i = 0; i < mem_depth; i = i+1) begin
      addr_location = i;
      we = 0;
      re = 1;
      @(posedge clk);
      if (data_out != expected[i]) begin
        $display("error");
      end else begin
        $display(" OK, The data %0d at the address %0d ", data_out, i);
      end
    end
    $display("TEST COMPLETED");
    $finish;
  end
  endmodule
