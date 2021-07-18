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

module memstack #(parameter WIDTH = 16, parameter NWORDS = 1024)(input  wire clk, we,
               input  wire [$clog2(NWORDS)-1:0]  a,
               input  wire [WIDTH - 1:0] data_in,
               output wire [WIDTH - 1:0] data_out);

  reg [WIDTH - 1:0] mem[0:NWORDS-1]; //memoria de 1024 palabras de 16 bits de ancho

 always @(posedge clk) begin
    // $display("A is: %d", a);
    #1;
    if (we) begin
      // $display("Writing %d", data_in);
      // $display("sp: %d", a);
      mem[a] <= data_in;
      
    end	
 end
  
  assign data_out = mem[a];

  
endmodule
