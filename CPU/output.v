`timescale 1 ns / 10 ps

module output_module ( input wire we, input wire [1:0] sel_port, input wire [7:0] in_RD2, 
                        output wire [7:0] out_from_p0, out_from_p1, out_from_p2, out_from_p3);

    wire [3:0] ctrl_port;
    
    deco #(4) DECO_FOR_OUTPUTS(sel_port, ctrl_port);

    assign out_from_p0 = ctrl_port[0] & we ? in_RD2 : 8'b0;
    assign out_from_p1 = ctrl_port[1] & we ? in_RD2 : 8'b0;
    assign out_from_p2 = ctrl_port[2] & we ? in_RD2 : 8'b0;
    assign out_from_p3 = ctrl_port[3] & we ? in_RD2 : 8'b0;    
    
endmodule