module module_top (
    input logic clk,
    input logic rst,
    input logic [3:0] row_in,
    output logic [3:0] col_out,
    output logic [6:0] catodo_po,
    output logic [3:0] anodo_po,
    output logic enable_operacion
);

    logic slow_clk;
    logic [1:0] column_index;
    logic [3:0] key_value;
    logic [3:0] clean_rows;
    logic key_pressed;
    logic [15:0] bcd;
    logic enable_A;
    logic enable_B;
    logic enable_sign;
    //logic enable_operacion;
    logic ready_operandos;

    logic [2:0] is_sign_key;          // Indica si la tecla es un signo
    logic [7:0] stored_A, stored_B;   // Almacenamiento de los operandos A y B
    logic [15:0] temp_value;           // Valor temporal para mostrar
    logic [3:0] signo;                // Signo de la operación
    logic [15:0] Y;                   // Resultado de la multiplicación
    logic start;                      // Señal para iniciar la multiplicación

    logic [15:0] display_valor;       // Valor a mostrar en el display
    logic [7:0] temp_value_opA, temp_value_opB; 
    logic [15:0] result_operacion;    // Resultado de la operación
    logic done;                       // Señal que indica que la operación ha terminado

    // Registro de desplazamiento de columnas
    assign col_shift_reg = col_out;

    // Instancia del divisor de frecuencia
    freq_divider divisor_inst (
        .clk(clk),
        .rst(rst),
        .slow_clk(slow_clk)
    );

    // Instancia del registro de desplazamiento de columnas
    col_shift_register registro_inst (
        .slow_clk(slow_clk),
        .rst(rst),
        .key_pressed(key_pressed),
        .col_shift_reg(col_out),
        .column_index(column_index)
    );

    // Instancias del debouncer para cada fila
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : debouncer_loop
            debouncer debounce_inst (
                .clk(clk),
                .rst(rst),
                .noisy_signal(row_in[i]),
                .clean_signal(clean_rows[i])
            );
        end
    endgenerate

    // Instancia del escáner de filas
    row_scanner scanner_inst (
        .slow_clk(slow_clk),
        .rst(rst),
        .col_shift_reg(col_out),
        .row_in(clean_rows),
        .key_value(key_value),
        .key_pressed(key_pressed),
        .is_sign_key(is_sign_key)
    );

    // Control de entrada FSM
    fsm_control fsm_input_inst (
        .clk(clk),
        .rst(rst),
        .key_pressed(key_pressed),
        .is_sign_key(is_sign_key),
        .enable_A(enable_A),
        .enable_B(enable_B),
        .enable_sign(enable_sign),
        .enable_operacion(enable_operacion)
    );

    // Almacenamiento de operandos
    number_storage storage_inst (
        .clk(clk),
        .rst(rst),
        .key_value(key_value),
        .key_pressed(key_pressed),
        .is_sign_key(is_sign_key),
        .signo(signo),
        .enable_A(enable_A),
        .enable_B(enable_B),
        .enable_sign(enable_sign),
        .A(stored_A),
        .B(stored_B),
        .temp_value(temp_value),
        .mul_result(Y),
        .mul_valid(done)
    );

    // Lógica para manejar la tecla presionada
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            display_valor <= 16'd0;  // Inicializar la pantalla
            enable_operacion <= 1'b1; // Deshabilitar la operación
        end else if (key_pressed) begin
            case (key_value)
                4'b1011: begin
                    // Cuando se presiona la tecla B, mostrar A
                    display_valor <= {8'b0, stored_A};
                    enable_operacion <= 1'b1; // No activar operación
                end
                4'b1100: begin
                    // Cuando se presiona la tecla C, mostrar B
                    display_valor <= {8'b0, stored_B};
                    enable_operacion <= 1'b1; // No activar operación
                end
                4'b1101: begin
                    // Cuando se presiona la tecla D, realizar la multiplicación
                    display_valor <= Y;  // Mostrar el resultado de la multiplicación
                    enable_operacion <= 1'b0;    // Iniciar operación de Booth
                end
                default: begin
                    display_valor <= temp_value; // Mostrar valor temporal
                end
            endcase
        end else begin
            display_valor <= temp_value; // Mostrar valor temporal cuando no se presiona ninguna tecla
        end
    end

    // Conversión de binario a BCD para el display
    bin_to_bcd converter_inst (
        .binario(display_valor),  // Limitar a 16 bits para la conversión
        .bcd(bcd)
    );

    // Controlador del display de 7 segmentos
    module_7_segments display_inst (
        .clk_i(clk),
        .rst_i(rst),
        .bcd_i(bcd),
        .anodo_o(anodo_po),
        .catodo_o(catodo_po)
    );

endmodule













