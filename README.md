# Calculadora multiplicadora mediante el algoritmo de Booth.
### Estudiantes:
-Christian Aparicio Cambronero

-Eric Castro Velazquez

-Esteban Segura García 
## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays
- **CLK**: Clock
- **RST**: Reset

## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

[1] Simple Tutorials for Embedded Systems, "*How to Create a 7 Segment Controller in Verilog? | Xilinx FPGA Programming Tutorials*", YouTube, 3 de octubre de 2018. Available: https://www.youtube.com/watch?v=v2CM8RaEeQU&t=116s

[2] Anas Salah Eddin, "*49 - Verilog Description of FSMs*", YouTube, 26 de marzo de 2018. Available: https://www.youtube.com/watch?v=j2v2s7caBwI

[3] Anas Salah Eddin, "*M3-6-Debouncing Circuit (FSM)*", YouTube, 4 de septiembre de 2020. Available: https://www.youtube.com/watch?v=wLqPSPC7dWE

## 3. Desarrollo

### 3.0 Descripción general del sistema


### 3.1 Módulo 1
#### 3.1.1. module_7_segments
```SystemVerilog
module module_7_segments # (
    parameter DISPLAY_REFRESH = 27000
)(
    input clk_i,
    input rst_i,
    input [15 : 0] bcd_i,  // 16 bits para 4 dígitos BCD
    output reg [3 : 0] anodo_o,  // 4 bits para los 4 anodos
    output reg [6 : 0] catodo_o
);

    localparam WIDTH_DISPLAY_COUNTER = $clog2(DISPLAY_REFRESH);
    reg [WIDTH_DISPLAY_COUNTER - 1 : 0] cuenta_salida;

    reg [3 : 0] digito_o;
    reg en_conmutador;
    reg [1:0] contador_digitos;  // 2 bits para contar hasta 4

    // Output refresh counter
    always @ (posedge clk_i) begin
        if(!rst_i) begin
            cuenta_salida <= DISPLAY_REFRESH - 1;
            en_conmutador <= 0;
        end
        else begin
            if(cuenta_salida == 0) begin
                cuenta_salida <= DISPLAY_REFRESH - 1;
                en_conmutador <= 1;
            end
            else begin
                cuenta_salida <= cuenta_salida - 1'b1;
                en_conmutador <= 0;
            end
        end
    end

    // 2-bit counter to select the digit (0 to 3)
    always @ (posedge clk_i) begin
        if(!rst_i) begin
            contador_digitos <= 0;
        end
        else begin 
            if(en_conmutador == 1'b1) begin
                contador_digitos <= contador_digitos + 1'b1;
            end
            else begin
                contador_digitos <= contador_digitos;
            end
        end
    end

    // Multiplexed digits
    always @(contador_digitos) begin
        digito_o = 0;
        anodo_o = 4'b1111;  // Todos los anodos apagados por defecto
        
        case(contador_digitos) 
            2'b00 : begin
                anodo_o  = 4'b1110;  // Activa display de unidades
                digito_o = bcd_i [3 : 0];   // Unidades
            end
            2'b01 : begin
                anodo_o  = 4'b1101;  // Activa display de decenas
                digito_o = bcd_i [7 : 4];   // Decenas
            end
            2'b10 : begin
                anodo_o  = 4'b1011;  // Activa display de centenas
                digito_o = bcd_i [11 : 8];  // Centenas
            end
            2'b11 : begin
                anodo_o  = 4'b0111;  // Activa display de millares
                digito_o = bcd_i [15 : 12]; // Millares
            end
            default: begin
                anodo_o  = 4'b1111;
                digito_o = 0;
            end
        endcase
    end

    // BCD to 7 segments
    always @ (digito_o) begin
        catodo_o  = 7'b1111111;
        
        case(digito_o)
            4'd0: catodo_o  = 7'b1000000;
            4'd1: catodo_o  = 7'b1111001;
            4'd2: catodo_o  = 7'b0100100;
            4'd3: catodo_o  = 7'b0110000;
            4'd4: catodo_o  = 7'b0011001;
            4'd5: catodo_o  = 7'b0010010;
            4'd6: catodo_o  = 7'b0000010;
            4'd7: catodo_o  = 7'b1111000;
            4'd8: catodo_o  = 7'b0000000;
            4'd9: catodo_o  = 7'b0010000;
            default: catodo_o  = 7'b1111111;
        endcase
    end

    

endmodule
```
#### 3.1.2. Parámetros

No se definen parámetros para este módulo.

#### 3.1.3. Entradas y salidas:



##### Descripción del módulo:


#### 3.1.4. Criterios de diseño




### 3.2 Módulo 2
#### 3.2.1 Module_bin_to_bcd
```SystemVerilog
module bin_to_bcd (
    input [11:0] binario,  // Entrada binaria de 12 bits
    output reg [15:0] bcd   // Salida BCD de 16 bits (4 dígitos)
);
    integer i;

    always @(*) begin
        // Inicializar BCD a 0
        bcd = 16'b0;

        // Proceso de conversión de binario a BCD
        for (i = 0; i < 12; i = i + 1) begin
            // Revisar y ajustar cada grupo de 4 bits si es necesario
            if (bcd[3:0] >= 5) 
                bcd[3:0] = bcd[3:0] + 4'd3;
            if (bcd[7:4] >= 5) 
                bcd[7:4] = bcd[7:4] + 4'd3;
            if (bcd[11:8] >= 5) 
                bcd[11:8] = bcd[11:8] + 4'd3;
            if (bcd[15:12] >= 5) 
                bcd[15:12] = bcd[15:12] + 4'd3;

            // Desplazar los bits del BCD hacia la izquierda y agregar el bit de binario
            bcd = {bcd[14:0], binario[11 - i]};
        end
    end
endmodule

```
#### 3.2.2. Parámetros



#### 3.2.3. Entradas y salidas:


    
##### Descripción del módulo:



#### 3.2.4. Criterios de diseño





### 3.3 Módulo 3
#### 3.3.1. module_bin_to_bcd
```SystemVerilog

```
#### 3.3.2. Parámetros

No se definen parámetros para este módulo

#### 3.3.3. Entradas y salidas:
##### Descripción de la entrada:



##### Descripción del módulo:

El módulo `bin_decimal` está diseñado para convertir un número binario de 16 bits en su equivalente en BCD de 16 bits. El proceso de conversión se realiza mediante un algoritmo de desplazamiento que itera a través de cada bit de la entrada binaria. En cada iteración, se verifica si alguno de los grupos de 4 bits en la salida BCD es mayor o igual a 5; si es así, se le suma 3 a ese grupo, siguiendo el método de corrección de BCD. Luego, el módulo desplaza el valor actual de BCD hacia la izquierda, incorporando el siguiente bit de la entrada binaria en la posición menos significativa. Este proceso se repite durante 12 ciclos, asegurando que todos los bits del número binario se conviertan adecuadamente en su representación BCD.

#### 3.3.4. Criterios de diseño



### 3.4 Módulo 4
#### 3.3.1. module_debouncer
```SystemVerilog

```
#### 3.3.2. Parámetros



#### 3.3.3. Entradas y salidas:
##### Descripción de la entrada:



##### Descripción del módulo:



#### 3.3.4. Criterios de diseño 



### 3.2 Módulo 2
#### 3.2.1 Module_7_segments
```SystemVerilog

```
#### 3.2.2. Parámetros



#### 3.2.3. Entradas y salidas:


    
##### Descripción del módulo:



#### 3.2.4. Criterios de diseño



### 3.2 Módulo 2
#### 3.2.1 Module_7_segments
```SystemVerilog

```
#### 3.2.2. Parámetros



#### 3.2.3. Entradas y salidas:


    
##### Descripción del módulo:



#### 3.2.4. Criterios de diseño



### 3.2 Módulo 2
#### 3.2.1 Module_7_segments
```SystemVerilog

```
#### 3.2.2. Parámetros



#### 3.2.3. Entradas y salidas:


    
##### Descripción del módulo:



#### 3.2.4. Criterios de diseño



### 3.2 Módulo 2
#### 3.2.1 Module_7_segments
```SystemVerilog

```
#### 3.2.2. Parámetros



#### 3.2.3. Entradas y salidas:


    
##### Descripción del módulo:



#### 3.2.4. Criterios de diseño



### 4. Testbench
Con los modulos listos, se trabajo en un testbench para poder ejecutar todo de la misma forma y al mismo tiempo, y con ello, poder observar las simulaciones y obtener una mejor visualización de como funciona todo el código. 
```SystemVerilog

```
#### Descripción del testbench 



#### 4.1.1. Parámetros


  
#### 4.1.2. Entradas y salidas:


#### 4.1.3. Criterios de diseño






### Otros modulos
En este apartado, se colocará el ultimo modulo, el cual corresponde a la unión de los 4 modulos para poder ejecutar un Makefile de manera correcta y su respectiva sincronización.
```SystemVerilog

```
#### Parámetros

No se definen parámetros para este módulo.

#### Entradas y salidas:
##### Descripción de la entrada:


##### Descripción del módulo:



#### Criterios de diseño



## 5. Consumo de recursos


   

## 6. Observaciones/Aclaraciones



## 7. Problemas encontrados durante el proyecto



