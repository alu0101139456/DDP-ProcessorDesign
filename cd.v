module cd(input wire clk, reset, s_inc, we3, wez, s_we_port, s_we_stack, s_jalret, s_we_stack_data,  s_pushpop, input wire [2:0] op_alu, input wire [1:0] sel_inputs, 
    input wire [7:0] in_p0, in_p1, output wire z, output wire [5:0] opcode, output wire [7:0] out_p0, out_p1);
//Camino de datos de instrucciones de un solo ciclo
//Nomenclatura 

    wire [9:0] mux1_to_pc, dir, dir_salto, dir_out, dir_in, jump_address;
    wire [15:0] instruccion;
    wire [3:0] RA1, RA2, WA3; //10'b1
    wire [7:0] RD1, RD2, WD3, alu_to_mux4, ports_to_mux4, stack_to_mux4, inm_to_mux4;
    wire ZALU;
    wire io_port;

    assign dir_salto = instruccion[9:0];
    assign opcode[5:0] = instruccion[15:10];
    assign WA3[3:0] = instruccion[3:0];
    assign RA2[3:0] = instruccion[7:4];
    assign RA1[3:0] = instruccion[11:8];
    assign inm_to_mux4 = instruccion[11:4];
    assign io_port = instruccion[8];

    registro #(10) PC_REGISTER(clk, reset, mux1_to_pc, dir );
    mux2 #(10) MUX_PC(jump_address, dir_in, s_inc, mux1_to_pc);
    sum SUMADOR(10'b1, dir, dir_in);

    memprog #(16,1024) MEMPROG(clk, dir, instruccion);
    regfile REGFILE(clk, we3, RA1, RA2, WA3, WD3, RD1, RD2);

    ffd FFD(clk, reset, ZALU, wez, z);
    alu ALU(RD1, RD2, op_alu, alu_to_mux4, ZALU);

    io_module PORTS_MODULE(clk, reset, io_port, s_we_port, in_p0, in_p1, RD2, out_p0, out_p1, ports_to_mux4);
    mux4 MUX_OF_INPUTS(alu_to_mux4, ports_to_mux4, stack_to_mux4, inm_to_mux4, sel_inputs, WD3);

    mux2 #(10) MUX_JUMPS(dir_salto, dir_out, s_jalret, jump_address );
    
    // stack_module STACK_INST(clk, reset, s_we_stack, s_jalret, dir_in, dir_out);
    
    stack_module #(8,64) STACK_DATA(clk, reset, s_we_stack_data, s_pushpop, RD2, stack_to_mux4);



endmodule
