module input_module ( input wire clk, reset, sel_port, input wire [7:0] in_p0, in_p1, output wire [7:0] out);
    
    wire [7:0] p0_2Mux, p1_2Mux;

    registro P0(clk, reset, in_p0, p0_2Mux);

    registro P1(clk, reset, in_p1, p1_2Mux);

    mux2 MUX_PORT(p0_2Mux, p1_2Mux, sel_port, out);
    

endmodule