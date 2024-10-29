module input_control (
    input logic clk,
    input logic rst,
    input logic [3:0] key_value,
    input logic key_pressed,
    output logic start_multiplication, // Señal para iniciar la multiplicación en el algoritmo de Booth
    output logic [11:0] A,              // Primer número
    output logic [11:0] B,              // Segundo número
    output logic operator_ready          // Indica que se ha ingresado el primer número
);

    logic key_pressed_prev;             // Para detectar flancos ascendentes

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            A <= 12'b0;                 // Inicializa A
            B <= 12'b0;                 // Inicializa B
            key_pressed_prev <= 1'b0;   // Reinicia el estado previo del botón
            operator_ready <= 1'b0;      // Reinicia el estado del operador
            start_multiplication <= 1'b0; // Señal para iniciar la multiplicación
        end
        else begin
            key_pressed_prev <= key_pressed; // Actualiza el estado previo del botón

            // Detecta el flanco ascendente del botón
            if (key_pressed && !key_pressed_prev) begin
                // Si A no ha sido ingresado, almacena en A
                if (!operator_ready) begin
                    A <= A * 10 + key_value; // Construye el número A
                end
                else begin
                    B <= B * 10 + key_value; // Construye el número B
                end

                // Si se presiona A, inicia la multiplicación
                if (key_value == 4'b1010) begin // Suponiendo que 'A' es 4'b1010
                    start_multiplication <= 1'b1; // Indica que se debe iniciar la multiplicación
                    operator_ready <= 1'b0;       // Reinicia el estado del operador
                end
                else begin
                    operator_ready <= 1'b1;        // Indica que se ha ingresado el primer número
                end
            end
            else begin
                start_multiplication <= 1'b0; // Resetea la señal de inicio si no se presiona
            end
        end
    end
endmodule




































