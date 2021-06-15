module cd(input wire clk, reset, s_inc, we3, wez, s_we_port, input wire [2:0] op_alu, input wire [1:0] sel_inputs, 
    input wire [7:0] in_p0, in_p1, output wire z, output wire [5:0] opcode, output wire [7:0] out_p0, out_p1);
//Camino de datos de instrucciones de un solo ciclo
//Nomenclatura 

    wire [9:0] mux1_to_pc, sum2mux, DIR;
    wire [15:0] DIR_SALTO;
    wire [3:0] RA1, RA2, WA3; //10'b1
    wire [7:0] RD1, RD2, WD3, alu_to_mux4, ports_to_mux4, stack_to_mux4, inm_to_mux4;
    wire ZALU;
    wire io_port;

    assign opcode[5:0] = DIR_SALTO[15:10];
    assign WA3[3:0] = DIR_SALTO[3:0];
    assign RA2[3:0] = DIR_SALTO[7:4];
    assign RA1[3:0] = DIR_SALTO[11:8];
    assign inm_to_mux4 = DIR_SALTO[11:4];
    assign io_port = DIR_SALTO[8];

    registro #(10) pc_register(clk, reset, mux1_to_pc, DIR );
    mux2 #(10) MUX_PC(DIR_SALTO[9:0], sum2mux, s_inc, mux1_to_pc);
    sum SUMADOR(10'b1, DIR, sum2mux);

    memprog MEMPROG(clk, DIR, DIR_SALTO);
    regfile REGFILE(clk, we3, RA1, RA2, WA3, WD3, RD1, RD2);

    ffd FFD(clk, reset, ZALU, wez, z);
    alu ALU(RD1, RD2, op_alu, alu_to_mux4, ZALU);

    io_module PORTS_MODULE(clk, reset, io_port, s_we_port, in_p0, in_p1, RD2, out_p0, out_p1, ports_to_mux4);
    mux4 mux_of_inputs(alu_to_mux4, ports_to_mux4, stack_to_mux4, inm_to_mux4, sel_inputs, WD3);

endmodule
