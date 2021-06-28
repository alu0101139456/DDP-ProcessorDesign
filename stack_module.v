module stack_module (input wire  clk, reset, we_stack, s_jalret, input wire [9:0] data_in, output wire [9:0] data_out );


wire [3:0] out_sp, out_sum, out_mux;

sum #(4) SUMADOR(out_sp, out_mux, out_sum);
mux2 #(4) MUX_TO_INCDEC(4'b0001,4'b1111, s_jalret, out_mux); 
// registro #(4) STACK_POINTER(~clk & (we_stack | s_jalret), reset, out_sum, out_sp);
registro #(4) STACK_POINTER(~clk & we_stack, reset, out_sum, out_sp);
memstack #(10,16) MEM_STACK(clk, we_stack, out_sp, data_in, data_out);

endmodule