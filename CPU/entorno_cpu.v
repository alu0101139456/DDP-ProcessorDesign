`timescale 1 ns / 10 ps

module entorno_cpu( input wire clk, reset, input wire [3:0] buttons, input wire [9:0] switches, output wire [7:0] led_v, output wire [9:0] led_r);

wire i_timer, we_o; 
wire [7:0] in_p0, in_p1, in_p2, in_p3, out_p0, out_p1, out_p2, out_p3; // puertos de entrada
wire [1:0] hilo_in, hilo_out;

cpu cpu_final(clk, reset, i_timer, in_p0, in_p1, in_p2, in_p3, we_o, hilo_in, hilo_out, out_p0, out_p1, out_p2, out_p3);


timer TIMER (clk, reset, i_timer);

decoder control_io (clk, reset, hilo_in, hilo_out, buttons, switches, out_p0, out_p1, out_p2, out_p3, we_o, in_p0, in_p1, in_p2, in_p3, led_v, led_r);


endmodule

// module cpu(input wire clk, reset, i_timer, input wire [7:0] in_p0, in_p1, in_p2, in_p3, output wire we_o, output wire [7:0] out_p0, out_p1, out_p2, out_p3);


module decoder(input wire clk, reset, input wire [1:0] hilo_in, hilo_out, input wire [3:0] buttons, input wire [9:0] switches, input wire [7:0] out_p0, out_p1, out_p2, out_p3, input wire we_o, output wire [7:0] in_p0, in_p1, in_p2, in_p3, output wire [7:0] led_v, output wire [9:0] led_r);

// in_p0 [3:0] = ~buttons[3:0]

// in_p1 [4:0] = switches [4:0]
// in_p2 [4:0] = switches [9:5]


// leds_v [7:0] = out_p0 [7:0]

// leds_r [4:0] = out_p1 [4:0]
// leds_r [9:5] = out_p2 [4:0]

assign in_p0[3:0] = ~buttons[3:0];

assign in_p1[4:0] = (hilo_in == 2'b01) || (hilo_in == 2'b11) || (hilo_in == 2'b0) ? switches[4:0] : 4'b0;
assign in_p2[4:0] = (hilo_in == 2'b10) || (hilo_in == 2'b11) || (hilo_in == 2'b0) ? switches[9:5] : 4'b0;

registroWe #(10) leds_r (clk, reset, we_o, hilo_out, out_p2[4:0], out_p1[4:0], led_r);
registroWe #(8) leds_v (clk, reset, we_o, 2'b11, out_p0[7:4], out_p0[3:0], led_v);


// uc => output ... we_o = 1


endmodule



// flag hi, flag lo
// uc => output_lo  ===  hi = 0  lo = 1
// uc => output_hi  ===  hi = 1  lo = 0
// uc => output  ===  hi = 1  lo = 1

// decoder => if (hi & ~lo) (usas out_p1[7:4] y out_p2[7:4]) 