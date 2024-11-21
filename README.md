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

    // Registros internos
    reg signed [15:0] Y_temp, next_Y_temp;        // Registro temporal para el cálculo
    reg [7:0] multiplicand, next_multiplicand;    // Operando multiplicador (B)
    reg [3:0] count, next_count;                  // Contador de iteraciones (máximo 8)
    reg [1:0] booth_code, next_booth_code;        // Código Booth (2 bits)
    reg next_valid;                               // Señal de validación para la salida
    reg state, next_state;                        // Estados de la FSM

    // Estados de la máquina de estados finitos (FSM)
    parameter IDLE = 1'b0;      // Estado inactivo (esperando para empezar)
    parameter START = 1'b1;     // Estado de cálculo

    // Bloque secuencial: actualización de registros
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Reinicio de los registros internos
            Y <= 16'd0;
            valid <= 1'b0;
            Y_temp <= 16'd0;
            multiplicand <= 8'd0;
            count <= 4'd0;
            booth_code <= 2'd0;
            state <= IDLE;
        end else begin
            // Actualización de los registros con los valores próximos
            Y <= Y_temp;
            valid <= next_valid;
            Y_temp <= next_Y_temp;
            multiplicand <= next_multiplicand;
            count <= next_count;
            booth_code <= next_booth_code;
            state <= next_state;
        end
    end

    // Lógica combinacional: implementación del algoritmo de Booth
    always @(*) begin
        // Valores predeterminados
        next_Y_temp = Y_temp;
        next_multiplicand = multiplicand;
        next_count = count;
        next_booth_code = booth_code;
        next_valid = 1'b0;
        next_state = state;

        case (state)
            IDLE: begin
                // Configuración inicial
                if (start) begin
                    // Inicializar Y_temp con A en los bits menos significativos (considerar signo)
                    next_Y_temp = {8'd0, A};  // Para manejar el signo de A adecuadamente
                    next_multiplicand = B;    // Cargar el multiplicador B
                    next_booth_code = {A[0], 1'b0};  // Inicializar el código Booth con el bit menos significativo de A y un bit extra
                    next_count = 4'd0;         // Reiniciar el contador de iteraciones
                    next_state = START;       // Cambiar al estado START para comenzar el cálculo
                end
            end

            START: begin
                // Operaciones de Booth según el código Booth
                case (booth_code)
                    2'b10: next_Y_temp = {Y_temp[15:8] - multiplicand, Y_temp[7:0]}; // Restar multiplicador B
                    2'b01: next_Y_temp = {Y_temp[15:8] + multiplicand, Y_temp[7:0]}; // Sumar multiplicador B
                    default: next_Y_temp = Y_temp; // No hacer nada (cuando booth_code es 00 o 11)
                endcase

                // Desplazamiento aritmético a la derecha (considerando el signo)
                next_Y_temp = next_Y_temp >>> 1;

                // Actualización del código Booth y contador
                next_booth_code = {Y_temp[1], Y_temp[0]};  // Nueva evaluación del código Booth con los 2 bits menos significativos de Y_temp
                next_count = count + 1'b1;                   // Incrementar el contador de iteraciones

                // Verificar si la multiplicación ha terminado (8 iteraciones)
                if (next_count == 4'd8) begin
                    next_valid = 1'b1;   // Señal de resultado válido
                    next_state = IDLE;   // Volver al estado IDLE para esperar una nueva operación
                end else begin
                    next_state = START; // Continuar en el estado START
                end
            end
        endcase
    end
endmodule
```
#### 3.3.2. Parámetros

No se definen parámetros para este módulo

#### 3.3.3. Entradas y salidas:
##### Descripción de la entrada:



##### Descripción del módulo:

El módulo `bin_decimal` está diseñado para convertir un número binario de 16 bits en su equivalente en BCD de 16 bits. El proceso de conversión se realiza mediante un algoritmo de desplazamiento que itera a través de cada bit de la entrada binaria. En cada iteración, se verifica si alguno de los grupos de 4 bits en la salida BCD es mayor o igual a 5; si es así, se le suma 3 a ese grupo, siguiendo el método de corrección de BCD. Luego, el módulo desplaza el valor actual de BCD hacia la izquierda, incorporando el siguiente bit de la entrada binaria en la posición menos significativa. Este proceso se repite durante 12 ciclos, asegurando que todos los bits del número binario se conviertan adecuadamente en su representación BCD.

#### 3.3.4. Criterios de diseño



### 3.4 Módulo 4
#### 3.3.1. Module_col_shift_register
```SystemVerilog
module col_shift_register (
    input logic slow_clk,          // Entrada del reloj lento (1 KHz)
    input logic rst,               // Señal de reinicio
    input logic key_pressed,
    output logic [3:0] col_shift_reg, // Registro de desplazamiento de columnas
    output logic [1:0] column_index  // Índice de la columna activa
);

    always_ff @(posedge slow_clk) begin
        if (!rst) begin
            col_shift_reg <= 4'b0001;    // Inicializar activando la primera columna
            column_index <= 2'b0;        // Inicializar el índice de columna
        end else if (!key_pressed) begin      
            // Desplazar el bit activo hacia la siguiente columna
            col_shift_reg <= {col_shift_reg[2:0], col_shift_reg[3]};
            column_index <= column_index + 1;  // Incrementar el índice de columna
        end
    end
endmodule

```
#### 3.3.2. Parámetros



#### 3.3.3. Entradas y salidas:
##### Descripción de la entrada:



##### Descripción del módulo:



#### 3.3.4. Criterios de diseño 



### 3.2 Módulo 5
#### 3.2.1 Module_debouncer
```SystemVerilog
module debouncer (
    input clk,             // Reloj del sistema
    input rst,             // Reset
    input noisy_signal,    // Señal ruidosa (directamente del teclado matricial)
    output reg clean_signal // Señal limpia (sin rebote)
);
    parameter DEBOUNCE_TIME = 27000; // Tiempo de espera para el filtro antirebote (aprox. 10 ms)
    reg [31:0] counter;              // Contador de tiempo para el antirebote
    reg noisy_signal_reg;            // Registro para almacenar el valor previo de la señal

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Inicialización en reset
            counter <= 0;
            clean_signal <= 0;
            noisy_signal_reg <= 0;
        end else begin
            // Detecta cambio en la señal ruidosa
            if (noisy_signal != noisy_signal_reg) begin
                noisy_signal_reg <= noisy_signal;  // Actualiza el registro de la señal ruidosa
                counter <= 0;                      // Reinicia el contador al detectar un cambio
            end else begin
                // Si la señal es estable durante el tiempo de DEBOUNCE_TIME
                if (counter < DEBOUNCE_TIME) begin
                    counter <= counter + 1; // Incrementa el contador
                end else begin
                    clean_signal <= noisy_signal;  // Actualiza la señal limpia
                end
            end
        end
    end
endmodule

```
#### 3.2.2. Parámetros



#### 3.2.3. Entradas y salidas:


    
##### Descripción del módulo:



#### 3.2.4. Criterios de diseño



### 3.2 Módulo 6
#### 3.2.1 Module_FSM_input_control
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

    // Estados
    typedef enum logic [2:0] {
        IDLE,
        OPERANDO_A,
        SIGN,
        OPERANDO_B,
        READY
    } state_t;

    state_t current_state, next_state;
    logic key_pressed_prev;        // Estado previo de la tecla
    logic [1:0] key_count;         // Contador de flancos detectados

    // Inicialización de variables
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            current_state <= IDLE;
            key_pressed_prev <= 0;
            key_count <= 0;
        end else begin
            current_state <= next_state;
            key_pressed_prev <= key_pressed; // Guardar estado previo de la tecla

            // Detectar flanco de tecla (de 0 a 1)
            if (key_pressed && !key_pressed_prev) begin
                // Incrementar contador solo si no es una tecla de signo
                if (is_sign_key == 3'b000) begin
                    key_count <= key_count + 1;
                end else if (is_sign_key == 3'b001) begin
                    key_count <= 3;  // Resetear contador a 3 cuando se detecta el signo
                end
            end
        end
    end

    // Lógica de transición de estados y detección de flancos
    always_comb begin
        // Deshabilitar enables por defecto
        enable_A = 0;
        enable_B = 0;
        enable_sign = 0;
        enable_operacion = 0;
        next_state = current_state;

        case (current_state)
            IDLE: begin
                if (key_count == 1) begin
                    enable_A = 1;
                    next_state = OPERANDO_A;
                end                    
            end

            OPERANDO_A: begin
                enable_A = 1;  // Habilitar almacenamiento de A
                if (key_count == 3)
                    next_state = SIGN;
            end

            SIGN: begin
                enable_sign = 1;  // Habilitar almacenamiento del signo
                if (is_sign_key == 3'b001) begin // si el signo es multiplicación
                    next_state = OPERANDO_B;
                end
            end    

            OPERANDO_B: begin
                enable_B = 1;  // Habilitar almacenamiento de B
                if (key_count == 5)  
                    next_state = READY;
            end

            READY: begin
                enable_operacion = 1;  // Habilitar operación
                if (is_sign_key == 3'b111) begin // si el signo es igual "="
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end
endmodule

```
#### 3.2.2. Parámetros



#### 3.2.3. Entradas y salidas:


    
##### Descripción del módulo:



#### 3.2.4. Criterios de diseño



### 3.2 Módulo 7
#### 3.2.1 Module_freq_divider
```SystemVerilog
// Módulo divisor de frecuencia que divide un reloj de 27 MHz para generar un reloj lento (1 KHz)
module freq_divider (
    input logic clk,         // Entrada del reloj (27 MHz)
    input logic rst,         // Señal de reinicio
    output logic slow_clk    // Salida del reloj lento (1 KHz)
);
    // Contador que se usa para dividir el reloj
    logic [24:0] clk_divider_counter;

    // Inicialización de slow_clk
    initial begin
        slow_clk = 1'b0; // Inicializa slow_clk en 0
    end

    always_ff @(posedge clk) begin
        if (!rst) begin
            clk_divider_counter <= 25'd0; // Reiniciar el contador al resetear
            slow_clk <= 1'b0;             // Inicializar el reloj lento
        end else begin
            // Contador para dividir el reloj
            if (clk_divider_counter == 25'd27000 - 1) begin // 27000 para obtener 1 KHz
                slow_clk <= ~slow_clk;        // Invertir el valor del reloj lento
                clk_divider_counter <= 25'd0; // Reiniciar el contador
            end else begin
                clk_divider_counter <= clk_divider_counter + 1; // Incrementar el contador
            end
        end
    end
endmodule

```
#### 3.2.2. Parámetros



#### 3.2.3. Entradas y salidas:


    
##### Descripción del módulo:



#### 3.2.4. Criterios de diseño



### 3.2 Módulo 8
#### 3.2.1 Module_number_storage
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

    // Registros internos para almacenar valores parciales
    logic [7:0] temp_A, temp_B;
    logic key_pressed_prev;           // Estado previo de la tecla
    logic load_value;                 // Señal para cargar el valor

    // Instanciación del módulo BoothMul
    logic booth_start;                // Señal para iniciar BoothMul
    BoothMul booth_mul_inst (
        .clk(clk),
        .rst(rst),
        .start(booth_start),
        .A(temp_A),
        .B(temp_B),
        .Y(mul_result),
        .valid(mul_valid)
    );

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            A <= 8'b0;
            B <= 8'b0;
            temp_A <= 8'b0;
            temp_B <= 8'b0;
            temp_value <= 8'b0;
            key_pressed_prev <= 1'b0;
            load_value <= 1'b0;
            signo <= 1'b0;
            booth_start <= 1'b0;
        end else begin
            key_pressed_prev <= key_pressed; // Detecta el flanco ascendente del botón

            // Detección de flanco positivo
            if (key_pressed && !key_pressed_prev) begin
                case (is_sign_key)
                    3'b000: begin // Se ingresó un nuevo número
                        temp_value <= (temp_value << 3) + (temp_value << 1) + key_value; // Multiplicación por 10
                        load_value <= 1'b1; // Señal para cargar el valor
                    end

                    3'b001: begin // Se ingresó un operando (por ejemplo, multiplicación)
                        // Guardar el valor actual y limpiar temp_value
                        if (enable_A) begin
                            temp_A <= temp_value;
                            A <= temp_A; // Actualizar la salida de A
                        end else if (enable_B) begin
                            temp_B <= temp_value;
                            B <= temp_B; // Actualizar la salida de B
                        end
                        temp_value <= 8'b0; // Limpiar el valor temporal para un nuevo ingreso
                        load_value <= 1'b0; // Señal para finalizar la carga
                    end

                    3'b010: begin // Se ingresó un operando de suma
                        signo <= 1'b0;
                    end

                    3'b100: begin // Se ingresó un operando de resta
                        signo <= 1'b1;
                    end

                    3'b111: begin // Tecla D, multiplicación con BoothMul
                        booth_start <= 1'b1;  // Iniciar la multiplicación con Booth
                    end

                    default: begin
                        load_value <= 1'b0; // Resetear la señal de carga
                    end
                endcase
            end else begin
                load_value <= 1'b0; // Resetear la señal de carga
                signo <= 1'b0;
                booth_start <= 1'b0;  // Detener la multiplicación cuando no se presiona la tecla
            end

            // Almacenar el valor temporal en A o B según el habilitador
            if (load_value) begin
                if (enable_A) begin
                    temp_A <= temp_value; // Almacenar el valor temporal en A
                    A <= temp_A;          // Actualizar la salida de A
                end else if (enable_B) begin
                    temp_B <= temp_value; // Almacenar el valor temporal en B
                    B <= temp_B;          // Actualizar la salida de B
                end
            end
        end
    end
endmodule

```
#### 3.2.2. Parámetros



#### 3.2.3. Entradas y salidas:


    
##### Descripción del módulo:



#### 3.2.4. Criterios de diseño


### 3.2 Módulo 9
#### 3.2.1 Module_row_scanner
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

    always_comb begin
        // Inicializacion de variables
        key_value = 4'b0000;
        key_pressed = 0;
        is_sign_key = 3'b000;
            // Posibles combinaciones
            case (col_shift_reg)
                4'b0001 :  case (row_in) // cuarta columna activa
                                4'b1000 : key_value = 4'b0001;  // "1"
                                4'b0100 : key_value = 4'b0100;  // "4"
                                4'b0010 : key_value = 4'b0111;  // "7"
                                4'b0001 : begin
                                    key_value = 4'b0000;  // "*"
                                    is_sign_key = 3'b100; // signo de resta
                                end 
                           endcase
                4'b0010 :  case (row_in) // tercera columna activa
                                4'b1000 : key_value = 4'b0010;  // "2"
                                4'b0100 : key_value = 4'b0101;  // "5"
                                4'b0010 : key_value = 4'b1000;  // "8"
                                4'b0001 : key_value = 4'b0000;  // "0"
                           endcase
                4'b0100 :  case (row_in) // segunda columna activa
                                4'b1000 : key_value = 4'b0011;  // "3"
                                4'b0100 : key_value = 4'b0110;  // "6"
                                4'b0010 : key_value = 4'b1001;  // "9"
                                4'b0001 : begin
                                    key_value = 4'b0000;  // "#" signo de suma
                                    is_sign_key = 3'b010;
                                end 

                           endcase
                4'b1000 :  begin
                            case (row_in) // primera columna activa
                                4'b1000 : begin
                                    key_value = 4'b1010;  // "A"
                                    is_sign_key = 3'b001;           
                                end 
                                4'b0100 : begin
                                    key_value = 4'b1011;  // "B"
                                    is_sign_key = 3'b011;           
                                end 
                                4'b0010 : begin
                                    key_value = 4'b1100;  // "C"
                                    is_sign_key = 3'b011;                                               
                                end 
                                4'b0001 : begin
                                    key_value = 4'b1101;  // "D"
                                    is_sign_key = 3'b111;           
                                end
                                
                           endcase

                end
            endcase
            if (row_in != 4'b0000) begin
                key_pressed = 1;
            end  
        end
    
endmodule

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



