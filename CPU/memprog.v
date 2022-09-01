`timescale 1 ns / 10 ps

//Memoria de programa, se inicializa y no se modifica

module memprog #(parameter WIDTH = 16, parameter NWORDS = 1024)(input  wire        clk,
               input  wire [$clog2(NWORDS)-1:0]  a,
               output wire [WIDTH - 1:0] rd);

  reg [WIDTH - 1:0] mem[0:NWORDS-1]; //memoria de 1024 palabras de 16 bits de ancho

  initial
  begin
    $readmemb("progfile.dat",mem); // inicializa la memoria del fichero en texto binario
  end
  
  assign rd = mem[a];

endmodule

//Memoria de programa, se inicializa y no se modifica


