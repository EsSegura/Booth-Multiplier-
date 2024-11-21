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

###### Entradas:
1. `clk_i`: Señal de reloj que sincroniza las operaciones del módulo.
2. `rst_i`: Señal de reinicio para inicializar los registros.
3. `bcd_i [15:0]`: Entrada de 16 bits que contiene el valor en BCD a mostrar (4 dígitos).
###### Salidas:
1. `anodo_o [1:0]`: Controla qué dígito del display está activo.
2. `catodo_o [6:0]`: Controla los segmentos del display para representar el dígito en BCD.
    
##### Descripción del módulo:

El módulo `module_7_segments` está diseñado para controlar un display de 7 segmentos multiplexado, permitiendo la visualización de un valor BCD de 16 bits, que representa hasta 4 dígitos. Utiliza una señal de reloj (`clk_i`) y una señal de reinicio activo en alto (`rst_i`) para sincronizar su funcionamiento. Un contador interno de refresco (`cuenta_salida`) se utiliza para gestionar la frecuencia de conmutación entre los distintos dígitos del display, con un parámetro configurable `DISPLAY_REFRESH` que determina la velocidad de actualización del display. El módulo implementa un contador de 2 bits (`contador_digitos`) que selecciona el dígito actual a visualizar, activando el correspondiente ánodo mientras desactiva los demás. La conversión de cada dígito BCD a su representación en el display de 7 segmentos se realiza mediante una lógica combinacional que asigna la salida de catodo (`catodo_o`) en función del dígito seleccionado.

#### 3.1.4. Criterios de diseño

![module_7seg](https://github.com/user-attachments/assets/4ce7d2ca-9f3a-40e8-9b7b-b2de8b627ef8)



![7seg](https://github.com/user-attachments/assets/61968f63-cb46-4d7c-aec9-9bbaa2c311be)





### 3.2 Módulo 2
#### 3.2.1 Module_bin_to_bcd
```SystemVerilog
module bin_to_bcd (
    input [15:0] binario,  // Entrada binaria de 12 bits
    output reg [15:0] bcd   // Salida BCD de 16 bits (4 dígitos)
);


```
#### 3.2.2. Parámetros

No se definen parámetros para este módulo

#### 3.2.3. Entradas y salidas:
##### Descripción de la entrada:
###### Entradas:
1. `binario [15:0]` : Esta es una entrada de 16 bits que representa un número en formato binario. El rango de valores que puede aceptar va de 0 a 4095 (en decimal).
###### Salidas:
1. `bcd [15:0]`: Esta es la salida de 16 bits que representa el número en formato BCD (Decimal Codificado en Binario), permitiendo representar hasta 4 dígitos decimales.

##### Descripción del módulo:
El módulo `bin_to_bcd` realiza la conversión de un número binario de 16 bits a su representación en formato BCD utilizando el algoritmo Double Dabble. Este algoritmo consiste en ajustar cada grupo de 4 bits en la salida BCD (dígitos decimales) si su valor es mayor o igual a 5, y luego desplazar los bits hacia la izquierda, agregando los bits de la entrada binaria uno por uno.


#### 3.2.4. Criterios de diseño

![module_bintobcd](https://github.com/user-attachments/assets/d72dae75-4d0e-41e7-9d13-168f48319ee5)



![bin2bcd](https://github.com/user-attachments/assets/5923631f-9497-4010-9d2d-51d0df2b031a)





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

###### Entradas:
1. `clk`: Señal de reloj que sincroniza las operaciones del módulo.
2. `rst`: Señal de reinicio para inicializar los registros.
3. `start`: Señal para iniciar la operación de multiplicación. Debe ser activa en alto.
4. `A [7:0]`: Primer operando, un número entero con signo (máximo valor absoluto: 99).
5. `B [7:0]`: Segundo operando, un número entero con signo (máximo valor absoluto: 99).
###### Salidas:
1. `Y [15:0]`: Resultado de la multiplicación, un entero con signo de 16 bits
2. `valid`: Señal de validación que indica cuándo el resultado en `Y` es válido.


##### Descripción del módulo:

El módulo `BoothMul` implementa el algoritmo de Booth para realizar multiplicaciones de números con signo mediante una máquina de estados finitos (FSM). Al recibir la señal de inicio (`start`), el módulo pasa del estado `IDLE` a `START`, inicializando registros como `Y_temp` con el operando `A` y multiplicand con `B`. El algoritmo utiliza un código Booth de 2 bits generado dinámicamente a partir de los bits menos significativos del producto parcial (`Y_temp`) para determinar si debe sumar, restar o ignorar el multiplicador en cada iteración, seguido de un desplazamiento aritmético hacia la derecha para ajustar el resultado parcial. Tras 8 iteraciones, el producto final se almacena en `Y`, y la señal valid se activa para indicar que el resultado es válido. Al completarse la operación, el módulo regresa al estado `IDLE`, listo para una nueva multiplicación.

#### 3.3.4. Criterios de diseño

![module_Booth](https://github.com/user-attachments/assets/d0ab579b-b66f-4dfa-9913-4dbee7f8d1b2)



![BoothMulFSM](https://github.com/user-attachments/assets/4467dd90-5121-43b1-9aa5-3231d2396e2f)




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
###### Entradas:
1. `slow_clk`: Señal de reloj lento (1 KHz).
2. `rst`: Señal de reinicio para inicializar los registros.
3. `key_pressed`: Señal que indica si una tecla está presionada.
###### Salidas:
1. `col_shift_reg [3:0]`: Registro de desplazamiento de 4 bits para activar columnas.
2. `column_index [1:0]`: Índice de la columna activa (2 bits).


##### Descripción del módulo:
El módulo `col_shift_register` implementa un registro de desplazamiento controlado por un reloj lento y reinicio. Al activarse la señal de reinicio (`rst`), el registro de desplazamiento `col_shift_reg` se inicializa activando la primera columna (valor 4'b0001), y el índice de columna (`column_index`) se pone en cero. En cada flanco positivo de `slow_clk`, si no se detecta una tecla presionada (`!key_pressed`), el módulo desplaza el bit activo en `col_shift_reg` hacia la siguiente posición circular, lo que activa secuencialmente las columnas. Simultáneamente, incrementa el índice de columna para indicar la posición activa actual. 

#### 3.4.4. Criterios de diseño 

![module_col_shift_reg](https://github.com/user-attachments/assets/78454ff6-086c-46a0-88a8-3456abd9d806)



![col_shift_reg](https://github.com/user-attachments/assets/e68ecc15-8137-457a-af1c-431005b8bf29)



### 3.5 Módulo 5
#### 3.5.1 Module_debouncer
```SystemVerilog
module debouncer (
    input clk,             // Reloj del sistema
    input rst,             // Reset
    input noisy_signal,    // Señal ruidosa (directamente del teclado matricial)
    output reg clean_signal // Señal limpia (sin rebote)
);
    parameter DEBOUNCE_TIME = 27000;

```
#### 3.5.2. Parámetros

1. `DEBOUNCE_TIME` : Tiempo de filtro para eliminar rebotes.

#### 3.5.3. Entradas y salidas:
##### Descripción de la entrada:
###### Entradas:
1. `clk` : Esta es la señal de reloj principal que sincroniza el funcionamiento del módulo.
2. `rst`: Esta es la señal de reinicio que, al ser activada, restablece el módulo a su estado inicial.
3. `noisy_signal`: Esta entrada representa la señal que puede contener rebotes, como un botón mecánico o un interruptor.
###### Salidas:
1. `clean_signal`: Esta es la salida de la señal limpia, que se produce sin rebotes, proporcionando una señal estable a la salida.

##### Descripción del módulo:

El módulo `debouncer` está diseñado para eliminar el efecto de rebote en señales digitales, como las que provienen de botones. Utiliza un contador que se incrementa en cada ciclo de reloj mientras la señal de entrada `noisy_signal` varía de manera diferente a la última señal limpia. Si la señal es constante y coincide con `clean_signal`, el contador se reinicia a cero. En caso de que se detecte un cambio en la señal ruidosa, el contador comienza a contar. Una vez que el contador alcanza el tiempo definido por `DEBOUNCE_TIME`, se actualiza `clean_signal` con el valor actual de `noisy_signal`, garantizando que cualquier cambio en la señal de entrada sea estable antes de que se refleje en la salida.

#### 3.5.4. Criterios de diseño
![module_debouncer](https://github.com/user-attachments/assets/dc9a742c-4447-4b1f-b284-cba0f7186ec6)




![debouncer](https://github.com/user-attachments/assets/6792a177-09d8-4d76-bfc9-c888ad45f963)


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

###### Entradas:
1. `clk`: Señal de reloj que sincroniza las operaciones del módulo.
2. `rst`: Señal de reinicio para inicializar los registros.
3. `key_pressed`: Señal que indica si una tecla ha sido presionada.
4. `is_sign_key [2:0]`: Señal de 3 bits que identifica si la tecla ingresada corresponde a un signo.
###### Salidas:
1. `enable_A`: Señal para habilitar el almacenamiento del operando A.
2. `enable_B`: Señal para habilitar el almacenamiento del operando B.
3. `enable_sign`: Señal para habilitar el almacenamiento del signo de la operación.
4. `enable_operacion`: Señal para habilitar la ejecución de la operación.
    
##### Descripción del módulo:

El módulo `fsm_control` implementa una máquina de estados finitos (FSM) que gestiona el flujo de una calculadora básica. La FSM comienza en el estado `IDLE`, esperando la entrada del primer operando (`A`). Cuando se detecta una tecla presionada (`key_pressed`) y no corresponde a un signo (`is_sign_key == 3'b000`), se habilita `enable_A` para almacenar `A` y se avanza al estado `OPERANDO_A`. Si se detecta un signo (`is_sign_key == 3'b001`), se habilita `enable_sign` y se pasa al estado `SIGN`. Después, se espera el ingreso del segundo operando (`B`) en el estado `OPERANDO_B`, habilitando `enable_B`. Una vez completados los operandos y el signo, se transita al estado `READY`, donde se habilita enable_operacion para ejecutar la operación. La FSM vuelve a IDLE tras completar la operación, si se detecta un signo de terminación (por ejemplo, `=` con `is_sign_key == 3'b111`). 

#### 3.6.4. Criterios de diseño

![FSM_control](https://github.com/user-attachments/assets/31398c0d-d855-424d-b61f-8f753450d47a)



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

###### Entradas:
1. `clk`: Señal de reloj que sincroniza las operaciones del módulo.
2. `rst`: Señal de reinicio para inicializar los registros.
###### Salidas:
1. `slow_clk`:.Señal de reloj lento de 1 kHz generada a partir del reloj de entrada.

    
##### Descripción del módulo:

El módulo `freq_divider` implementa un divisor de frecuencia que reduce un reloj de alta frecuencia de 27 MHz a una señal más lenta de 1 kHz, utilizando un contador interno de 25 bits (`clk_divider_counter`). El módulo opera reiniciando el contador cuando alcanza un valor predeterminado de 26,999 (equivalente a 27,000 ciclos). Cada vez que el contador llega al límite, se invierte el estado de la salida `slow_clk`, generando un ciclo de 1 kHz. Si se activa la señal de reinicio (`rst`), el contador y la salida se reinician a sus valores iniciales.

#### 3.7.4. Criterios de diseño
![module freq_div](https://github.com/user-attachments/assets/2b7fdc88-01f0-4fb8-ae14-7a41d76e836f)



![freq_div](https://github.com/user-attachments/assets/3de77942-048f-41ee-9b99-5cde4f48d928)



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

###### Entradas:
1. `clk`: Señal de reloj que sincroniza las operaciones del módulo.
2. `rst`: Señal de reinicio para inicializar los registros.
3. `key_value [3:0]`: Valor ingresado desde el teclado (4 bits).
4. `key_pressed`: Señal que indica si se presionó una tecla.
5. `is_sign_key [2:0]`: Señal para identificar el tipo de tecla (número, signo, etc.).
6. `signo`: Señal que indica si la operación es suma o resta.
7. `enable_A`: Habilitador para almacenar el operando A.
8. `enable_B`: Habilitador para almacenar el operando B.
9. `enable_sign`: Habilitador para almacenar el signo de operación.
###### Salidas:
1. `A [7:0]`: Almacena el operando A (8 bits).
2. `B [7:0]`: Almacena el operando B (8 bits).
3. `temp_value [7:0]`: Valor temporal para visualizar en un display (16 bits).
4. `mul_result [15:0]`: Resultado de la multiplicación (16 bits).
5. `mul_valid`: Señal que valida si la multiplicación es válida.
    
##### Descripción del módulo:
El módulo `number_storage` maneja el almacenamiento de números y operaciones matemáticas básicas a partir de las entradas del teclado. Los valores numéricos ingresados se almacenan en `A` o `B` según el habilitador activo (`enable_A` o `enable_B`), mientras que el tipo de operación (suma, resta, o multiplicación) se determina mediante la señal `is_sign_key`. Se utiliza un valor temporal (`temp_value`) para construir números multi-dígito, actualizándose con cada tecla presionada.

Además, el módulo instancia un multiplicador Booth (`BoothMul`) que realiza multiplicaciones entre `A` y `B` cuando se detecta una tecla de multiplicación. El resultado de la operación se almacena en `mul_result` y se valida con `mul_valid`. El diseño incluye detección de flancos ascendentes para asegurar la correcta captura de entradas y permite resetear el sistema con la señal `rst`.


#### 3.2.4. Criterios de diseño

![module_num_stor](https://github.com/user-attachments/assets/cfc7963f-8d47-4b11-bd46-7d5c6250b8b6)



![numstorage](https://github.com/user-attachments/assets/78e6abee-ebaa-426c-8af3-6511472e1dc2)



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

###### Entradas:
1. `slow_clk`: Señal de reloj lento.
2. `rst`: Señal de reinicio para inicializar los registros.
3. `col_shift_reg [3:0]`: egistro de desplazamiento que activa las columnas del teclado matricial (4 bits).
4. `row_in [3:0]`: Señal que representa las filas activas del teclado (4 bits).
###### Salidas:
1. `key_value [3:0]`: Valor de la tecla presionada en formato binario (4 bits).
2. `key_pressed`: Señal que indica si se ha presionado una tecla (1 = presionada, 0 = no presionada).
3. `is_sign_key [2:0]`: Identifica si la tecla es un signo de operación (3 bits).

    
##### Descripción del módulo:

El módulo `row_scanner` se utiliza para identificar teclas presionadas en un teclado matricial de 4x4. Combina las señales de las filas (`row_in`) y las columnas (`col_shift_reg`) activas para determinar qué tecla fue presionada.

Cada combinación de fila y columna se traduce en un código binario de 4 bits (`key_value`), que representa el valor numérico o el carácter de la tecla. Para teclas con signos de operación (*, #, A, B, C, D), también se genera una señal `is_sign_key` que clasifica el tipo de operación.

#### 3.9.4. Criterios de diseño


![module_row_scan](https://github.com/user-attachments/assets/d8a335f8-eae7-409c-ba15-21f292c43b19)


![row_scan](https://github.com/user-attachments/assets/4893b8c0-4ae9-4c14-bb70-de9dc4371811)



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

No se definen parámetros para este testbench

#### 4.1.1. Parámetros


  
#### 4.1.2. Entradas y salidas:
Se utilizan las mismas entradas y salida que en el modulo top del diseño, y se insertan al llamarlo.

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
1. `clk`: Señal de reloj que sincroniza todo el módulo. Esta señal es utilizada para que todos los submódulos puedan operar de manera sincronizada y coordinar el flujo de datos a través del sistema.
2. `rst`: Señal de reset asíncrona. Cuando se activa, todos los submódulos internos y el módulo principal se reinician, asegurando que el sistema regrese a un estado conocido antes de iniciar cualquier operación.
3. `row_in [3 : 0]` : .
4. `col_out [3:0]` : .
5. `anodo_po`: Señal de salida para los pines de anodo del display de 7 segmentos.
6. `catodo_po`: Señal de salida para los pines de cátodo del display de 7 segmentos.
7. `enable_operacion` : .

##### Descripción del módulo:



#### Criterios de diseño


![top](https://github.com/user-attachments/assets/dbc5a156-71f2-4414-a0e7-bc9696ad6590)


## 5. Consumo de recursos


   

## 6. Observaciones/Aclaraciones



## 7. Problemas encontrados durante el proyecto



