 module sram #( 
  parameter data_width = 8,
  parameter mem_width = 1024,
  parameter addr_width = 10
) (
  input wire clk,
  input wire rst_n,
  input wire oe,
  input wire we,
  input wire cs,
  input wire [data_width-1:0] data_in,
  input wire [addr_witdh-1: 0] addr,
  output reg [data_width-1 : 0] data_out
);
  reg [data_width -1 : 0] mem [0 : mem_width-1];
  integer i;
  always @(posedge clk or negedge rst_n)  begin
    if (!rst_n) begin 
      for (i = 0 ; i < mem_width ; i = i + 1) 
        mem[i] <= {data_width{1'b0}};
      data_out <= {data_width{1'b0}};

    
    end else if (cs) begin 
      if (we) begin 
        mem[addr] <= data_in;
      end
      else if (oe)  begin
        data_out <= mem[addr];
      end else  begin
        data_out  <= {data_width{1'bz}};
        
      end 
      // if the chip is  not selected

    end else  begin
      data_out <= {data_width{1'bz}};
    end
  end
endmodule 
    
