`timescale 1 ns / 10 ps

module cd(input wire clk, reset, s_4mux1, s_4mux2, s_4mux3, we3, wez, s_we_port, s_we_stack, s_jalret, s_we_stack_data,  s_pushpop, i_timer, s_finish_interr, s_special_port, input wire [2:0] op_alu, input wire [1:0] sel_inputs, 
    input wire [7:0] in_p0, in_p1, in_p2, in_p3, ine_p0, ine_p1, ine_p2, ine_p3, output wire z, s_interruption, output wire [1:0] hilo_in, hilo_out, io_port, output wire [5:0] opcode, output wire [7:0] out_p0, out_p1, out_p2, out_p3);
//Camino de datos de instrucciones de un solo ciclo
//Nomenclatura 

    wire [9:0] mux1_to_pc, dir, dir_salto, dir_out, dir_in, mux2_mux1, mux3_mux1,dir_from_exception, int_2_mux;
    wire [15:0] instruccion;
    wire [3:0] RA1, RA2, WA3; //10'b1
    wire [7:0] RD1, RD2, WD3, alu_to_mux4, ports_to_mux4, stack_to_mux4, inm_to_mux4, out_in_port, out_ine_port;
    wire ZALU, z_i, z_main;

    assign dir_salto = instruccion[9:0];
    assign opcode[5:0] = instruccion[15:10];
    assign WA3[3:0] = instruccion[3:0];
    assign RA2[3:0] = instruccion[7:4];
    assign RA1[3:0] = instruccion[11:8];
    assign inm_to_mux4 = instruccion[11:4];
    assign io_port = instruccion[9:8];
    assign hilo_in = instruccion[5:4];  
    assign hilo_out = instruccion[1:0];

    
    registro #(10)     PC_REGISTER(clk, reset, mux1_to_pc, dir);
    sum                SUMADOR(10'b1, dir, dir_in);
    stack_module       STACK_INST(clk, reset, s_we_stack, s_jalret, (i_timer & ~s_finish_interr) | s_interruption, 1'b1, dir_in, dir_out);
    memprog #(16,1024) MEMPROG(clk, dir, instruccion);
    regfile            REGFILE(clk, we3, RA1, RA2, WA3, WD3, RD1, RD2);
    mux2 #(10)         MUX_1(mux2_mux1, mux3_mux1, s_4mux1, mux1_to_pc);
    mux2 #(10)         MUX_2(dir_from_exception, dir_salto, s_4mux2, mux2_mux1 ); //s_jalret
    mux2 #(10)         MUX_3(dir_in, dir_out, s_4mux3, mux3_mux1 );
    
    interruption_module INTER(clk, reset, i_timer, s_finish_interr, dir_from_exception, s_interruption);

    ffd FFZ(clk, reset, ZALU, wez & ~s_interruption, z_main);
    ffd FFZi(clk, reset, ZALU, wez & s_interruption, z_i);
	assign z = s_interruption ? z_i : z_main;
    alu ALU(RD1, RD2, op_alu, alu_to_mux4, ZALU);

    io_module PORTS_MODULE(s_we_port, io_port, in_p0, in_p1, in_p2, in_p3, ine_p0, ine_p1, ine_p2, ine_p3, RD2, out_p0, out_p1, out_p2, out_p3, out_in_port, out_ine_port);
    mux2 MUX_4( out_in_port, out_ine_port, s_special_port, ports_to_mux4);
    mux4 MUX_OF_INPUTS(alu_to_mux4, ports_to_mux4, stack_to_mux4, inm_to_mux4, sel_inputs, WD3);

    stack_module #(8,64) STACK_DATA(clk, reset, s_we_stack_data, s_pushpop, (i_timer & ~s_finish_interr) | s_interruption, 1'b0, RD2, stack_to_mux4);

    //Data loger de tener un modo de caputora, con los botones cambiar el modo (modo lectura, modo reprodución)

endmodule
