`timescale 1 ns / 10 ps

module memstack #(parameter WIDTH = 16, parameter NWORDS = 1024)(input  wire clk, reset, we,
               input  wire [$clog2(NWORDS)-1:0]  a,
               input  wire [WIDTH - 1:0] data_in,
               output wire [WIDTH - 1:0] data_out);

  reg [WIDTH-1:0] mem[0:NWORDS-1]; //memoria de 1024 palabras de 16 bits de ancho

 always @(posedge clk, posedge reset) begin
    if (reset)
      mem['b0] <= 0;
    else if (we)
      mem[a] <= data_in;
 end
  
  assign data_out = mem[a];

  
endmodule