module freq_div(
    input wire clk,
    input wire rst_n,
    output wire clk_div2,
    output wire clk_div4,
    output wire clk_div8,
    output wire clk_div16
);

    reg [7:0] counter;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter<=8'b0;
        end else begin
            counter<= counter  + 1'b1;
        end
    end 

    assign clk_div2 = counter[0];
    assign clk_div4 = counter[1];
    assign clk_div8 = counter[2];
    assign clk_div16 = counter[3];
endmodule
