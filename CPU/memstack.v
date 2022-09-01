`timescale 1 ns / 10 ps

module memstack #(parameter WIDTH = 16, parameter NWORDS = 1024)(input  wire clk, we,
               input  wire [$clog2(NWORDS)-1:0]  a,
               input  wire [WIDTH - 1:0] data_in,
               output wire [WIDTH - 1:0] data_out);

  reg [WIDTH - 1:0] mem[0:NWORDS-1]; //memoria de 1024 palabras de 16 bits de ancho

 always @(posedge clk) begin
    // $display("A is: %d", a);
    #1;
    if (we) begin
      mem[a] <= data_in;
    end	
 end
  
  assign data_out = mem[a];

  
endmodule