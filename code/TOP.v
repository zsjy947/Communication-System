`timescale 1ns / 1ps

//remember to reset long enough before everything!
//include Tx_top and Rx_top
module TOP(
  input wire sys_clk,
  input wire sys_clk_rst,
  input wire rst,
  //input wire bit_in,//demodulate bit put into the module
  output wire bit_out,//modulate bit to transmmit
  output wire [7:0] data_trans,// 8bit data generated
  output wire [7:0] data_recev//8bit data receive
);

  wire [15:0] en_hamming_code;//16bit after hamming_encode, MSB 2'b11
  wire [13:0] de_hamming_code;//14bit after S2P
  wire bit_in;
  
  assign bit_in = bit_out;

//data generate and transmmit
Tx_top my_Tx_top(
  .sys_clk(sys_clk),
  .sys_clk_rst(sys_clk_rst),
  .rst(rst),
  .data_out(data_trans),//show on LEDs
  .hammingcode(en_hamming_code),
  .fsk_out(bit_out)//show in oscilloscope
);

//data receive
Rx_top my_Rx_top(
  .sys_clk(sys_clk),
  .sys_clk_rst(sys_clk_rst),
  .rst(rst),
  .bit_in(bit_in),//show in oscilloscope
  .hammingcode(de_hamming_code),
  .sig_out(data_recev)//show on LEDs
);
endmodule
