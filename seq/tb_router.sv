module tb_router();
    parameter width = 8;
    parameter depth = 8;
    parameter ports = 4;
    reg clk;
    reg rst_n;
    reg [width-1:0] data_in [0:ports-1];
    reg wr_en [0:ports-1];
    wire full [0:ports-1];
    wire [width-1:0] data_out [0:ports-1];
    router uut(
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .wr_en(wr_en),
        .full(full),
        .data_out(data_out)
    );

    always #5 clk = ~clk;

    integer i;

    initial begin
        clk = 0;
        rst_n = 1;
        for (i =0 ; i < ports; i = i + 1) begin 
            wr_en[i] = 0;
            data_out[i] = 0;
        end
    end

    initial begin 
        $dumpfile("router.vcd");
        $dumpvars(0, tb_router);
        #10;
        rst_n = 0;
        #10;
        rst_n = 1;
        #10;
        wr_en[0] =1;
        #10; 
        data_in[0] = 8'b01011010;
        #10;
        data_in[0] = 8'b00101100;
        #10;
        data_in[0] = 8'b11111111;
        #10;
        data_in[0] = 8'b10101010;
        #10;
        wr_en[0] = 0;
        data_in[0] = 0;
        #100;
        $monitor("Time: %0t | rst: %b | wr: %b | rd: %b | data_in: %8b | data_out: %8b", 
                  $time, rst_n, wr_en, rd_en, data_in, data_out);
        #40;
        $display("simulation finished");
        $finish;
    end 
endmodule
//only one fifo has been utilized for the testbench 
