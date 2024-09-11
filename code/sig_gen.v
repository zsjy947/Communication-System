`timescale 1ns / 1ps

module sig_gen(
  input wire clk,
  input wire rst,
  output wire [7:0] data_out
);
  //test, gen data cycle
  reg [7:0] data_out_reg;
  assign data_out=data_out_reg;
  always@(posedge clk or posedge rst) begin
   if(rst) begin
    data_out_reg<=8'd0;
   end
   else begin
    data_out_reg<=data_out_reg+8'd1;
   end
  end
endmodule