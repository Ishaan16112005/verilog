module fifo #(
    parameter width = 8,
    parameter depth = 8
) (
    input wire clk,
    input wire rst_n,
    input wire [width-1:0] data_in,
    input wire wr_en,
    input wire rd_en,
    output reg [width-1:0] data_out,
    output wire empty,
    output wire full
);

    reg [width-1:0] mem [0: depth-1];
    localparam addr_width = $clog2(depth);
    reg [addr_width:0] rd_ptr;
    reg [addr_width:0] wr_ptr;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            data_out <= 0;
        end
        else begin 
            if (wr_en && !full) begin
                mem[wr_ptr[addr_width-1:0]] <= data_in;
                wr_ptr <= wr_ptr + 1'b1;
            end 
            if (rd_en && !empty) begin 
                data_out <= mem[rd_ptr[addr_width-1:0]];
                rd_ptr <= rd_ptr + 1'b1;
            end
        end
    end

    assign empty = (wr_ptr == rd_ptr);
    assign full = ((wr_ptr[addr_width-1:0] == rd_ptr[addr_width-1:0]) && wr_ptr[addr_width] != rd_ptr[addr_width] );
endmodule
    
