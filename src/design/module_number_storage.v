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
        end else begin
            key_pressed_prev <= key_pressed; // Detecta el flanco ascendente del botón

            // Detección de flanco positivo
            if (key_pressed && !key_pressed_prev ) begin

                case (is_sign_key)
                    3'b000: begin  // se ingresó un nuevo numero
                        temp_value <= (temp_value << 3) + (temp_value << 1) + key_value; // Desplazamientos para multiplicar por 10
                        load_value <= 1'b1; // Señal para cargar el valor                        
                    end

                    3'b001: begin  // se ingresó un operando de multiplicación
                        temp_value <= temp_value; // se guarda el operando tal cual esta, solo unidades 
                        load_value <= 1'b1; // Señal para cargar el valor  1 *
                        
                    end

                    3'b010: begin  // se ingresó un operando de suma
                        signo <= 0; 
                    end

                    3'b100: begin  // se ingresó un operando de resta
                        signo <= 1; 
                    end
                    3'b010: begin  // se ingresó un operando de resta
                        signo <= 1; 
                    end
                    3'b111; begin
                        valid <= 1;
                    end                     

                endcase

            end else begin
                load_value <= 1'b0; // Resetear la señal de carga
            end
            
            // Almacenar el valor temporal en A o B según el habilitador
            if (load_value) begin
                if (enable_A) begin

                    temp_A <= temp_value; // Almacenar el valor temporal en A
                    A <= temp_A;           // Actualizar la salida de A
                    
                end else if (enable_sign) begin

                    temp_value <= 8'b0; // vuelese el valor temporal

                end else if (enable_B) begin

                    temp_B <= temp_value; // Almacenar el valor temporal en B
                    B <= temp_B;
                    
                end else if (!enable_A && !enable_B) begin
                    temp_value <= 8'b0;
                end else if (valid) begin
                    temp_value <= Y;
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