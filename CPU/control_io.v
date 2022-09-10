`timescale 1 ns / 10 ps

module control_io(input wire clk, reset, input wire [1:0] hilo_in, hilo_out, io_port, input wire [3:0] buttons, input wire [9:0] switches, input wire [7:0] out_p0, out_p1, out_p2, out_p3, input wire we_o, output wire [7:0] in_p0, in_p1, in_p2, in_p3, ine_p0, ine_p1, ine_p2, ine_p3, output wire [7:0] led_v, output wire [9:0] led_r);

wire [4:0] out_led_rhi, out_led_rlo;
wire [7:0] out_ledv;
wire [3:0] ctrl_port;

assign in_p0 = {4'b0, ~buttons[3:0]};
assign in_p1 = (hilo_in == 2'b01) || (hilo_in == 2'b11) || (hilo_in == 2'b0) ? {3'b0, switches[4:0]} : 8'b0;
assign in_p2 = (hilo_in == 2'b10) || (hilo_in == 2'b11) || (hilo_in == 2'b0) ? {4'b0, switches[8:5]} : 8'b0;
assign in_p3 = 8'bx;

assign ine_p0 = out_ledv;  
assign ine_p1 = 8'bx;
assign ine_p2 = 8'bx;
assign ine_p3 = 8'bx;



deco #(4) outputs(io_port, ctrl_port);

registroWe #(5) leds_rlo (clk, reset, we_o & hilo_out[0] & (ctrl_port[1] | ctrl_port[2]), out_p1[4:0], out_led_rlo);
registroWe #(5) leds_rhi (clk, reset, we_o & hilo_out[1] & (ctrl_port[1] | ctrl_port[2]), out_p2[4:0], out_led_rhi);

assign led_r = {out_led_rhi, out_led_rlo};
registroWe #(8) leds_v (clk, reset, we_o & ctrl_port[0], out_p0, out_ledv);

assign led_v = out_ledv;


endmodule


