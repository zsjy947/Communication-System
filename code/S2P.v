`timescale 1ns / 1ps

module S2P(
  input wire clk,//ps_clk
  input wire rst,
  input wire din,
  output reg [13:0] hammingcode
    );
  //statement machine
    reg [1:0] current;
    reg [1:0] next;
    parameter IDLE = 2'b00;
    parameter START = 2'b01;
    parameter RECEIVE = 2'b11;
    
    reg [13:0] temp_reg;
    reg current_bit;
    reg [15:0] cnt;
    reg flag;//to flag if a data is received completely
    
    always@(posedge clk or posedge rst) begin
      if(rst) begin
       current <= IDLE;
      end
      else begin
       current <= next;
      end
    end
    
    always@(*) begin
     case(current)
      IDLE:
        if(current_bit) next<=START;
        else next<=IDLE;
      START:
        if(current_bit) next<=RECEIVE;
        else next<=IDLE;//receive '11' is the beginning of a data
      RECEIVE:begin
        if(cnt<13) begin
         next <= RECEIVE;//receive 13bit
        end
        else begin
         //receive the last bit
         next <= IDLE;
        end
      end
      default:next <= IDLE;
     endcase
    end
    
    always@(posedge clk or posedge rst) begin
     if(rst) begin
      current_bit <= 1'b0;
      temp_reg <= 14'b0;
      cnt <= 16'd0;
      flag <= 1'b0;
     end
     else begin
      /*
      if(current == RECEIVE) begin
          if(cnt < 13) begin
              cnt<=cnt+16'd1;
              current_bit <= din;
              temp_reg[13-cnt]<=current_bit;
          end
          else begin
              flag <= 1'b1;
              temp_reg[0] <= current_bit;
              cnt<=16'd0;
          end
      end
      */
      current_bit<=din;
      case(current)
        IDLE:begin
         flag<=1'b0;
         temp_reg<=14'b0;
        end
        START:begin
         flag<=1'b0;
         temp_reg<=14'b0;
        end
        RECEIVE:begin
         temp_reg[13-cnt]<=current_bit;
         cnt<=cnt+16'd1;
         flag<=1'b0;
         if(cnt==13) begin
          flag<=1'b1;
          cnt<=16'd0;
         end
        end
        default:begin
         flag<=1'b0;
         temp_reg<=14'b0;
        end
      endcase
      if(flag) begin
       hammingcode <= temp_reg;
      end
     end
    end
endmodule