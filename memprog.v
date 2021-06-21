//Memoria de programa, se inicializa y no se modifica

module memprog #(parameter WIDTH = 16, parameter ELEMENTOS = 1024)(input  wire        clk,
               input  wire [$clog2(ELEMENTOS)-1:0]  a,
               output wire [WIDTH - 1:0] rd);

  reg [WIDTH - 1:0] mem[0:ELEMENTOS-1]; //memoria de 1024 palabras de 16 bits de ancho

  initial
  begin
    $readmemb("progfile.dat",mem); // inicializa la memoria del fichero en texto binario
  end
  
  assign rd = mem[a];

endmodule


