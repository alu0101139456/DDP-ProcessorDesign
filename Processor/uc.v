module uc(input wire [5:0] opcode, input wire z, s_interruption, output wire s_inc, we3, wez, we_istack, s_jret, we_dstack, s_ppop, s_finish_interr, use_dir_interr,
    output reg [2:0] op_alu, output wire [1:0] sel_inputs, output wire we_port);

parameter ARITH   = 12'b100110000000; 
parameter LOADINM = 12'b111100000000; 
parameter JUMP    = 12'b000000000000; 
parameter NOJUMP  = 12'b100000000000; 
parameter IN      = 12'b101100000000;
parameter OUT     = 12'b100001000000;
parameter NOP     = 12'b000000000000;
parameter JAL     = 12'b000000100000;
parameter RET     = 12'b000000110000;
parameter PUSH    = 12'b100000001000;
parameter POP     = 12'b110100001100;
parameter SYSCALL = 12'b000000100010;
parameter FNSH    = 12'b000000000001;

reg [3:0] operation;

reg [9:0] signals; // ver si hace falta inicializarlo

assign {s_inc, sel_inputs[1], sel_inputs[0], we3, wez, we_port, we_istack, s_jret, we_dstack, s_ppop, use_dir_interr, s_finish_interr} = signals;

always @(opcode) begin
    if (s_interruption)
        signals = SYSCALL;
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
            6'b101101:
                signals = SYSCALL;
            6'b101110:
                signals = FNSH;

            default: 
                signals = NOP; 
        endcase

    end 
end

endmodule