module cpu(input wire clk, reset);
//Procesador sin memoria de datos de un solo ciclo

wire [5:0] opcode;
wire [2:0] op_alu;
wire s_inc, s_inm, we3, wez, z;

uc unidadControl(opcode, z, s_inc,s_inm, we3, wez, op_alu);

cd caminoDatos(clk, reset,s_inc,s_inm,we3, wez, op_alu,z,opcode);

endmodule
