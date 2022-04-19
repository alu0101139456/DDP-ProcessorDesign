module interruption_module (  input wire clk, reset, i_except, i_port, i_syscall, i_timer, s_finished, output wire[9:0] dir_out, output reg s_interruption );

//Direcciones de subrutina
parameter dir_timer     = 10'b0000010011;
parameter dir_exception = 10'b1111111011;
parameter dir_port      = 10'b1111111100;
parameter dir_syscall   = 10'b1111111101;

reg [3:0] mask, actions;

// reg [9:0] imem[3:0]; // Esta "memoria" es para las llamadas al syscall
// initial
// begin // las ubicaciones se direccionan con la carga de un inmediato
//     imem[0] = 10'b000000000000;
//     imem[1] = 10'b000000000000;
//     imem[2] = 10'b000000000000;
//     imem[3] = 10'b000000000000;
// end

// reg [7:0] inm;

always @(reset, i_except, i_port, i_syscall, i_timer, s_finished) begin
    if (reset) begin
        actions <= 0;
        mask <= 4'b1111;
    end
    else if (s_finished) begin  //Termina y bajo el flag activo
        actions <= actions & mask;
    end
    else 
        actions <= { i_except, i_port, i_syscall, i_timer} | actions;
end

reg [9:0] dirAux;
reg active;

// ACTIONS [ i_except, i_port, i_syscall, i_timer]

always @(reset, actions, s_finished)
begin
    if (reset) begin
        active <= 1'b0;
        dirAux <= 10'bx;    
    end
    else begin
        if (active && s_finished )
            active = 1'b0;
        else if ((active && ~s_finished) || ~active)
            s_interruption = 1'b0;

        if (actions[3]) begin //i_except
            if (~active) begin
                mask <= 4'b0111;
                dirAux <= dir_exception;
                s_interruption <= 1'b1;
                #1;
            end
            active <= 1'b1;
        end
        else if (actions[2]) begin //i_port
            if (~active) begin
                mask <= 4'b1011;
                dirAux <= dir_port;
                s_interruption <= 1'b1;
                #1;
            end
            active <= 1'b1;
        end
        else if (actions[0]) begin //i_timer
            if (~active) begin
                mask <= 4'b1110;
                dirAux <= dir_timer;
                s_interruption <= 1'b1;
                #1;
            end
            active <= 1'b1;
        end
        else if (actions[1]) begin //i_syscall
            if (~active) begin
                mask <= 4'b1101;
                dirAux <= dir_syscall;
                s_interruption <= 1'b1;
                #1;
            end
            active <= 1'b1;
        end
        else 
            dirAux <= 10'bx;         
    end
end


assign dir_out = dirAux;


  
endmodule