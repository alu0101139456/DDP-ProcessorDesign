`timescale 1 ns / 10 ps

module interruption_module (  input wire clk, reset, i_timer, s_finished,
                     output wire[9:0] dir_out, output wire s_interruption);

//Direcciones de subrutina      
parameter dir_timer = 10'b1000000000;

wire in, we;

assign in = s_finished ? 1'b0 : i_timer | s_interruption;
assign we = i_timer | s_finished;

ffd ffinterruption(clk, reset, in, we, s_interruption);

assign dir_out = i_timer & ~s_finished ? dir_timer : 10'bx;

endmodule