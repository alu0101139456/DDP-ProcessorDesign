module uc(input wire [5:0] opcode, input wire z, output reg s_inc,
 s_inm, we3, wez, output reg [2:0] op_alu);
parameter ARITH   = 4'b1011; 
parameter LOADINM = 4'b1110; 
parameter JUMP    = 4'b0000; 
parameter NOJUMP  = 4'b1000; 
// parameter BNZ     = 4'b0100; 
// parameter LIN     = 4'b0101; 
// parameter STI     = 4'b0110; 
// parameter STR     = 4'b0111; 
// parameter JAL     = 4'b1001;  //TEMPORAL
// parameter RET     = 4'b1010;  //TEMPORAL
parameter NOP     = 4'b0000;
reg [3:0] operation;

always @(opcode) begin
    op_alu = opcode[4:2];
    casez (opcode)
        6'b0?????: // operacion aritmetica
            {s_inc, s_inm, we3, wez} = ARITH; 

        6'b1000??: // carga de inmediato
            {s_inc, s_inm, we3, wez} = LOADINM;

        6'b10010?: // salto condicional
            begin
                if (opcode[0] == 0) // branch equal zero
                    if(z)
                        {s_inc, s_inm, we3, wez} = JUMP;
                    else
                        {s_inc, s_inm, we3, wez} = NOJUMP;

                else  // branch not iqual zero
                    if(z)
                        {s_inc, s_inm, we3, wez} = NOJUMP;
                    else
                        {s_inc, s_inm, we3, wez} = JUMP;
            end

        6'b100110: // salto incondicional
            {s_inc, s_inm, we3, wez} = JUMP;
        
        
        default: 
            {s_inc, s_inm, we3, wez} = NOP; 
    endcase
    
end

endmodule