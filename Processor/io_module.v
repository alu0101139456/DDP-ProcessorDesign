module io_module ( input wire clk, reset, we, input wire [1:0] sel_port, input wire [7:0] in_p0, in_p1, in_p2, in_p3, in_RD2, output wire [7:0] out_p0, out_p1, out_p2, out_p3, in_port_out, output wire port_interrupt );

   
    input_module IN_MODULE(clk, reset, sel_port, in_p0, in_p1, in_p2, in_p3, in_port_out, interrupt);

    output_module OUT_MODULE(clk, reset, we, sel_port, in_RD2, out_p0, out_p1, out_p2, out_p3);


    
endmodule