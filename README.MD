## CPU Monociclo
---
### [Enlace a diseño en DRAW.IO](https://drive.google.com/file/d/1nBWm-PRCHsdRkl4STRu-STPYZ3bZ16Lt/view?usp=sharing)


## Estructura de juego de instrucciones

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

 ![Instrucciones](/resources/inst.png)