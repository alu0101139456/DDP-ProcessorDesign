module uc(input wire [5:0] opcode, input wire z, s_interruption, output wire s_4mux1, s_4mux2, s_4mux3, we3, wez, we_istack, s_jret, we_dstack, s_ppop, s_finish_interr, 
    output reg [2:0] op_alu, output wire [1:0] sel_inputs, output wire we_port);

parameter ARITH   = 13'b1000011000000; 
parameter LOADINM = 13'b1001110000000; 
parameter JUMP    = 13'b0100000000000; 
parameter NOJUMP  = 13'b1100000000000; 
parameter IN      = 13'b1000110000000;
parameter OUT     = 13'b1000000100000;
parameter NOP     = 13'b0000000000000;
parameter JAL     = 13'b0100000010000;
parameter RET     = 13'b1010000011000;
parameter PUSH    = 13'b1000000000100;
parameter POP     = 13'b1001010000110;
parameter INTERR  = 13'b0000000010000;
parameter FNSH    = 13'b1010000011001;

reg [3:0] operation;

reg [12:0] signals; // ver si hace falta inicializarlo

reg onInterrupt = 0;
reg onFinish = 0;

assign {s_4mux1, s_4mux2, s_4mux3, sel_inputs[1], sel_inputs[0], we3, wez, we_port, we_istack, s_jret, we_dstack, s_ppop, s_finish_interr} = signals;

always @(opcode, s_interruption) begin
    if (onFinish & !s_finish_interr) begin
        onInterrupt = 0;
        onFinish = 0;
    end;
    if (s_interruption && !onInterrupt) begin
        signals = INTERR;
        onInterrupt = 1;
    end
    else begin
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
            6'b101110:
                begin
                    signals = FNSH;
                    onFinish = 1;
                end
            default: 
                signals = NOP; 
        endcase

    end 
end

endmodule