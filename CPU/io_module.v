`timescale 1 ns / 10 ps

module io_module ( input wire we, input wire [1:0] sel_port, input wire [7:0] in_p0, in_p1, in_p2, in_p3, ine_p0, ine_p1, ine_p2, ine_p3, in_RD2, output wire [7:0] out_p0, out_p1, out_p2, out_p3, data_in_from_port, data_in_e);

   
    input_module IN_MODULE( sel_port, in_p0, in_p1, in_p2, in_p3, data_in_from_port);

    output_module OUT_MODULE(we, sel_port, in_RD2, out_p0, out_p1, out_p2, out_p3);

    input_module IN_EXTRA_MODULE(sel_port, ine_p0, ine_p1, ine_p2, ine_p3, data_in_e);


endmodule