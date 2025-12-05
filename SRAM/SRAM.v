module sram #(
  parameter data_width = 4,
  parameter mem_depth = 16,
  parameter add_width = 4
) (
  input wire clk,
  input wire rst,
  input wire chip_select,
  input wire write_enable,
  input wire read_enable,
  input wire [data_width-1:0] data_in,
  input wire [add_width-1:0] addr_location,
  output reg [data_width-1 :0 ] data_out

);
  reg [data_width-1:0] mem [0: mem_depth-1];
  integer i;
  always @(posedge clk or negedge rst)  begin
    if(!rst) begin
      for(i = 0; i < mem_depth; i = i+1)
        mem[i] <= {data_width{1'b0}};

      end
      else if (chip_select) begin
        if (write_enable) begin
          mem[addr_location] <= data_in;
        end

      else if (read_enable) begin
        data_out <= mem[addr_location];
      end
    end
    else begin
      data_out <= {data_width{1'b0}};
    end
  end
endmodule
