`timescale 1ns / 1ps

module fsk_demodulate(
   input wire clk,
   input wire rst,
   input wire in,
   output reg out
 );

    reg [4:0] zeronum;
    reg [4:0] clknum;
    reg last,outreg;
    
    always@(posedge clk or posedge rst)
    begin
		if (rst) begin
			last<=0;
			zeronum<=0;
			clknum<=5'b0;
		end
		else begin
			clknum<=clknum+1;
			if(in!=last)
			begin
				zeronum<=zeronum+1;
			end
			if(clknum == 3) 
			begin
				if(zeronum > 1)
				begin
					outreg<=1;
				end
				else
				begin
					outreg<=0;
				end
			end 
			if(clknum == 15)
			begin
				clknum<=0;
				zeronum<=0;
				out<=outreg;
			end
			last<=in;
		end
    end
    
endmodule