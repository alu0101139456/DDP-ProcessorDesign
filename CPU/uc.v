`timescale 1 ns / 10 ps

module uc(input wire [5:0] opcode, input wire z, i_timer, s_interruption, output wire s_mux1, s_mux2, s_mux3, we3, wez, we_istack, s_jret, we_dstack, s_ppop, s_finish_interr, 
    output reg [2:0] op_alu, output wire [1:0] sel_inputs, output wire we_port, we_o, s_special_port);


reg [3:0] operation;

reg [14:0] signals; 

parameter ARITH   = 15'b100001100000000; 
parameter LOADINM = 15'b100111000000000; 
parameter JUMP    = 15'b010000000000000; 
parameter NOJUMP  = 15'b110000000000000; 
parameter IN      = 15'b100011000000000;
parameter OUT     = 15'b100000010000010;
parameter NOP     = 15'b000000000000000;
parameter JAL     = 15'b010000001000000;
parameter RET     = 15'b101000001100000;
parameter PUSH    = 15'b100000000010000;
parameter POP     = 15'b100101000011000;
parameter INTERR  = 15'b000000001000000;
parameter FNSH    = 15'b101000001100100;
parameter OUTPUTR = 15'b100011000000001;

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
    we_o,            //14
    s_special_port   //15

} = signals;

always @(*) begin
    if (i_timer & ~s_interruption) begin
        signals = INTERR;
		  op_alu = 3'bx;
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
                signals = FNSH;
            6'b101111:
                signals = OUTPUTR;
            default: 
                signals = NOP; 
        endcase
    end 
end

endmodule