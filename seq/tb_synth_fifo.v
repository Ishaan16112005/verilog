`timescale 1ns/1ps
module tb_fifo();
    parameter width = 8;
    parameter depth = 8;
    reg clk;
    reg rst_n;
    reg [width-1:0] data_in;
    reg wr_en;
    reg rd_en;
    wire [width-1:0] data_out;
    wire empty;
    wire full;
    fifo uut (
        .clk(clk), 
        .rst_n(rst_n),
        .data_in(data_in),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    always #10 clk = ~clk;

    initial begin 
        clk = 0;
        wr_en =0;
        rd_en = 0;
        data_in = 0;
    end

    initial begin 
        $dumpfile("xyz.vcd");
        $dumpvars(0, tb_fifo);
        $monitor("Time: %0t | rst: %b | wr: %b | rd: %b | data_in: %8b | data_out: %8b | empty: %b | full: %b", 
                  $time, rst_n, wr_en, rd_en, data_in, data_out, empty, full);
        rst_n = 0;
        #20;
        rst_n = 1;
        #20;
        wr_en = 1;
        data_in = 8'b1;
        #20;
        data_in = 8'b01001011;
        #20;
        data_in = 8'b01101011;
        #20;
        wr_en = 0;
        rd_en = 1;
        #20;
        #20;
        #20;
        rd_en = 0;
        #40;
        $finish;
        $display("simulation over");
    end
endmodule
