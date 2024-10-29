`timescale 1ns/1ps

module tb_fsm_controller;

    // Declaración de señales
    logic slow_clk;                  // Reloj lento (1 kHz)
    logic rst;                       // Señal de reset
    logic [3:0] row_in;              // Entradas de las filas del teclado
    logic [3:0] col_shift_reg;       // Registro de desplazamiento de columnas (dummy)
    logic [3:0] row_capture;         // Captura de las filas activas
    logic key_pressed;               // Señal de tecla presionada

    // Parámetros para la generación de reloj
    parameter CLK_PERIOD = 1_000_000; // Periodo de 1_000_000 ns (1 ms) para obtener 1 kHz

    // Variable para el estado en forma de cadena
    reg [8*10:1] current_state_str; // Cadena de hasta 10 caracteres (80 bits)

    // Instancia del módulo fsm_controller
    fsm_controller uut (
        .slow_clk(slow_clk),
        .rst(rst),
        .row_in(row_in),
        .col_shift_reg(col_shift_reg),
        .row_capture(row_capture),
        .key_pressed(key_pressed)
    );

    // Generador del reloj lento
    initial begin
        slow_clk = 0;
        forever #(CLK_PERIOD/2) slow_clk = ~slow_clk; // Cambia el valor del reloj cada 500,000 ns para obtener 1kHz
    end

    // Proceso de prueba
    initial begin
        // Inicialización de señales
        rst = 0;
        row_in = 4'b0000;             // No hay fila activa
        col_shift_reg = 4'b0000;      // No se utiliza en este testbench, se mantiene en 0

        #10_000_000;                  // Espera 10 ms para estabilizar el reloj
        rst = 1;                      // Liberar el reset
        #1_000_000;                   // Espera 1 ciclo de reloj (1 ms) para iniciar la operación

        // Prueba 1: No se presiona ninguna tecla, debe permanecer en IDLE
        #2_000_000;                   // Esperar 2 ms para observar comportamiento en estado IDLE

        // Prueba 2: Se simula una tecla presionada (por ejemplo, fila 2 activa)
        row_in = 4'b0010;
        #1_000_000;                   // Esperar 1 ms para ver transición a SCAN y DEBOUNCE

        // Prueba 3: Mantener la tecla presionada para pasar a DEBOUNCE
        #1_000_000;                   // Esperar 1 ms para confirmar debounce
        row_in = 4'b0000;             // Liberar la tecla

        // Prueba 4: Dejar el sistema en reposo nuevamente
        #2_000_000;                   // Esperar 2 ms para ver retorno a IDLE
        $stop;                        // Finalizar la simulación
    end

    // Proceso para actualizar el valor del estado como string utilizando un always @(*) y `initial`
    always @(uut.current_state) begin
        case (uut.current_state)
            uut.IDLE:      current_state_str = "IDLE";
            uut.SCAN:      current_state_str = "SCAN";
            uut.DEBOUNCE:  current_state_str = "DEBOUNCE";
            default:       current_state_str = "UNKNOWN";
        endcase
    end

    // Monitor para observar las señales (sin usar expresiones complejas)
    initial begin
        $monitor("Time: %0t ns | slow_clk = %b | rst = %b | row_in = %b | col_shift_reg = %b | row_capture = %b | key_pressed = %b | state = %s", 
                 $time, slow_clk, rst, row_in, col_shift_reg, row_capture, key_pressed, current_state_str);
    end
endmodule
