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

```
#### 3.1.2. Parámetros

1. `DISPLAY_REFRESH`: Define la cantidad de ciclos de reloj para refrescar el display, para este caso, a 27000Hz.

#### 3.1.3. Entradas y salidas:

1. `clk_i`: Señal de reloj que sincroniza las operaciones del módulo.
2. `rst_i`: Señal de reinicio para inicializar los registros.
3. `bcd_i [15:0]`: Entrada de 16 bits que contiene el valor en BCD a mostrar (4 dígitos).
4. `anodo_o [1:0]`: Controla qué dígito del display está activo.
5. `catodo_o [6:0]`: Controla los segmentos del display para representar el dígito en BCD.
6. `cuenta_salida`: Contador de refresco para el display.
7. `digito_o [3:0]`: Registro que almacena el dígito actual a mostrar en el display.
8. `en_conmutador`: Señal que indica cuándo cambiar entre dígitos.
9. `contador_digitos [1:0]`: Registro que indica si se está mostrando la unidad, decena, centena o millar.
    
##### Descripción del módulo:

El módulo `module_7_segments` está diseñado para controlar un display de 7 segmentos multiplexado, permitiendo la visualización de un valor BCD de 16 bits, que representa hasta 4 dígitos. Utiliza una señal de reloj (`clk_i`) y una señal de reinicio activo en alto (`rst_i`) para sincronizar su funcionamiento. Un contador interno de refresco (`cuenta_salida`) se utiliza para gestionar la frecuencia de conmutación entre los distintos dígitos del display, con un parámetro configurable `DISPLAY_REFRESH` que determina la velocidad de actualización del display. El módulo implementa un contador de 2 bits (`contador_digitos`) que selecciona el dígito actual a visualizar, activando el correspondiente ánodo mientras desactiva los demás. La conversión de cada dígito BCD a su representación en el display de 7 segmentos se realiza mediante una lógica combinacional que asigna la salida de catodo (`catodo_o`) en función del dígito seleccionado.

#### 3.1.4. Criterios de diseño




### 3.2 Módulo 2
#### 3.2.1 Module_bin_to_bcd
```SystemVerilog
module bin_to_bcd (
    input [11:0] binario,  // Entrada binaria de 12 bits
    output reg [15:0] bcd   // Salida BCD de 16 bits (4 dígitos)
);


```
#### 3.2.2. Parámetros

No se definen parámetros para este módulo

#### 3.2.3. Entradas y salidas:
##### Descripción de la entrada:

1. `binario [11:0]` : Esta es una entrada de 12 bits que representa un número en formato binario. El rango de valores que puede aceptar va de 0 a 4095 (en decimal).
2. `bcd [15:0]`: Esta es la salida de 16 bits que representa el número en formato BCD (Decimal Codificado en Binario), permitiendo representar hasta 4 dígitos decimales.

##### Descripción del módulo:



#### 3.2.4. Criterios de diseño





### 3.3 Módulo 3
#### 3.3.1. module_BoothMul
```SystemVerilog
module BoothMul(
    input clk,                      // Señal de reloj
    input rst,                      // Señal de reinicio (activa bajo)
    input start,                    // Señal para iniciar la multiplicación
    input signed [7:0] A,           // Operando A (máximo 99)
    input signed [7:0] B,           // Operando B (máximo 99)
    output reg signed [15:0] Y,     // Resultado (máximo 9999)
    output reg valid                // Señal de validación de resultado
);

```
#### 3.3.2. Parámetros

No se definen parámetros para este módulo

#### 3.3.3. Entradas y salidas:
##### Descripción de la entrada:

1. `clk`: Señal de reloj que sincroniza las operaciones del módulo.
2. `rst`: Señal de reinicio para inicializar los registros.
3. `start`: .
4. `A [7:0]`: .
5. `B [7:0]`: .
6. `Y [15:0]`: .
7. `valid`: .


##### Descripción del módulo:



#### 3.3.4. Criterios de diseño



### 3.4 Módulo 4
#### 3.4.1. Module_col_shift_register
```SystemVerilog
module col_shift_register (
    input logic slow_clk,          // Entrada del reloj lento (1 KHz)
    input logic rst,               // Señal de reinicio
    input logic key_pressed,
    output logic [3:0] col_shift_reg, // Registro de desplazamiento de columnas
    output logic [1:0] column_index  // Índice de la columna activa
);


```
#### 3.4.2. Parámetros

No se definen parámetros para este módulo

#### 3.4.3. Entradas y salidas:
##### Descripción de la entrada:

1. `slow_clk`:.
2. `rst`: Señal de reinicio para inicializar los registros.
3. `key_pressed`: .
4. `col_shift_reg [3:0]`: .
5. `column_index [1:0]`: .


##### Descripción del módulo:



#### 3.4.4. Criterios de diseño 



### 3.5 Módulo 5
#### 3.5.1 Module_debouncer
```SystemVerilog
module debouncer (
    input clk,             // Reloj del sistema
    input rst,             // Reset
    input noisy_signal,    // Señal ruidosa (directamente del teclado matricial)
    output reg clean_signal // Señal limpia (sin rebote)
);


```
#### 3.5.2. Parámetros

1. `DEBOUNCE_TIME` : Tiempo de filtro para eliminar rebotes.

#### 3.5.3. Entradas y salidas:
##### Descripción de la entrada:

1. `clk` : Esta es la señal de reloj principal que sincroniza el funcionamiento del módulo.
2. `rst`: Esta es la señal de reinicio que, al ser activada, restablece el módulo a su estado inicial.
3. `noisy_signal`: Esta entrada representa la señal que puede contener rebotes, como un botón mecánico o un interruptor.
4. `clean_signal`: Esta es la salida de la señal limpia, que se produce sin rebotes, proporcionando una señal estable a la salida.

##### Descripción del módulo:

El módulo `debouncer` está diseñado para eliminar el efecto de rebote en señales digitales, como las que provienen de botones. Utiliza un contador que se incrementa en cada ciclo de reloj mientras la señal de entrada `noisy_signal` varía de manera diferente a la última señal limpia. Si la señal es constante y coincide con `clean_signal`, el contador se reinicia a cero. En caso de que se detecte un cambio en la señal ruidosa, el contador comienza a contar. Una vez que el contador alcanza el tiempo definido por `DEBOUNCE_TIME`, se actualiza `clean_signal` con el valor actual de `noisy_signal`, garantizando que cualquier cambio en la señal de entrada sea estable antes de que se refleje en la salida

#### 3.5.4. Criterios de diseño



### 3.6 Módulo 6
#### 3.6.1 Module_FSM_input_control
```SystemVerilog
module fsm_control(
    input logic clk,
    input logic rst,
    input logic key_pressed,       // Señal de tecla presionada
    input logic [2:0] is_sign_key,       // Señal que indica si la tecla ingresada es un signo
    output logic enable_A,         // Enable para almacenar A
    output logic enable_B,         // Enable para almacenar B
    output logic enable_sign,       // Enable para almacenar el signo
    output logic enable_operacion  // Enable para ejecutar la operación
);


```
#### 3.6.2. Parámetros

No se definen parámetros para este módulo

#### 3.6.3. Entradas y salidas:

1. `clk`: Señal de reloj que sincroniza las operaciones del módulo.
2. `rst`: Señal de reinicio para inicializar los registros.
3. `key_pressed`: .
4. `is_sign_key [2:0]`: .
5. `enable_A`: .
6. `enable_B`: .
7. `enable_sign`: .
8. `enable_sign`: .
9. `enable_operacion`: .
    
##### Descripción del módulo:



#### 3.6.4. Criterios de diseño



### 3.7 Módulo 7
#### 3.7.1 Module_freq_divider
```SystemVerilog
// Módulo divisor de frecuencia que divide un reloj de 27 MHz para generar un reloj lento (1 KHz)
module freq_divider (
    input logic clk,         // Entrada del reloj (27 MHz)
    input logic rst,         // Señal de reinicio
    output logic slow_clk    // Salida del reloj lento (1 KHz)
);


```
#### 3.7.2. Parámetros

No se definen parámetros para este módulo

#### 3.7.3. Entradas y salidas:

1. `clk`: Señal de reloj que sincroniza las operaciones del módulo.
2. `rst`: Señal de reinicio para inicializar los registros.
3. `slow_clk`:.

    
##### Descripción del módulo:



#### 3.7.4. Criterios de diseño



### 3.8 Módulo 8
#### 3.8.1 Module_number_storage
```SystemVerilog
module number_storage(
    input logic clk,
    input logic rst,
    input logic [3:0] key_value,     // Valor ingresado desde el teclado (4 bits)
    input logic key_pressed,          // Señal de tecla presionada
    input logic [2:0] is_sign_key,   // Señal para identificar el tipo de tecla
    input logic signo,                // Señal que indica si es un signo de operación
    input logic enable_A,             // Enable para almacenar A
    input logic enable_B,             // Enable para almacenar B
    input logic enable_sign,          // Enable para almacenar el signo
    output logic [7:0] A,             // Salida del operando A
    output logic [7:0] B,             // Salida del operando B
    output logic [7:0] temp_value,    // Salida temporal para mostrar en display
    output logic [15:0] mul_result,   // Resultado de la multiplicación
    output logic mul_valid            // Señal de validación del resultado de la multiplicación
);

```
#### 3.8.2. Parámetros

No se definen parámetros para este módulo

#### 3.8.3. Entradas y salidas:

1. `clk`: Señal de reloj que sincroniza las operaciones del módulo.
2. `rst`: Señal de reinicio para inicializar los registros.
3. `key_value [3:0]`: .
4. `key_pressed`: .
5. `is_sign_key [2:0]`: .
6. `signo`: .
7. `enable_A`: .
8. `enable_B`: .
9. `enable_sign`: .
10. `A [7:0]`: .
11. `B [7:0]`: .
12. `temp_value [7:0]`: .
13. `mul_result [15:0]`: .
14. `mul_valid`: .
    
##### Descripción del módulo:



#### 3.2.4. Criterios de diseño


### 3.9 Módulo 9
#### 3.9.1 Module_row_scanner
```SystemVerilog
module row_scanner (
    input logic slow_clk,
    input logic rst,
    input logic [3:0] col_shift_reg,
    input logic [3:0] row_in,
    output logic [3:0] key_value,
    output logic key_pressed,
    output logic [2:0] is_sign_key
);


```
#### 3.9.2. Parámetros

No se definen parámetros para este módulo

#### 3.9.3. Entradas y salidas:

1. `slow_clk`: .
2. `rst`: Señal de reinicio para inicializar los registros.
3. `col_shift_reg [3:0]`: .
4. `row_in [3:0]`: .
5. `key_value [3:0]`: .
6. `key_pressed`: .
7. `is_sign_key [2:0]`: .

    
##### Descripción del módulo:



#### 3.9.4. Criterios de diseño



### 4. Testbench
Con los modulos listos, se trabajo en un testbench para poder ejecutar todo de la misma forma y al mismo tiempo, y con ello, poder observar las simulaciones y obtener una mejor visualización de como funciona todo el código. 
```SystemVerilog
`timescale 1ns / 1ps

module tb_module_top;

    // Señales de entrada
    logic clk;
    logic rst;
    logic [3:0] row_in;

    // Señales de salida
    logic [3:0] col_out;
    logic [6:0] catodo_po;
    logic [3:0] anodo_po;
    logic enable_operacion;

    // Instancia del módulo a probar
    module_top uut (
        .clk(clk),
        .rst(rst),
        .row_in(row_in),
        .col_out(col_out),
        .catodo_po(catodo_po),
        .anodo_po(anodo_po),
        .enable_operacion(enable_operacion)
    );

    // Generación de reloj
    always #5 clk = ~clk; // Periodo del reloj = 10 ns (100 MHz)

    // Procedimiento inicial
    initial begin
        // Inicialización
        clk = 0;
        rst = 0;
        row_in = 4'b0000;

        // Reinicio
        #10 rst = 1;
        #10 rst = 0;
        #20 rst = 1;

        // Simular entrada de teclas
        @(posedge clk);
        row_in = 4'b1000; // Simula la pulsación de la primera fila
        #20 row_in = 4'b0100; // Simula la pulsación de la segunda fila
        #20 row_in = 4'b0010; // Simula la pulsación de la tercera fila
        #20 row_in = 4'b0001; // Simula la pulsación de la cuarta fila
        #20 row_in = 4'b0000; // Ninguna tecla presionada

        // Simular operaciones específicas
        @(posedge clk);
        row_in = 4'b1101; // Presionar tecla D para activar operación
        #40 row_in = 4'b0000; // Soltar la tecla

        // Esperar algunos ciclos para observar la salida
        #100;

        // Finalizar la simulación
        $stop;
    end

    // Monitoreo de señales
    initial begin
        $monitor("Time=%0t | clk=%b | rst=%b | row_in=%b | col_out=%b | catodo_po=%b | anodo_po=%b | enable_operacion=%b",
                 $time, clk, rst, row_in, col_out, catodo_po, anodo_po, enable_operacion);
    end
endmodule

```
#### Descripción del testbench 



#### 4.1.1. Parámetros


  
#### 4.1.2. Entradas y salidas:


#### 4.1.3. Criterios de diseño






### Otros modulos
En este apartado, se colocará el ultimo modulo, el cual corresponde a la unión de los 4 modulos para poder ejecutar un Makefile de manera correcta y su respectiva sincronización.
```SystemVerilog
module module_top (
    input logic clk,
    input logic rst,
    input logic [3:0] row_in,        // Entrada de las filas del teclado
    output logic [3:0] col_out,       // Salida de las columnas del teclado
    output logic [6:0] catodo_po,     // Señales para el catodo del display de 7 segmentos
    output logic [3:0] anodo_po,       // Señales para el ánodo del display de 7 segmentos
    output logic enable_operacion     // Señal que indica si se debe realizar la operación
);
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



