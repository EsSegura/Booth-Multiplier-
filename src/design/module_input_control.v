module input_control (
    input logic clk,
    input logic rst,
    input logic [3:0] key_value,
    input logic key_pressed,
    output logic [7:0] stored_value,    // Valor almacenado como un número decimal
    output logic load_value,             // Señal para cargar el valor
    output logic clear_input             // Señal para limpiar el valor ingresado
);

    logic key_pressed_prev;              // Para detectar flancos ascendentes
    logic [7:0] temp_value;              // Almacena temporalmente el valor ingresado

    // Inicialización y lógica de entrada
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            stored_value <= 8'b0;         // Reiniciar el valor almacenado
            temp_value <= 8'b0;           // Reiniciar el valor temporal
            key_pressed_prev <= 1'b0;
            load_value <= 1'b0;
            clear_input <= 1'b0;
        end else begin
            key_pressed_prev <= key_pressed;

            // Detecta el flanco ascendente del botón
            if (key_pressed && !key_pressed_prev) begin
                // Si se presiona una tecla del 0 al 9
                if (key_value >= 4'b0000 && key_value <= 4'b1001) begin
                    // Agregar el nuevo dígito al valor temporal
                    // Asegúrate de que key_value sea tratado como un valor decimal
                    temp_value <= temp_value * 10 + key_value; // Multiplica el valor existente por 10 y suma el nuevo dígito
                    load_value <= 1'b1; // Señal para cargar el valor (puedes ajustarla según sea necesario)
                    clear_input <= 1'b0; // Resetear la señal de limpiar
                end else if (key_value == 4'b1010) begin // Suponiendo que 'A' es 4'b1010
                    // Al presionar 'A', borra el valor
                    stored_value <= 8'b0;      // Borrar el valor almacenado
                    temp_value <= 8'b0;        // Reiniciar el valor temporal
                    clear_input <= 1'b1;       // Activar señal de limpiar
                end
            end else begin
                load_value <= 1'b0; // Resetear la señal de carga
            end
            
            // Almacena el valor temporal en stored_value si es necesario
            if (load_value) begin
                stored_value <= temp_value; // Almacenar el valor temporal
            end
        end
    end
endmodule








































