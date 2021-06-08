module io_module ( input wire clk, reset, sel_port, we, input wire [7:0] in_p0, in_p1, in_RD2, output wire [7:0] out_p0, out_p1, out );

    input_module IN_MODULE(clk, reset, sel_port, in_p0, in_p1, out);

    output_module OUT_MODULE(clk, reset, sel_port, we, in_RD2, out_p0, out_p1);


    
endmodule