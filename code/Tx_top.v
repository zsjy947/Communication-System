`timescale 1ns / 1ps
//include clk_div, sig_gen, hamming_encode, P2S, fsk_modulate
module Tx_top(
  input wire sys_clk,
  input wire sys_clk_rst,
  input wire rst,
  output wire [7:0] data_out,//data generated, show in LEDs
  output wire [15:0] hammingcode,
  output wire fsk_out//serial bit after modulating, show on oscilloscope
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
  
  //sig_gen
  sig_gen my_sig_gen(
    .clk(gen_clk),
    .rst(rst),
    .data_out(data_out)
  );
  
  //hamming encode
  hamming_encode my_hamming_encode(
    .bitstream(data_out),
    .clk(gen_clk),
    .rst(rst),
    .hammingcode(hammingcode)
  );
  
  //P2S converter
  wire dout;
  wire sig_valid;
  P2S my_P2S(
    .clk(ps_clk),
    .rst(rst),
    .din(hammingcode),
    .dout(dout),
    .sig_valid(sig_valid)
  );
  
  //fsk_modulate
  fsk_modulate my_fsk_modulate(
    .clk(fsk_clk),
    .rst(rst),
    .bit_in(dout),
    .sig_valid(sig_valid),
    .wave_out(fsk_out)
  );
  
endmodule