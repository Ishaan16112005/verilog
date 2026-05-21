module fifo #(
    parameter width = 8,
    parameter depth = 4
) (
    input wire rst_n,
    input wire clk,
    input wire [width-1:0] data_in,
    input wire we,
    input wire rd_en,
    output reg [width-1:0] data_out,
    output wire full,
    output wire empty
);
    reg [width-1:0] mem [0:depth-1];
    integer i;
    localparam addr_width = $clog2(depth);
    reg [addr_width:0] rd_ptr;
    reg [addr_width:0] wr_ptr;


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin    
            wr_ptr <= 0;
            rd_ptr <= 0;
            data_out <= 0;       
            for (i = 0; i <= depth-1; i = i + 1) begin 
                mem[i] <= {width{1'b0}};
            end
        end else begin
            if (we && !full) begin 
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
    assign full = (wr_ptr[addr_width-1:0] == rd_ptr[addr_width-1:0]) && (wr_ptr[addr_width] != rd_ptr[addr_width]);
endmodule  
