`timescale 1ns / 1ps

module hamming_encode(
    input wire [7:0] bitstream,
    input wire clk,
    input wire rst,
    output wire [15:0] hammingcode
);    
    reg [2:0] check1;
    reg [2:0] check2;
    reg [15:0] hammingcode_reg;
    assign hammingcode=hammingcode_reg;
always @(*) begin
    check1[2] <= bitstream[7] ^ bitstream[6] ^ bitstream[5];
    check1[1] <= bitstream[7] ^ bitstream[6] ^ bitstream[4];
    check1[0] <= bitstream[7] ^ bitstream[5] ^ bitstream[4];
    
    check2[2] <= bitstream[3] ^ bitstream[2] ^ bitstream[1];
    check2[1] <= bitstream[3] ^ bitstream[2] ^ bitstream[0];
    check2[0] <= bitstream[3] ^ bitstream[1] ^ bitstream[0];
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        hammingcode_reg <= 16'd0;
    end
    else hammingcode_reg <= {2'b11,bitstream[7:4], check1[2:0], bitstream[3:0], check2[2:0]};
end

endmodule