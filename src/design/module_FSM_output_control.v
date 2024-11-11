module fsm_output_control(
    input logic clk,
    input logic rst,
    input logic key_pressed,                // Señal de tecla presionada
    input logic [2:0] is_sign_key,          // Señal que indica si la tecla ingresada es un signo
    input logic [7:0] temp_value_opA,       // Valor de A
    input logic [7:0] temp_value_opB,       // Valor de B
    input logic [15:0] result_operacion,    // Resultado de la operación entre A y B
    output logic [15:0] display_out         // Salida del display
);

    // Estados
    typedef enum logic [2:0] {
        IDLE,
        Mostrar_A,
        SIGN,
        Mostrar_B,
        RESULT
    } state_t;

    state_t current_state, next_state;
    logic key_pressed_prev;                 // Estado previo de la tecla
    logic [1:0] key_count;                  // Contador de flancos detectados

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
                    key_count <= 2;
                end
            end
        end
    end

    // Lógica de transición de estados y asignación de display_out
    always_comb begin
        next_state = current_state; // Valor por defecto
        display_out = 16'b0;        // Limpiar la salida en cada ciclo

        case (current_state)
            IDLE: begin
                if (key_count == 1) begin
                    next_state = Mostrar_A;
                end                    
            end

            Mostrar_A: begin
                display_out = {8'b0, temp_value_opA}; // Mostrar valor de A en la salida
                if (key_count == 2) begin
                    next_state = SIGN;
                end
            end

            SIGN: begin
                if (is_sign_key == 3'b100) begin //  si el sigmo es igual
                    next_state = Mostrar_B;
                end
            end    

            Mostrar_B: begin
                display_out = {8'b0, temp_value_opB}; // Mostrar valor de B en la salida
                if (key_count == 3) begin
                    next_state = RESULT;
                end
            end

            RESULT: begin
                display_out = result_operacion; // Mostrar resultado de la operación
                if (is_sign_key == 3'b011) begin // Si se presiona un signo, regresar a IDLE
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end
endmodule
