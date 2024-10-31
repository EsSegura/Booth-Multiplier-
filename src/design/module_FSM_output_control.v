module output_control (
    input logic clk,                // Reloj del sistema
    input logic rst,                // Reset activo bajo
    input logic key_pressed,        // Botón para iniciar la entrada de operandos
    output logic state_enableA,     // Señal de habilitación para el operando A
    output logic state_enableB,     // Señal de habilitación para el operando B
    output logic ready              // Señal de READY
);

    // Definición de estados
    typedef enum logic [2:0] {
        IDLE = 3'b000,              // Estado de reposo
        OPERANDO_A = 3'b001,        // Estado para ingresar A
        OPERANDO_B = 3'b010,        // Estado para ingresar B
        DONE = 3'b011                // Estado final
    } state_t;

    state_t current_state, next_state;
    logic [1:0] count;              // Contador para los dígitos ingresados (2 bits para contar hasta 2)
    logic key_pressed_prev;         // Para detectar flancos ascendentes

    // Proceso de actualización de estados en el flanco positivo del reloj
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            current_state <= IDLE;
            count <= 2'b00; // Inicializa el contador en 0
            ready <= 1'b0;
            key_pressed_prev <= 1'b0; // Inicializa el estado previo del botón
        end else begin
            current_state <= next_state; // Actualizar el estado actual
            key_pressed_prev <= key_pressed; // Guardar el estado previo del botón
        end
    end

    // Lógica combinacional para definir el siguiente estado
    always_comb begin
        next_state = current_state; // Por defecto no cambiar de estado
        ready = 1'b0;               // Resetear la señal READY
        state_enableA = 1'b0;       // Deshabilitar entrada A
        state_enableB = 1'b0;       // Deshabilitar entrada B

        case (current_state)
            IDLE: begin
                if (key_pressed && !key_pressed_prev) begin
                    next_state = OPERANDO_A; // Iniciar entrada de A
                    count = 2'b00; // Reiniciar contador
                end
            end

            OPERANDO_A: begin
                state_enableA = 1'b1; // Habilitar entrada A
                if (key_pressed && !key_pressed_prev) begin // Detectar flanco
                    if (count < 2'b10) begin // Realiza dos iteraciones (0, 1)
                        count = count + 1; // Incrementar el contador de dígitos
                    end else begin
                        next_state = OPERANDO_B; // Pasar a OPERANDO_B
                    end
                end
            end

            OPERANDO_B: begin
                state_enableB = 1'b1; // Habilitar entrada B
                if (key_pressed && !key_pressed_prev) begin // Detectar flanco
                    if (count < 2'b10) begin // Realiza dos iteraciones (0, 1)
                        count = count + 1; // Incrementar el contador de dígitos
                    end else begin
                        next_state = DONE; // Indicar que ambos operandos han sido ingresados
                    end
                end
            end

            DONE: begin
                ready = 1'b1; // Señal de READY activada
                next_state = IDLE; // Volver al estado IDLE
                // No reiniciar el contador aquí
            end
            
            default: begin
                next_state = IDLE; // Volver a IDLE por defecto
                count = 2'b00; // Reiniciar contador en IDLE
            end        
        endcase
    end

endmodule
