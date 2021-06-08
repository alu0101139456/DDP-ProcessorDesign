module cd(input wire clk, reset, s_inc, s_inm, we3, wez, 
input wire [2:0] op_alu, output wire z, output wire [5:0] opcode);
//Camino de datos de instrucciones de un solo ciclo
//Nomenclatura 

    wire[9:0] MUX_2_PC, sum2mux, DIR;
    wire[15:0] DIR_SALTO;
    wire[3:0] RA1, RA2, WA3; //10'b1
    wire[7:0] RD1, RD2, WD3, ALU2MUX, INM;
    wire ZALU;

    assign opcode[5:0] = DIR_SALTO[15:10];
    assign WA3[3:0] = DIR_SALTO[3:0];
    assign RA2[3:0] = DIR_SALTO[7:4];
    assign RA1[3:0] = DIR_SALTO[11:8];
    assign INM = DIR_SALTO[11:4];

    registro #(10) R_PC(clk, reset, MUX_2_PC, DIR );
    mux2 #(10) MUX_PC(DIR_SALTO[9:0], sum2mux, s_inc, MUX_2_PC);
    sum SUMADOR(10'b1, DIR, sum2mux);

    memprog MEMPROG(clk, DIR, DIR_SALTO);
    regfile REGFILE(clk, we3, RA1, RA2, WA3, WD3, RD1, RD2);

    ffd FFD(clk, reset, ZALU, wez, z);
    alu ALU(RD1, RD2, op_alu, ALU2MUX, ZALU);
    mux2 mux2regfile(ALU2MUX, INM, s_inm, WD3);

endmodule
