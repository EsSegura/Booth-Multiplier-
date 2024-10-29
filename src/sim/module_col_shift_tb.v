`timescale 1ns/1ps

// Testbench para el módulo col_shift_register
module tb_col_shift_register;

    // Declaración de señales
    logic slow_clk;                // Reloj lento (1 kHz)
    logic rst;                     // Señal de reset
    logic [3:0] col_shift_reg;     // Salida del registro de desplazamiento
    logic [1:0] column_index;      // Salida del índice de columna

    // Parámetros para la generación de reloj
    parameter CLK_PERIOD = 1_000_000; // Periodo de 1_000_000 ns (1 ms) para obtener 1 kHz

    // Instancia del módulo col_shift_register
    col_shift_register uut (
        .slow_clk(slow_clk),
        .rst(rst),
        .col_shift_reg(col_shift_reg),
        .column_index(column_index)
    );

    // Generador del reloj lento
    initial begin
        slow_clk = 0;
        forever #(CLK_PERIOD/2) slow_clk = ~slow_clk; // Cambia el valor del reloj cada 500,000 ns para obtener 1kHz
    end

    // Proceso de prueba
    initial begin
        // Configuración inicial
        rst = 0;
        #10_000_000;  // Espera 10,000,000 ns (10 ms) para iniciar la simulación

        // 1. Liberar el reset y verificar el registro de desplazamiento
        rst = 1;
        #1_000_000;  // Espera un ciclo de reloj (1,000,000 ns = 1 ms) para iniciar la operación

        // Esperar 4 ciclos de reloj (4 ms) para verificar el desplazamiento
        repeat (4) @(posedge slow_clk);

        // Finalizar la simulación
        $finish;
    end

    // Monitor para observar las señales
    initial begin
        $monitor("Time: %0t ns | slow_clk = %b | rst = %b | col_shift_reg = %b | column_index = %0d", 
                 $time, slow_clk, rst, col_shift_reg, column_index);
    end
    
endmodule
