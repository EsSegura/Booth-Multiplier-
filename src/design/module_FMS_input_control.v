module fsm_control(
    input logic clk,
    input logic rst,
    input logic key_pressed,       // Señal de tecla presionada
    input logic [2:0] is_sign_key,       // Señal que indica si la tecla ingresada es un signo
    output logic enable_A,         // Enable para almacenar A
    output logic enable_B,         // Enable para almacenar B
    output logic enable_sign,       // Enable para almacenar el signo
    output logic enable_operacion
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
                    key_count = key_count + 1;
                end if (is_sign_key == 3'b001) begin
                    key_count = 2;
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
        next_state = current_state;
        enable_operacion = 0;


        case (current_state)
            IDLE: begin
                if (key_count == 1) begin
                    enable_A = 1;
                    next_state = OPERANDO_A;
                end                    
            end

            OPERANDO_A: begin
                enable_A = 1;  // Habilitar almacenamiento de A
                if (key_count == 2)
                    next_state = SIGN;
                    
            end

            SIGN: begin
                if (is_sign_key == 3'b001) begin // si el signo es multiplicación
                    next_state = OPERANDO_B;
                    enable_sign = 1;  // Habilitar almacenamiento del signo

                end
            end    

            OPERANDO_B: begin
                enable_B = 1;  // Habilitar almacenamiento de B
                if (key_count == 4)  
                    next_state = READY;
            end

            READY: begin
                enable_operacion = 1;  // Habilitar almacenamiento del signo
                if (is_sign_key == 3'b011) begin // si el signo es multiplicación
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end
endmodule