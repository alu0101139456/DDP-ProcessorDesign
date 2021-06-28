module uc(input wire [5:0] opcode, input wire z, output wire s_inc, we3, wez, we_stack, s_jret, 
    output reg [2:0] op_alu, output wire [1:0] sel_inputs, output wire we_port);

parameter ARITH   = 8'b10011000; 
parameter LOADINM = 8'b11110000; 
parameter JUMP    = 8'b00000000; 
parameter NOJUMP  = 8'b10000000; 
parameter IN      = 8'b10110000;
parameter OUT     = 8'b10000100;
parameter NOP     = 8'b00000000;
parameter JAL     = 8'b00000010;
parameter RET     = 8'b00000011;

reg [3:0] operation;

reg [7:0] signals; // ver si hace falta inicializarlo

assign {s_inc, sel_inputs[1], sel_inputs[0], we3, wez, we_port, we_stack, s_jret} = signals;

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
        
        default: 
            signals = NOP; 
    endcase
    
end

endmodule