module memoria (
    input logic clk,
    input logic rst,
    input logic key_pressed,
    input logic [3:0] key_value,
    output logic [7:0] op_A,
    output logic [7:0] op_B,
    output logic listo
);

    // Estados de la máquina de estado
    typedef enum logic [1:0] {
        IDLE,        // Espera del primer operando
        STORE_OP1,   // Almacenamiento del primer operando
        STORE_OP2,   // Almacenamiento del segundo operando
        READY        // Ambos operandos ingresados
    } state_t;

    // Señales de control
    state_t state, next_state;
    logic [1:0] contador; 
    logic key_pressed_prev;

    // Inicializa las salidas
    always_ff @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            op_A <= 8'b0; // Inicializa op_A
            op_B <= 8'b0; // Inicializa op_B
            listo <= 0; // Inicializa listo
            contador <= 0; // Reinicia el contador
            key_pressed_prev <= 0; // Reinicia la tecla presionada previa
        end else begin
            state <= next_state;
            key_pressed_prev <= key_pressed;
        end 
    end 

    always_ff @(posedge clk) begin
        if (key_pressed && !key_pressed_prev) begin
            if (state == STORE_OP1) begin
                // Almacenar el primer operando
                if (contador < 2) begin
                    op_A[contador * 4 +: 4] <= key_value; // Almacena el dígito
                    contador <= contador + 1; // Incrementa el contador
                end
            end else if (state == STORE_OP2) begin
                // Almacenar el segundo operando
                if (contador >= 2 && contador < 4) begin
                    op_B[(contador - 2) * 4 +: 4] <= key_value; // Almacena el dígito
                    contador <= contador + 1; // Incrementa el contador
                end
            end
        end
    end

    always_comb begin
        // Valores predeterminados
        next_state = state;
        listo = (state == READY);
        
        // Reinicializa los registros solo si se está en el estado IDLE
        if (state == IDLE) begin
            op_A = 8'b00000000; // Reinicia op_A
            op_B = 8'b00000000; // Reinicia op_B
            contador = 0; // Reinicia el contador
        end

        case (state)
            IDLE: begin
                if (key_pressed && !key_pressed_prev) begin
                    next_state = STORE_OP1; // Almacena el primer operando
                end
            end

            STORE_OP1: begin
                if (contador == 0) begin
                    op_A[3:0] = key_value; // Almacena el segundo dígito
                    next_state = STORE_OP1; // Cambia al siguiente operando
                end else if (contador == 1) begin
                    op_A[7:4] = key_value; // Almacena el primer dígito
                    contador = 1; // Incrementa el contador
                    next_state = STORE_OP2;
                end
            end

            STORE_OP2: begin
                if (contador == 2) begin
                    op_B[3:0] = key_value; // Almacena el segundo dígito
                    next_state = STORE_OP2; // Ambos operandos ingresados
                end else if (contador == 3) begin
                    op_B[7:4] = key_value; // Almacena el primer dígito
                    contador = 3; // Incrementa el contador
                    next_state = READY;
                end
            end

            READY: begin
                if (!key_pressed) begin
                    next_state = IDLE; // Vuelve a esperar el primer operando
                    listo = 0; // Reinicia listo
                    contador = 0; // Reinicia contador al volver a IDLE
                end
            end
        endcase
    end

endmodule

