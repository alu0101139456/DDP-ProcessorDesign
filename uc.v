module uc(input wire [5:0] opcode, input wire z, output wire s_inc, we3, wez, 
    output reg [2:0] op_alu, output wire [1:0] sel_inputs, output wire we_port);

parameter ARITH   = 6'b100110; 
parameter LOADINM = 6'b111100; 
parameter JUMP    = 6'b000000; 
parameter NOJUMP  = 6'b100000; 
parameter IN      = 6'b101100;
parameter OUT     = 6'b100001;
parameter NOP     = 6'b000000;

reg [3:0] operation;

reg [5:0] signals; // ver si hace falta inicializarlo

assign {s_inc, sel_inputs[1], sel_inputs[0], we3, wez, we_port} = signals;

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
        default: 
            signals = NOP; 
    endcase
    
end

endmodule