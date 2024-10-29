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



