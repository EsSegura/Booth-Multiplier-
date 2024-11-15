module number_storage(
    input logic clk,
    input logic rst,
    input logic [3:0] key_value,     // Valor ingresado desde el teclado (4 bits)
    input logic key_pressed,          // Señal de tecla presionada
    input logic [2:0] is_sign_key,
    input logic signo,
    input logic enable_A,
    input logic enable_B,
    input logic enable_sign,
    input logic valid,
    output logic [7:0] A,             // Salida del operando A
    output logic [7:0] B,             // Salida del operando B
    output logic [7:0] temp_value     // Salida temporal para mostrar en display
);

    // Registros internos para almacenar valores parciales
    logic [7:0] temp_A, temp_B;
    logic key_pressed_prev;           // Estado previo de la tecla
    logic load_value;                 // Señal para cargar el valor

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            A <= 8'b0;
            B <= 8'b0;
            temp_A <= 8'b0;
            temp_B <= 8'b0;
            temp_value <= 8'b0;
            key_pressed_prev <= 1'b0;
            load_value <= 1'b0;
            signo <= 1'b0;
            valid <= 1'b0;
        end else begin
            key_pressed_prev <= key_pressed; // Detecta el flanco ascendente del botón

            // Detección de flanco positivo
            if (key_pressed && !key_pressed_prev) begin
                case (is_sign_key)
                    3'b000: begin // Se ingresó un nuevo número
                        temp_value <= (temp_value << 3) + (temp_value << 1) + key_value; // Multiplicación por 10
                        load_value <= 1'b1; // Señal para cargar el valor
                    end

                    3'b001: begin // Se ingresó un operando (por ejemplo, multiplicación)
                        // Guardar el valor actual y limpiar temp_value
                        if (enable_A) begin
                            temp_A <= temp_value;
                            A <= temp_A; // Actualizar la salida de A
                        end else if (enable_B) begin
                            temp_B <= temp_value;
                            B <= temp_B; // Actualizar la salida de B
                        end
                        temp_value <= 8'b0; // Limpiar el valor temporal para un nuevo ingreso
                        load_value <= 1'b0; // Señal para finalizar la carga
                    end

                    3'b010: begin // Se ingresó un operando de suma
                        signo <= 1'b0;
                    end

                    3'b100: begin // Se ingresó un operando de resta
                        signo <= 1'b1;
                    end
<<<<<<< HEAD
=======
                    3'b010: begin  // se ingresó un operando de resta
                        signo <= 1; 
                    end
                    3'b111: begin
                        valid <= 1;
                    end                   
>>>>>>> ce19330b26c6a4fbf211911c46f5a35c0dc7a79d

                    3'b111: begin // Validar la entrada
                        valid <= 1'b1;
                    end

                    default: begin
                        load_value <= 1'b0; // Resetear la señal de carga
                    end
                endcase
            end else begin
                load_value <= 1'b0; // Resetear la señal de carga
<<<<<<< HEAD
                signo <= 1'b0;
                valid <= 1'b0;
=======
                signo <= 0;
                valid <= 0;
>>>>>>> ce19330b26c6a4fbf211911c46f5a35c0dc7a79d
            end

            // Almacenar el valor temporal en A o B según el habilitador
            if (load_value) begin
                if (enable_A) begin
                    temp_A <= temp_value; // Almacenar el valor temporal en A
                    A <= temp_A;          // Actualizar la salida de A
                end else if (enable_B) begin
                    temp_B <= temp_value; // Almacenar el valor temporal en B
                    B <= temp_B;          // Actualizar la salida de B
                end
            end
        end
    end
endmodule



/*
                    if (key_value == 4'b1100) begin


                    end
                    if (key_value == 4'b1011) begin
                    // Al presionar 'B', borra los valores
                    stored_A <= 12'b0;      // Borrar el valor almacenado en A
                    temp_value <= 12'b0;    // Reiniciar el valor temporal

                    stored_A <= result;
                    end

                    if (key_value == 4'b1100) begin // Suponiendo que 'C' clear result
                    stored_A <= 12'b0;
                    stored_B <= 12'b0;
                    temp_value <= 12'b0;
                    end
*/