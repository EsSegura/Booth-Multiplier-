`timescale 1ns/1ps

module tb_freq_divider;

    // Señales de prueba
    logic clk;          // Señal de reloj (27 MHz)
    logic rst;          // Señal de reinicio
    logic slow_clk;     // Señal del reloj lento (1 kHz)

    // Instancia del módulo divisor de frecuencia
    freq_divider uut (
        .clk(clk),
        .rst(rst),
        .slow_clk(slow_clk)
    );

    // Generador de reloj de 27 MHz (período de ~37 ns)
    initial begin
        clk = 0;
        forever #18.5 clk = ~clk;  // 18.5 ns para obtener un reloj de 27 MHz
    end

    // Generación de la señal de reset
    initial begin
        rst = 0;             // Inicialmente mantener el reset en bajo
        #100 rst = 1;        // Desactivar el reset después de 100 ns
        #5000 rst = 0;       // Activar el reset nuevamente después de 5 us
        #100 rst = 1;        // Desactivar el reset nuevamente después de 100 ns
    end

    // Monitoreo de la señal del reloj lento
    initial begin
        $monitor("Time = %0t, slow_clk = %b", $time, slow_clk);
    end

    // Finalización de la simulación después de un tiempo determinado
    initial begin
        #10000000 $finish;  // Terminar la simulación después de 1 ms
    end

    // Para registrar las señales en un archivo VCD (para visualización)
    initial begin
        $dumpfile("freq_divider.vcd");  // Nombre del archivo de salida VCD
        $dumpvars(0, tb_freq_divider);  // Registrar todas las señales del testbench
    end

endmodule
