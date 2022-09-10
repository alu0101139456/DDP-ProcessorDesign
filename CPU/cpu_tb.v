`timescale 1 ns / 10 ps

module cpu_tb;


reg clk, reset;
wire [7:0] led_v;
wire [9:0] led_r;
reg [3:0] buttons; // botones apagados 1111
reg [9:0] switches;


// generación de reloj clk
always //siempre activo, no hay condición de activación
begin
  clk = 1'b1;
  #30;
  clk = 1'b0;
  #30;
end

integer idx;

// module entorno_cpu( input wire clk, reset, input wire [3:0] buttons, input wire [9:0] switches, output wire [7:0] led_v, output wire [9:0] led_r);
// instanciación del entorno de la cpu
entorno_cpu cpu(clk, reset, buttons, switches, led_v, led_r);

/*
initial
begin
  $dumpfile("./bin/cpu_tb.vcd");
  $dumpvars;
  for (idx = 0; idx < 16; idx = idx + 1) $dumpvars(0,cpu_tb.cpumono.data_path.register_file.regb[idx]);  
  for (idx = 0; idx < 16; idx = idx + 1) $dumpvars(0,cpu_tb.cpumono.data_path.Stack.stackmem[idx]);
*/

initial
begin
  $dumpfile("bin/cpu_tb.vcd");
  $dumpvars;
  //for (idx = 0; idx < 16; idx = idx + 1) $dumpvars(0,cpu_tb.cpumono.data_path.register_file.regb[idx]); 
  
  for (idx = 0; idx < 16; idx = idx + 1) $dumpvars(0,cpu_tb.cpu.cpu_final.CAMINO_DATOS.REGFILE.regb[idx]); 

  reset = 1;  //a partir del flanco de subida del reset empieza el funcionamiento normal
  buttons = 4'b1111;
  switches = 10'b0;
  #10;
  reset = 0;  //bajamos el reset 

  #30;
  //buttons = 4'b1110; // presionamos key0
  switches = 10'b0001000001;

  #1000
  buttons = 4'b1110;
  #20000
  buttons = 4'b1111; // suponemos que ha pasado tiempo suficiente como para que el main haya revisado el estado
  switches = 10'b0;


end

reg [7:0] registers;

initial
begin
  #(32*2500);  //Esperamos 9 ciclos o 9 instrucciones

  for (idx = 0; idx < 16; idx = idx + 1)
  begin
    registers[7:0] = cpu_tb.cpu.cpu_final.CAMINO_DATOS.REGFILE.regb[idx];
    $write("R%d =%d\n",idx, registers);
  end
  $finish;
end

endmodule