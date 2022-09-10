`timescale 1 ns / 10 ps

module entorno_cpu( input wire clk, reset, input wire [3:0] buttons, input wire [9:0] switches, output wire [7:0] led_v, output wire [9:0] led_r);

wire i_timer, we_o; 
wire [7:0] in_p0, in_p1, in_p2, in_p3, out_p0, out_p1, out_p2, out_p3, ine_p0, ine_p1, ine_p2, ine_p3; // puertos de entrada
wire [1:0] hilo_in, hilo_out, io_port;


cpu cpu_final(clk, reset, i_timer, in_p0, in_p1, in_p2, in_p3, ine_p0, ine_p1, ine_p2, ine_p3, we_o, hilo_in, hilo_out, io_port, out_p0, out_p1, out_p2, out_p3);


timer #(25000000) TIMER (clk, reset, i_timer);
// 25000000 50MHz

control_io control_es (clk, reset, hilo_in, hilo_out, io_port, buttons, switches, out_p0, out_p1, out_p2, out_p3, we_o, in_p0, in_p1, in_p2, in_p3, ine_p0, ine_p1, ine_p2, ine_p3, led_v, led_r);



endmodule
