## CPU Monociclo
---
###  Diseño de CPU
####  1.- Unidad de Control:

La unidad de control es la encargada de enviar señales a distintos módulos para el correcto funcionamiento de la CPU. Este control será definido en base al OPCODE que obtenga de las intrucciones recibidas y la unidad de control enviará las señales a distintos modulos, memorias, multiplexores, etc. Para la gestión de todas las señales se optó por una configuración utilizando registros. 
  
Para enviar las señales utilizamos un registro llamado "signals". La idea de utilizar esta lógica fue para permitir que la unidad de control pueda modificarse lo más fácil posible durante su implementación. Este registro será utilizado para asignar las señales que son necesarias para una instrucción determinada. 

~~~ verilog
reg [12:0] signals; 
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
    s_finish_interr //13

} = signals;
~~~
Una vez asignadas las señales en la posición del registro se debe definir la forma en la que éste registro de señales debe configurarse cuando, por ejemplo, la unidad de control recibe por OPCODE los bits "1000" que significan la instrucción "LI"(Load Inmediate). 
~~~ verilog
parameter ARITH   = 13'b1000011000000; 
parameter LOADINM = 13'b1001110000000; <-----
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
...
always @(opcode) begin
  casez(opcode)
    6'b0?????:
      signals = ARITH;

    6'b1000??: // carga de inmediato
      signals = LOADINM;
    ...
~~~
Con este código estamos asignando en el registro los bits :
**s_mux1 = 1**
**s_mux2 = 0**  
**s_mux3 = 0**  
**sel_inputs[1] = 1**
**sel_inputs[0] = 1**
**we3 = 1**
**wez = 0**
**we_port = 0**
**we_istack = 0**
**s_jret = 0**
**we_dstack = 0**
**s_ppop = 0**
**s_finish_interr = 0**

Con esta lógica la unidad de control es fácil de entender y fácil de modificar en caso de tener que añadir más señales o módulos. 

~~~verilog
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
~~~

Como se puede observar en el código, se añadieron las señales de INTERR y FNSH para tratar las interrupciones. INTERR se mantiene activa mientras exista una interrupción o subrutina esta en curso y FNSH para indicar que ha finalizado.

####  2.- Pila 
En esta CPU se implementaron dos pilas. Pila de instrucciones y pila de datos. 
 ![Pila](/recursos/StackModule.png)

~~~verilog
module stack_module #(parameter WIDTH = 10, parameter NWORDS = 16)
    (input wire  clk, reset, we_stack, s_pushpop, input wire [WIDTH-1:0] data_in, 
    output wire [WIDTH-1:0] data_out );

wire [WIDTH-1:0] data_temp;
reg [$clog2(NWORDS)-1:0] uno, muno;
initial 
begin
    uno = 1;
    muno = -1;
end

wire [$clog2(NWORDS)-1:0] out_sp, out_sum, out_mux;


sum #($clog2(NWORDS)) SUMADOR(out_sp, out_mux, out_sum);
mux2 #($clog2(NWORDS)) MUX_TO_INCDEC(uno,muno, s_pushpop, out_mux); 
registro #($clog2(NWORDS)) STACK_POINTER(~clk & we_stack, reset, out_sum, out_sp);
memstack #(WIDTH,NWORDS) MEM_STACK(clk, we_stack & ~s_pushpop, out_sp, data_in, data_out);

endmodule
~~~

El módulo recibe por parametros el ancho y el número de palabras. En el caso de la pila de instrucciones esta puesto por defecto en un ancho de 10 bits y 16 palabras. Para la pila de datos se tiene un ancho de 8 bits y 64 palabras.

~~~verilog
stack_module         STACK_INST(clk, reset, s_we_stack, s_jalret, dir_in, dir_out);
stack_module #(8,64) STACK_DATA(clk, reset, s_we_stack_data, s_pushpop, RD2, stack_to_mux4);
~~~


####  3.- Puertos de entrada y salida

Se creó un módulo que contiene ambos puerto. Esta decisión fue tomada para darle más modularidad al código. 

 ![PortsModule](/recursos/PortsModule.png)

### [Enlace a diseño en DRAW.IO](https://drive.google.com/file/d/1nBWm-PRCHsdRkl4STRu-STPYZ3bZ16Lt/view?usp=sharing)


## Estructura de juego de instrucciones para el compilador

La estructura de las instrucciones fue creada de la siguiente forma: 
~~~
4 4 4 4  MOV     0000
6 10 0 0 BEZ     100100
~~~
- Los primeros dígitos especifican el tamaño de los registros, en el ejemplo hay 4 registros de 4 bits 
  - Deben ser 4 registros siempre aunque se tengan que poner a 0 para completar los 16 bits
- El siguiente parametro declara el nombre de la instrucción.
  - Deben ser nombres en MAYÚSCULAS
- El último parámetro especifica el OPCODE

## Instrucciones

<center>

| R1 | R2 | R3 | R4 | NEM | OPCODE |
|:-:|:-:|:-:|:-:|:---:|------|
| 4  | 4  |4  |4   | MOV    |  0000   |
| 4  | 4  |4  |4   | NOT    |  0001   |
| 4  | 4  |4  |4   | ADD    |  0010   |
| 4  | 4  |4  |4   | SUB    |  0011   |
| 4  | 4  |4  |4   | AND    |  0100   |
| 4  | 4  |4  |4   | OR     |  0101   |
| 4  | 4  |4  |4   | NEG1   |  0110   |
| 4  | 4  |4  |4   | NEG2   |  0111   |
| 4  | 8  |0  |4   | LI     |  1000   |
| 6  | 10 | 0 | 0  | BEZ    |  100100 |
| 6  | 10 | 0 | 0  | BNZ    |  100101 |
| 6  | 10 | 0 | 0  | JUMP   |  100110 |
| 6  | 2  |4  |4   | INPUT  |  100111 |
| 6  | 2  |4  |4   | OUTPUT |  101000 |
| 6  | 10 | 0 | 0  | JAL    |  101001 |
| 6  | 10 | 0 | 0  | RET    |  101010 |   
| 6  | 2  |4  |4   | PUSH   |  101011 |       
| 6  | 2  |4  |4   | POP    |  101100 |

 
 <center>

 ![Instrucciones](/recursos/inst.png)