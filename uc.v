module uc(input wire [5:0] opcode, input wire z, output wire s_inc, we3, wez, we_istack, s_jret, we_dstack, s_ppop, 
    output reg [2:0] op_alu, output wire [1:0] sel_inputs, output wire we_port);

parameter ARITH   = 10'b1001100000; 
parameter LOADINM = 10'b1111000000; 
parameter JUMP    = 10'b0000000000; 
parameter NOJUMP  = 10'b1000000000; 
parameter IN      = 10'b1011000000;
parameter OUT     = 10'b1000010000;
parameter NOP     = 10'b0000000000;
parameter JAL     = 10'b0000001000;
parameter RET     = 10'b0000001100;
parameter PUSH    = 10'b1000000010;
parameter POP     = 10'b1101000011;

reg [3:0] operation;

reg [9:0] signals; // ver si hace falta inicializarlo

assign {s_inc, sel_inputs[1], sel_inputs[0], we3, wez, we_port, we_istack, s_jret, we_dstack, s_ppop} = signals;

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

        6'b100111:
            signals = IN;
        6'b101000:
            signals = OUT;
        6'b101001:
            signals = JAL;
        6'b101010:
            signals = RET;
        6'b101011:
            signals = PUSH;
        6'b101100:
            signals = POP;

        default: 
            signals = NOP; 
    endcase
    
end

endmodule