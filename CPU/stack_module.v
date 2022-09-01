`timescale 1 ns / 10 ps

module stack_module #(parameter WIDTH = 10, parameter NWORDS = 16)
    (input wire  clk, reset, we_stack, s_pushpop, input wire [WIDTH-1:0] data_in, 
    output wire [WIDTH-1:0] data_out );

wire [WIDTH-1:0] data_temp;
reg [$clog2(NWORDS)-1:0] uno, muno;
initial 
begin
    uno = 1;
    muno = -1;
end

wire [$clog2(NWORDS)-1:0] out_sp, out_sum, out_mux;


sum #($clog2(NWORDS)) SUMADOR(out_sp, out_mux, out_sum);
mux2 #($clog2(NWORDS)) MUX_TO_INCDEC(uno,muno, s_pushpop, out_mux); 
registro #($clog2(NWORDS)) STACK_POINTER(~clk & we_stack, reset, out_sum, out_sp);
memstack #(WIDTH,NWORDS) MEM_STACK(clk, we_stack & ~s_pushpop, out_sp, data_in, data_out);

endmodule