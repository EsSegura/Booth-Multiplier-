module output_control (
    input logic clk,
    input logic rst, // Reset activo bajo
    input logic key_pressed,
    output logic state_enableA,
    output logic state_enableB,
    output logic ready
);

    // Definición de estados
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        OPERANDO_A = 2'b01,
        OPERANDO_B = 2'b10,
        DONE = 2'b11
    } state_t;

    // Variables internas
    state_t current_state, next_state;
    logic [1:0] count;
    logic key_pressed_prev;

    // Proceso de actualización de estados (always_ff)
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            current_state <= IDLE;
            count <= 2'b00;
            ready <= 0;
            key_pressed_prev <= 0;
        end else begin
            // Actualización del estado actual
            current_state <= next_state;

            // Lógica para manejar la señal de key_pressed
            key_pressed_prev <= key_pressed;

            // Contador
            case (current_state)
                IDLE: begin
                    //state_enableA <= 0; // Habilitar entrada A
                    //state_enableB <= 0; // Habilitar entrada A
                    if (key_pressed && !key_pressed_prev) begin // Detección de flanco ascendente
                        next_state <= OPERANDO_A;
                        count <= 0; // Reiniciar el contador
                    end
                end

                OPERANDO_A: begin
                    state_enableA <= 1; // Habilitar entrada A
                    //state_enableB <= 0; // Habilitar entrada A

                    if (key_pressed && !key_pressed_prev) begin // Detección de flanco ascendente
                        if (count < 2) begin
                            count <= count + 1; // Incrementar el contador para A
                        end
                        if (count == 2) begin
                            next_state <= OPERANDO_B;
                        end
                    end
                end

                OPERANDO_B: begin
                    state_enableB <= 1; // Habilitar entrada B
                    //state_enableA <= 0; // Habilitar entrada A

                    if (key_pressed && !key_pressed_prev) begin // Detección de flanco ascendente
                        if (count < 4) begin
                            count <= count + 1; // Incrementar el contador total
                        end
                        if (count == 4) begin
                            next_state <= DONE;
                        end
                    end
                end

                DONE: begin
                    ready <= 1; // Señal lista 
                    next_state <= IDLE; // Volver a IDLE
                    // No reiniciar el contador aquí
                end

                default: begin
                    next_state <= IDLE; // Regresar a IDLE por defecto
                    count <= 0; // Reiniciar contador
                end
            endcase
        end
    end

endmodule
