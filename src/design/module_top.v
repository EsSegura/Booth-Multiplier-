module module_top (
    input logic clk,
    input logic rst,
    input logic [3:0] row_in,
    output logic [3:0] col_out,
    output logic [6:0] catodo_po,
    output logic [3:0] anodo_po
);

    logic slow_clk;
    logic [3:0] column_index;
    logic [3:0] key_value;
    logic [3:0] clean_rows;
    logic key_pressed;
    logic [15:0] bcd;
    logic [3:0] col_shift_reg;                   // Señal BCD para los displays
    logic [11:0] stored_value;               // Acumulador de 12 bits
    logic load_value;
    logic clear_input;
    logic start_sum;
    



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
        .key_pressed(key_pressed)
    );

    // Instancia del módulo input_control para gestionar la entrada
    input_control control_inst (
        .clk(clk),
        .rst(rst),
        .key_value(key_value),
        .key_pressed(key_pressed),
        .stored_value(stored_value),
        .load_value(load_value),
        .clear_input(clear_input)
    );

    // Conversión de `display_data` a BCD
    bin_to_bcd converter_inst (
        .binario(stored_value), // `display_data` contiene el valor de acumulador o multiplicación
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








