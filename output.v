module output_module ( input wire clk, reset, sel_port, we, input wire [7:0] in_RD2, output wire [7:0] out_from_p0, out_from_p1);

    wire ctrl_port;
    
    assign ctrl_port = clk && we && !sel_port;
    

    registro P0(ctrl_port, reset, in_RD2, out_from_p0);

    registro P1(ctrl_port, reset, in_RD2, out_from_p1);

    
    
    
endmodule