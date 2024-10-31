module input_module (
    input logic clk,                  // Reloj del sistema
    input logic rst,                  // Reset activo bajo
    input logic key_pressed,          // Indica si se ha presionado una tecla
    input logic [3:0] key_value,      // Valor de la tecla presionada (0-9 o A para borrar)
    input logic is_sign_key,          // Indica si la tecla es un signo (por ejemplo, '+', '-')
    input logic state_enableA,        // Habilita almacenamiento en A
    input logic state_enableB,        // Habilita almacenamiento en B
    output logic [7:0] stored_A,      // Valor almacenado en A
    output logic [7:0] stored_B       // Valor almacenado en B
);

    logic key_pressed_prev;              // Para detectar flancos ascendentes
    logic [7:0] temp_value;              // Almacena temporalmente el valor ingresado
    logic load_value;                     // Señal para cargar el valor

    // Inicialización y lógica de entrada
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            stored_A <= 8'b0;            // Reiniciar el valor almacenado en A
            stored_B <= 8'b0;            // Reiniciar el valor almacenado en B
            temp_value <= 8'b0;           // Reiniciar el valor temporal
            key_pressed_prev <= 1'b0;
            load_value <= 1'b0;
        end else begin
            key_pressed_prev <= key_pressed; // Detecta el flanco ascendente del botón
            if (key_pressed && !key_pressed_prev) begin
                if (!is_sign_key) begin // Si se presiona una tecla del 0 al 9
                    // Agregar el nuevo dígito al valor temporal
                    temp_value <= (temp_value << 3) + (temp_value << 2) + key_value; // Desplazamientos para multiplicar por 10
                    load_value <= 1'b1; // Señal para cargar el valor
                end else if (key_value == 4'b1010) begin // Suponiendo que 'A' es 4'b1010
                    // Al presionar 'A', borra los valores
                    stored_A <= 8'b0;      // Borrar el valor almacenado en A
                    stored_B <= 8'b0;      // Borrar el valor almacenado en B
                    temp_value <= 8'b0;    // Reiniciar el valor temporal
                end
            end else begin
                load_value <= 1'b0; // Resetear la señal de carga
            end
            
            // Almacena el valor temporal en stored_A o stored_B según el habilitador
            if (load_value) begin
                if (state_enableA) begin
                    stored_A <= temp_value; // Almacenar el valor temporal en A
                end else if (state_enableB) begin
                    stored_B <= temp_value; // Almacenar el valor temporal en B
                end
            end
        end
    end

endmodule
