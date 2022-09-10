`timescale 1 ns / 10 ps

module input_module ( input wire [1:0] sel_port, 
            input wire [7:0] in_p0, in_p1, in_p2, in_p3, output wire [7:0] out);
    
    mux4 MUX_PORT(in_p0, in_p1, in_p2, in_p3, sel_port, out);
    
endmodule