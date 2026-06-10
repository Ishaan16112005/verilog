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
    reg [1:0] priority_ptr; 

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
            priority_ptr <= 2'b00; 
            for (port_idx = 0; port_idx < ports; port_idx = port_idx + 1) begin 
                rd_en[port_idx] <= 0;
                data_out[port_idx] <= 0;
            end 
        end else begin 
            rd_en[0] <= 1'b0;
            rd_en[1] <= 1'b0;
            rd_en[2] <= 1'b0;
            rd_en[3] <= 1'b0;

            case (priority_ptr)
                2'b00: begin
                    if (!empty[0]) begin
                        case(fifo_data_out[0][7:6])
                            2'b00: data_out[0] <= fifo_data_out[0];
                            2'b01: data_out[1] <= fifo_data_out[0];
                            2'b10: data_out[2] <= fifo_data_out[0];
                            2'b11: data_out[3] <= fifo_data_out[0];
                        endcase
                        rd_en[0]     <= 1'b1;
                        priority_ptr <= 2'b01; 
                    end else if (!empty[1]) begin
                        case(fifo_data_out[1][7:6])
                            2'b00: data_out[0] <= fifo_data_out[1];
                            2'b01: data_out[1] <= fifo_data_out[1];
                            2'b10: data_out[2] <= fifo_data_out[1];
                            2'b11: data_out[3] <= fifo_data_out[1];
                        endcase
                        rd_en[1]     <= 1'b1;
                        priority_ptr <= 2'b10; 
                    end else if (!empty[2]) begin
                        case(fifo_data_out[2][7:6])
                            2'b00: data_out[0] <= fifo_data_out[2];
                            2'b01: data_out[1] <= fifo_data_out[2];
                            2'b10: data_out[2] <= fifo_data_out[2];
                            2'b11: data_out[3] <= fifo_data_out[2];
                        endcase
                        rd_en[2]     <= 1'b1;
                        priority_ptr <= 2'b11;
                    end else if (!empty[3]) begin
                        case(fifo_data_out[3][7:6])
                            2'b00: data_out[0] <= fifo_data_out[3];
                            2'b01: data_out[1] <= fifo_data_out[3];
                            2'b10: data_out[2] <= fifo_data_out[3];
                            2'b11: data_out[3] <= fifo_data_out[3];
                        endcase
                        rd_en[3]     <= 1'b1;
                        priority_ptr <= 2'b00;
                    end
                end

                
                2'b01: begin
                    if (!empty[1]) begin
                        case(fifo_data_out[1][7:6])
                            2'b00: data_out[0] <= fifo_data_out[1];
                            2'b01: data_out[1] <= fifo_data_out[1];
                            2'b10: data_out[2] <= fifo_data_out[1];
                            2'b11: data_out[3] <= fifo_data_out[1];
                        endcase
                        rd_en[1]     <= 1'b1;
                        priority_ptr <= 2'b10;
                    end else if (!empty[2]) begin
                        case(fifo_data_out[2][7:6])
                            2'b00: data_out[0] <= fifo_data_out[2];
                            2'b01: data_out[1] <= fifo_data_out[2];
                            2'b10: data_out[2] <= fifo_data_out[2];
                            2'b11: data_out[3] <= fifo_data_out[2];
                        endcase
                        rd_en[2]     <= 1'b1;
                        priority_ptr <= 2'b11;
                    end else if (!empty[3]) begin
                        case(fifo_data_out[3][7:6])
                            2'b00: data_out[0] <= fifo_data_out[3];
                            2'b01: data_out[1] <= fifo_data_out[3];
                            2'b10: data_out[2] <= fifo_data_out[3];
                            2'b11: data_out[3] <= fifo_data_out[3];
                        endcase
                        rd_en[3]     <= 1'b1;
                        priority_ptr <= 2'b00;
                    end else if (!empty[0]) begin
                        case(fifo_data_out[0][7:6])
                            2'b00: data_out[0] <= fifo_data_out[0];
                            2'b01: data_out[1] <= fifo_data_out[0];
                            2'b10: data_out[2] <= fifo_data_out[0];
                            2'b11: data_out[3] <= fifo_data_out[0];
                        endcase
                        rd_en[0]     <= 1'b1;
                        priority_ptr <= 2'b01;
                    end
                end

                
                2'b10: begin
                    if (!empty[2]) begin
                        case(fifo_data_out[2][7:6])
                            2'b00: data_out[0] <= fifo_data_out[2];
                            2'b01: data_out[1] <= fifo_data_out[2];
                            2'b10: data_out[2] <= fifo_data_out[2];
                            2'b11: data_out[3] <= fifo_data_out[2];
                        endcase
                        rd_en[2]     <= 1'b1;
                        priority_ptr <= 2'b11;
                    end else if (!empty[3]) begin
                        case(fifo_data_out[3][7:6])
                            2'b00: data_out[0] <= fifo_data_out[3];
                            2'b01: data_out[1] <= fifo_data_out[3];
                            2'b10: data_out[2] <= fifo_data_out[3];
                            2'b11: data_out[3] <= fifo_data_out[3];
                        endcase
                        rd_en[3]     <= 1'b1;
                        priority_ptr <= 2'b00;
                    end else if (!empty[0]) begin
                        case(fifo_data_out[0][7:6])
                            2'b00: data_out[0] <= fifo_data_out[0];
                            2'b01: data_out[1] <= fifo_data_out[0];
                            2'b10: data_out[2] <= fifo_data_out[0];
                            2'b11: data_out[3] <= fifo_data_out[0];
                        endcase
                        rd_en[0]     <= 1'b1;
                        priority_ptr <= 2'b01;
                    end else if (!empty[1]) begin
                        case(fifo_data_out[1][7:6])
                            2'b00: data_out[0] <= fifo_data_out[1];
                            2'b01: data_out[1] <= fifo_data_out[1];
                            2'b10: data_out[2] <= fifo_data_out[1];
                            2'b11: data_out[3] <= fifo_data_out[1];
                        endcase
                        rd_en[1]     <= 1'b1;
                        priority_ptr <= 2'b10;
                    end
                end

                
                2'b11: begin
                    if (!empty[3]) begin
                        case(fifo_data_out[3][7:6])
                            2'b00: data_out[0] <= fifo_data_out[3];
                            2'b01: data_out[1] <= fifo_data_out[3];
                            2'b10: data_out[2] <= fifo_data_out[3];
                            2'b11: data_out[3] <= fifo_data_out[3];
                        endcase
                        rd_en[3]     <= 1'b1;
                        priority_ptr <= 2'b00;
                    end else if (!empty[0]) begin
                        case(fifo_data_out[0][7:6])
                            2'b00: data_out[0] <= fifo_data_out[0];
                            2'b01: data_out[1] <= fifo_data_out[0];
                            2'b10: data_out[2] <= fifo_data_out[0];
                            2'b11: data_out[3] <= fifo_data_out[0];
                        endcase
                        rd_en[0]     <= 1'b1;
                        priority_ptr <= 2'b01;
                    end else if (!empty[1]) begin
                        case(fifo_data_out[1][7:6])
                            2'b00: data_out[0] <= fifo_data_out[1];
                            2'b01: data_out[1] <= fifo_data_out[1];
                            2'b10: data_out[2] <= fifo_data_out[1];
                            2'b11: data_out[3] <= fifo_data_out[1];
                        endcase
                        rd_en[1]     <= 1'b1;
                        priority_ptr <= 2'b10;
                    end else if (!empty[2]) begin
                        case(fifo_data_out[2][7:6])
                            2'b00: data_out[0] <= fifo_data_out[2];
                            2'b01: data_out[1] <= fifo_data_out[2];
                            2'b10: data_out[2] <= fifo_data_out[2];
                            2'b11: data_out[3] <= fifo_data_out[2];
                        endcase
                        rd_en[2]     <= 1'b1;
                        priority_ptr <= 2'b11;
                    end
                end
            endcase
        end
    end
endmodule
