module output_module ( input wire clk, reset, we, input wire [1:0] sel_port, input wire [7:0] in_RD2, output wire [7:0] out_from_p0, out_from_p1, out_from_p2, out_from_p3);

    wire [3:0] ctrl_port;
    
    deco #(4) DECO_FOR_OUTPUTS(sel_port, ctrl_port);
   
    registro P0(ctrl_port[0] && clk && we, reset, in_RD2, out_from_p0);

    registro P1(ctrl_port[1] && clk && we, reset, in_RD2, out_from_p1);

    registro P2(ctrl_port[2] && clk && we, reset, in_RD2, out_from_p2);

    registro P3(ctrl_port[3] && clk && we, reset, in_RD2, out_from_p3);
   
    
endmodule