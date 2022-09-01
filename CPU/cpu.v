`timescale 1 ns / 10 ps

module cpu(input wire clk, reset, i_timer, input wire [7:0] in_p0, in_p1, in_p2, in_p3, output wire we_o, output wire [1:0] hilo_in, hilo_out, output wire [7:0] out_p0, out_p1, out_p2, out_p3);
//Procesador sin memoria de datos de un solo ciclo

wire [5:0] opcode;
wire [2:0] op_alu;
wire [1:0] sel_inputs;
wire s_4mux1, s_4mux2, s_4mux3, s_inm, we3, wez, z, we_port,s_we_stack, s_jret, s_we_stack_data, s_ppop, s_interruption, s_finish_interr;

uc unidadControl(opcode, z, s_interruption, s_4mux1, s_4mux2, s_4mux3 ,we3, wez, s_we_stack, s_jret, s_we_stack_data, s_ppop, s_finish_interr, op_alu, sel_inputs, we_port, we_o);

// cd caminoDatos(clk, reset,s_inc,s_inm,we3, wez, op_alu,z,opcode);

cd CAMINO_DATOS(clk, reset, s_4mux1, s_4mux2, s_4mux3, we3, wez, we_port, s_we_stack, s_jret, s_we_stack_data, s_ppop, i_timer, s_finish_interr, op_alu, sel_inputs, in_p0, in_p1, in_p2, in_p3, z, s_interruption,
           hilo_in, hilo_out, opcode, out_p0, out_p1, out_p2, out_p3);



endmodule
