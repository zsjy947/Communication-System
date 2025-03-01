`timescale 1ns / 1ps

module fsk_modulate (
    input wire clk,
    input wire rst,
    input wire bit_in,
    input wire sig_valid,
    output wire wave_out
);
    reg [3:0] cnt;
    reg wave_h, wave_l;

    always @(posedge clk or posedge rst) begin
		if (rst) begin
			cnt <= 4'b0000;
			wave_h <= 0;
			wave_l <= 0;
		end
		else begin
		 if(sig_valid) begin
			
			if(cnt == 4'b0111) begin
				wave_h <= ~wave_h;
				wave_l <= ~wave_l;

				cnt <= 4'b0000;
			end
			else if(~(cnt%4)) begin
				wave_h <= ~wave_h;
			end
			cnt <= cnt + 1;
		 end
		 else cnt<=4'b0;
		end
    end

    assign wave_out = bit_in?wave_h:wave_l;
    
endmodule
