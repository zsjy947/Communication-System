`timescale 1ns / 1ps

module P2S(
   input wire clk,//ps_clk
   input wire rst,
   input wire [15:0] din,
   output reg dout,
   output reg sig_valid
    );
    reg [3:0] cnt;
    //reg [15:0] din_reg;

    always@(posedge clk or posedge rst) begin
      if(rst) begin
        cnt <= 4'd0;
        dout <= 1'b0;
        sig_valid <= 1'b0;
      end
      else begin
      if(din[15:14]==2'b11) begin
        dout = din[15-cnt];
        sig_valid<=1'b1;
        if(cnt<=14) cnt <= cnt + 4'd1;
        else cnt <= 4'd0;
       end 
       else sig_valid<=1'b0;
      end
    end
    
endmodule