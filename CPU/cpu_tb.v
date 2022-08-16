`timescale 1 ns / 10 ps

module cpu_tb;


reg clk, reset;
reg [7:0] p0,p1,p2,p3;

// generación de reloj clk
always //siempre activo, no hay condición de activación
begin
  clk = 1'b1;
  #30;
  clk = 1'b0;
  #30;
end


// instanciación de la cpu
cpu micpu(clk, reset, p0, p1, p2, p3, , , ,);

// input wire clk, reset, input wire [7:0] in_p0, in_p1, output wire [7:0] out_p0, out_p1);

initial
begin
  $dumpfile("cpu_tb.vcd");
  $dumpvars;
  reset = 1;  //a partir del flanco de subida del reset empieza el funcionamiento normal
  #10;
  reset = 0;  //bajamos el reset 
end

initial
begin
  
  p0 = 8'b00001000;
  p1 = 8'b00000100;
  p2 = 8'b00001101;
  p3 = 8'b00000101;
  
  #(32*120);  //Esperamos 9 ciclos o 9 instrucciones
  $finish;
end

endmodule