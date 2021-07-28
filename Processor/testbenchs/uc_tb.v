`timescale 1 ns / 10 ps

module uc_tb;

reg [5:0] opcode;
wire [2:0] op_alu;
// instanciación del procesador
uc miuc( opcode, 1'b0 , s_inc, s_inm, we3, wez, op_alu);

initial
begin
  $dumpfile("uc_tb.vcd");
  $dumpvars;
  opcode = 6'b000100;
  #10;
  opcode = 6'b100000;
  #10;
  opcode = 6'b100100;
  #10;
  opcode = 6'b100101;
  #10;
  opcode = 6'b100110;
  #10;
  $finish;
end


endmodule