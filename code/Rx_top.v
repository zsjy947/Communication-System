`timescale 1ns / 1ps
//include clk_div, fsk_demodulate, S2P, hamming_decode
module Rx_top(
  input wire sys_clk,
  input wire sys_clk_rst,
  input wire rst,
  input wire bit_in,//fsk demodulate
  output wire [13:0] hammingcode,
  output wire [7:0] sig_out
);

 //clk_div
  wire gen_clk;
  wire ps_clk;
  wire fsk_clk;
  clk_div my_clk_div(
   .sys_clk(sys_clk),
   .sys_clk_rst(sys_clk_rst),
   .gen_clk(gen_clk),
   .ps_clk(ps_clk),
   .fsk_clk(fsk_clk)
  );
  
  //fsk demodulate
  wire de_fsk_out;
  fsk_demodulate my_fsk_demodulate(
    .clk(fsk_clk),
    .rst(rst),
    .in(bit_in),
    .out(de_fsk_out)
  );
  
  //S2P
  S2P my_S2P(
    .clk(ps_clk),
    .rst(rst),
    .din(de_fsk_out),
    .hammingcode(hammingcode)
  );
  
  //hamming decode
  hamming_decode my_hamming_decode(
    .code(hammingcode),
    .clk(gen_clk),
    .rst(rst),
    .bitstream(sig_out)
  );
endmodule