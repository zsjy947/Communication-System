`timescale 1ns / 1ps

module hamming_decode(
    input [13:0] code,
    input clk,
    input rst,
    output reg [7:0] bitstream
    );
    reg [2:0] check1;
    reg [2:0] check2;
 
always @(*) begin
    check1[2] <= code[13] ^ code[12] ^ code[11] ^ code[9];
    check1[1] <= code[13] ^ code[12] ^ code[10] ^ code[8];
    check1[0] <= code[13] ^ code[11] ^ code[10] ^ code[7];
    check2[2] <= code[6] ^ code[5] ^ code[4] ^ code[2];
    check2[1] <= code[6] ^ code[5] ^ code[3] ^ code[1];
    check2[0] <= code[6] ^ code[4] ^ code[3] ^ code[0];
end

always @(posedge clk or posedge rst) begin
     if (rst) begin
       bitstream <= 4'd0;
     end
     else begin
        case(check1)
            3'b111: bitstream[7:4] <= {~code[13], code[12:10]};
            3'b110: bitstream[7:4] <= {code[13], ~code[12], code[11:10]};
            3'b101: bitstream[7:4] <= {code[13:12], ~code[11], code[10]};
            3'b011: bitstream[7:4] <= {code[13:11], ~code[10]};
            default: bitstream[7:4] <= code[13:10];
        endcase
        case(check2)
            3'b111: bitstream[3:0] <= {~code[6], code[5:3]};
            3'b110: bitstream[3:0] <= {code[6], ~code[5], code[4:3]};
            3'b101: bitstream[3:0] <= {code[6:5], ~code[4], code[3]};
            3'b011: bitstream[3:0] <= {code[6:4], ~code[3]};
            default: bitstream[3:0] <= code[6:3];
        endcase
     end
end

endmodule