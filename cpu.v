module cpu(input wire clk, reset, input wire [7:0] in_p0, in_p1, output wire [7:0] out_p0, out_p1);
//Procesador sin memoria de datos de un solo ciclo

wire [5:0] opcode;
wire [2:0] op_alu;
wire [1:0] sel_inputs;
wire s_inc, s_inm, we3, wez, z, we_port,s_we_stack, s_jret, s_we_stack_data, s_ppop;

uc unidadControl(opcode, z, s_inc,we3, wez, s_we_stack, s_jret, s_we_stack_data, s_ppop, op_alu, sel_inputs, we_port);

// cd caminoDatos(clk, reset,s_inc,s_inm,we3, wez, op_alu,z,opcode);

cd CAMINO_DATOS(clk, reset, s_inc, we3, wez, we_port, s_we_stack, s_jret, s_we_stack_data, s_ppop, op_alu, sel_inputs, in_p0, in_p1, z, opcode, out_p0, out_p1);

endmodule
