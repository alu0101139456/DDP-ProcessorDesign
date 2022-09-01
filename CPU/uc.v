`timescale 1 ns / 10 ps

module uc(input wire [5:0] opcode, input wire z, s_interruption, output wire s_mux1, s_mux2, s_mux3, we3, wez, we_istack, s_jret, we_dstack, s_ppop, s_finish_interr, 
    output reg [2:0] op_alu, output wire [1:0] sel_inputs, output wire we_port, we_o);


reg [3:0] operation;
reg onInterrupt = 0;
reg onFinish = 0;

reg [13:0] signals; 

parameter ARITH   = 14'b10000110000000; 
parameter LOADINM = 14'b10011100000000; 
parameter JUMP    = 14'b01000000000000; 
parameter NOJUMP  = 14'b11000000000000; 
parameter IN      = 14'b10001100000000;
parameter OUT     = 14'b10000001000001;
parameter NOP     = 14'b00000000000000;
parameter JAL     = 14'b01000000100000;
parameter RET     = 14'b10100000110000;
parameter PUSH    = 14'b10000000001000;
parameter POP     = 14'b10010100001100;
parameter INTERR  = 14'b00000000100000;
parameter FNSH    = 14'b10100000110010;

assign {
    s_mux1,         //1
    s_mux2,         //2
    s_mux3,         //3
    sel_inputs[1],  //4
    sel_inputs[0],  //5
    we3,            //6
    wez,            //7
    we_port,        //8
    we_istack,      //9
    s_jret,         //10
    we_dstack,      //11
    s_ppop,         //12
    s_finish_interr, //13
    we_o            //14

} = signals;

always @(opcode, s_interruption) begin
    if (onFinish & !s_finish_interr) begin
        onInterrupt = 0;
        onFinish = 0;
    end
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