module module_top (
    input logic clk,
    input logic rst,
    input logic [3:0] row_in,
    output logic [3:0] col_out,
    output logic [6:0] catodo_po,
    output logic [3:0] anodo_po
);

    logic slow_clk;
    logic [1:0] column_index;
    logic [3:0] key_value;
    logic [3:0] clean_rows;
    logic key_pressed;
    logic [15:0] bcd;
    logic [3:0] col_shift_reg;                   // Señal BCD para los displays

    logic enable_A;
    logic enable_B;
    logic enable_sign;
    logic ready_operandos;


    logic is_sign_key;
    logic [7:0] stored_A;
    logic [7:0] stored_B;
    logic [7:0] temp_value;
    logic [3:0] signo;

    logic [7:0] A;
    logic [7:0] B;
    logic [15:0] Y;
    logic load_A;
    logic load_B;
    logic load_add;
    logic shift_HQ_LQ_Q_1;
    logic add_sub;
    logic [1:0] Q_LSB;

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

        // Instancia del módulo fsm_control
    fsm_control fsm_input_inst (
        .clk(clk),
        .rst(rst),
        .key_pressed(key_pressed),
        .is_sign_key(is_sign_key),
        .enable_A(enable_A),
        .enable_B(enable_B),
        .enable_sign(enable_sign)
    );

    // Instancia del módulo operand_storage
    operand_storage storage_inst (
        .clk(clk),
        .rst(rst),
        .key_value(key_value),    // Entrada de valor de tecla
        .key_pressed(key_pressed),
        .is_sign_key(is_sign_key),        
        .enable_A(enable_A),      // Habilitación para almacenar A
        .enable_B(enable_B),      // Habilitación para almacenar B
        .enable_sign(enable_sign), // Habilitación para almacenamiento temporal (signo o valor actual)
        .A(stored_A),                // Salida de operando A
        .B(stored_B),                // Salida de operando B
        .temp_value(temp_value)   // Salida temporal para visualización en display
    );
         mult_with_no_fsm mult_inst (
            .clk(clk),
            .rst(rst),
            .A(stored_A),       // Entrada operando A
            .B(stored_B),       // Entrada operando B
            .load_A(load_A),
            .load_B(load_B),
            .load_add(load_add),
            .shift_HQ_LQ_Q_1(shift_HQ_LQ_Q_1),
            .add_sub(add_sub),
            .Q_LSB(Q_LSB),
            .Y(Y)
    );

    // Instancia del módulo input_control para gestionar la entrada
/*    input_module input_inst (
        .clk(clk),
        .rst(rst),                  // Invertir el reset si es necesario
        .key_pressed(key_pressed),
        .key_value(key_value),
        .is_sign_key(is_sign_key),
        .state_enableA(enableA),
        .state_enableB(enableB),
        .stored_A(stored_A),          // Salida para el valor almacenado en A
        .stored_B(stored_B)           // Salida para el valor almacenado en B
    );

    output_control ocontrol_inst (
        .clk(clk),
        .rst(rst),
        .state_enableA(enableA),
        .state_enableB(enableB),
        .ready(ready_operandos)
    );

*/


logic [15:0] display_valor;

// Multiplexor para seleccionar entre temp_value y Y
always_comb begin
    if (ready_operandos)
        display_valor = Y;          // Mostrar resultado de la multiplicación cuando está listo
    else
        display_valor = temp_value; // Mostrar valor temporal de entrada
end

// Instancia del módulo bin_to_bcd con entrada multiplexada
bin_to_bcd converter_inst (
    .binario(display_valor[11:0]),  // Usamos display_valor como la entrada BCD
    .bcd(bcd)
);

    // Controlador del display de 7 segmentos
    module_7_segments display_inst (
        .clk_i(clk),
        .rst_i(rst),
        .bcd_i(bcd),          // Conexión de la salida BCD al display
        .anodo_o(anodo_po),
        .catodo_o(catodo_po)
    );



endmodule








