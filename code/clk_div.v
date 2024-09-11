`timescale 1ns / 1ps

module clk_div(
   input wire sys_clk,
   input wire sys_clk_rst,
   output wire gen_clk,//clk to generate data
   output wire ps_clk,//clk to control p/s and s/p converter
   output wire fsk_clk//clk for modulate and demodulate
);
   //div paras, half a cycle
   parameter fsk_div=20000;
   parameter ps_div=fsk_div*16;
   parameter gen_div=ps_div*16;
   //div cnt
   reg [31:0] fsk_cnt;
   reg [31:0] ps_cnt;
   reg [31:0] gen_cnt;
   //clk reg
   reg gen_clk_reg;
   reg ps_clk_reg;
   reg fsk_clk_reg;
   
   assign gen_clk=gen_clk_reg;
   assign ps_clk=ps_clk_reg;
   assign fsk_clk=fsk_clk_reg;
   
   //synchronous reset, HIGH VALID
   always@(posedge sys_clk or posedge sys_clk_rst) begin
     if(sys_clk_rst) begin
       gen_cnt<=32'd0;
       ps_cnt<=32'd0;
       fsk_cnt<=32'd0;
       gen_clk_reg<=1'b0;
       ps_clk_reg<=1'b0;
       fsk_clk_reg<=1'b0;
     end
     else begin
       //gen_clk
       if(gen_cnt<gen_div-1) begin
         gen_cnt<=gen_cnt+32'd1;
         gen_clk_reg<=gen_clk_reg;
       end
       else begin
         gen_cnt<=32'd0;
         gen_clk_reg<=~gen_clk_reg;
       end
       //ps_clk
       if(ps_cnt<ps_div-1) begin
         ps_cnt<=ps_cnt+32'd1;
         ps_clk_reg<=ps_clk_reg;
       end
       else begin
         ps_cnt<=32'd0;
         ps_clk_reg<=~ps_clk_reg;
       end
       //fsk_clk
       if(fsk_cnt<fsk_div-1) begin
         fsk_cnt<=fsk_cnt+32'd1;
         fsk_clk_reg<=fsk_clk_reg;
       end
       else begin
         fsk_cnt<=32'd0;
         fsk_clk_reg<=~fsk_clk_reg;
       end
     end
   end
endmodule