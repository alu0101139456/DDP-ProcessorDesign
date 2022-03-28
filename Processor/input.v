module input_module ( input wire clk, reset, input wire [1:0] sel_port, input wire [7:0] in_p0, in_p1, in_p2, in_p3, output wire [7:0] out, output wire interrupt);
    
    wire [7:0] p0_2Mux, p1_2Mux, p2_2Mux,p3_2Mux;

    

    registro P0(clk, reset, in_p0, p0_2Mux); // Puerto dedicado para interrupciones

    registro P1(clk, reset, in_p1, p1_2Mux);

    registro P2(clk, reset, in_p2, p2_2Mux);

    registro P3(clk, reset, in_p3, p3_2Mux);

    mux4 MUX_PORT(p0_2Mux, p1_2Mux, p2_2Mux, p3_2Mux, sel_port, out);
    

endmodule