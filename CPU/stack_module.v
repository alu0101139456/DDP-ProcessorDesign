`timescale 1 ns / 10 ps

module stack_module #(parameter WIDTH = 10, parameter NWORDS = 16)
    (input wire  clk, reset, we_stack, s_pushpop, s_interruption, instruction_mode, input wire [WIDTH-1:0] data_in, 
    output wire [WIDTH-1:0] data_out);
  
  reg[$clog2(NWORDS):0] sp;
  wire[$clog2(NWORDS)-1:0] sp_inc, sp_dec, sp_pre;
  wire [WIDTH-1:0] data;
  
  assign sp_inc = sp + 'b1;
  assign sp_dec = sp - 'b1;
  
  always @(posedge clk, posedge reset)
  begin
	  if (reset) begin
      sp <= 'b0;
	  end
    else if (~s_pushpop & we_stack)
    begin
      sp <= sp_inc;
    end
    else if (s_pushpop & we_stack)
    begin
      sp <= sp_dec;
    end
  end

  assign sp_pre = ~s_pushpop & we_stack ? sp_inc : sp;
  assign data_out = s_interruption & instruction_mode ? data - 'b1 : data;
  
  memstack #(WIDTH,NWORDS) MEM_STACK(clk, reset, we_stack & ~s_pushpop, sp_pre, data_in, data);
  
  
endmodule