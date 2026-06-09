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
    

module router #(
    parameter width = 8,
    parameter depth = 8,
    parameter ports = 4
) (
    input wire clk,
    input wire rst_n,
    input wire [width-1:0] data_in [0:ports-1],
    input wire             wr_en [0:ports-1],
    output wire             full [0:ports-1],
    output reg [width-1:0] data_out [0:ports-1]
);

    wire empty[0:ports-1];
    wire [width-1:0] fifo_data_out [0:ports-1];
    reg rd_en [0:ports-1];

    genvar i;

    generate 
        for (i = 0; i < ports; i = i + 1) begin : input_fifo
            fifo #(
                .width(width),
                .depth(depth)
            ) fifo_inst (
                .clk(clk),
                .rst_n(rst_n),
                .data_in(data_in[i]),
                .wr_en(wr_en[i]),
                .rd_en(rd_en[i]),
                .data_out(fifo_data_out[i]),
                .empty(empty[i]),
                .full(full[i])
            );
        end 
    endgenerate

    integer port_idx;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin 
            for (port_idx = 0; port_idx < ports; port_idx = port_idx + 1) begin 
                rd_en[port_idx] <= 0;
                data_out[port_idx] <= 0;
            end 
        end else begin 
            rd_en[0] <= 1'b0;
            rd_en[1] <= 1'b0;
            rd_en[2] <= 1'b0;
            rd_en[3] <= 1'b0;
            if (!empty[0]) begin
                case(fifo_data_out[0] [7:6]) 
                    2'b00: data_out[0] <= fifo_data_out[0];
                    2'b01: data_out[1] <= fifo_data_out[0];
                    2'b10: data_out[2] <= fifo_data_out[0];
                    2'b11: data_out[3] <= fifo_data_out[0];
                endcase
                rd_en[0] <= 1'b1;

            end else if (!empty[1]) begin
                case(fifo_data_out[1] [7:6])
                    2'b00: data_out[0] <= fifo_data_out[1];
                    2'b01: data_out[1] <= fifo_data_out[1];
                    2'b10: data_out[2] <= fifo_data_out[1];
                    2'b11: data_out[3] <= fifo_data_out[1];
                endcase
                rd_en[1] <= 1'b1;

            end else if (!empty[2]) begin 
                case(fifo_data_out[2] [7:6]) 
                    2'b00: data_out[0] <= fifo_data_out[2];
                    2'b01: data_out[1] <= fifo_data_out[2];
                    2'b10: data_out[2] <= fifo_data_out[2];
                    2'b11: data_out[3] <= fifo_data_out[2];
                endcase
                rd_en[2] <= 1'b1;

            end else if (!empty[3]) begin
                case(fifo_data_out[3] [7:6])
                    2'b00: data_out[0] <= fifo_data_out[3];
                    2'b01: data_out[1] <= fifo_data_out[3];
                    2'b10: data_out[2] <= fifo_data_out[3];
                    2'b11: data_out[3] <= fifo_data_out[3];
                endcase
                rd_en[3] <= 1'b1;

            end
        end
    end
endmodule
//starvation can be an issue



