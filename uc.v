module uc(input wire [5:0] opcode, input wire z, output reg s_inc,
 s_inm, we3, wez, output reg [2:0] op_alu);
parameter ARITH   = 5'b10110; 
parameter LOADINM = 5'b11100; 
parameter JUMP    = 5'b00000; 
parameter NOJUMP  = 5'b10000; 
parameter IN      = 5'b10100;
parameter OUT     = 5'b10001:
parameter NOP     = 5'b00000;
reg [3:0] operation;

reg [4:0] signals; // ver si hace falta inicializarlo

assign {s_inc, s_inm, we3, wez, we_port} = signals;

always @(opcode) begin
    op_alu = opcode[4:2];
    casez (opcode)
        6'b0?????: // operacion aritmetica
            signals = ARITH; 

        6'b1000??: // carga de inmediato
            signals = LOADINM;

        6'b10010?: // salto condicional
            begin
                if (opcode[0] == 0) // branch equal zero
                    if(z)
                        signals = JUMP;
                    else
                        signals = NOJUMP;

                else  // branch not iqual zero
                    if(z)
                        signals = NOJUMP;
                    else
                        signals = JUMP;
            end

        6'b100110: // salto incondicional
            signals = JUMP;
        
        
        default: 
            signals = NOP; 
    endcase
    
end

endmodule