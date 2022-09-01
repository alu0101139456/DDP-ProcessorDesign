`timescale 1 ns / 10 ps

module timer #(parameter T = 25000000) (input wire clk, reset, output reg pulse);

localparam N = $clog2(T);
reg [N-1:0] cont, limit;


always @(posedge clk, posedge reset)
begin
  if (reset)
  begin
    cont <= 1;
    pulse <= 1'b0;
    limit <= T - 1;
  end
  else if (cont < limit)
  begin
    cont <= cont + 1;
    pulse <= 1'b0;
  end
  else
  begin
    if (limit != 0)
        pulse <= 1'b1;  
    else
        pulse <= 1'b0;
    cont <= 1;
  end
end

endmodule