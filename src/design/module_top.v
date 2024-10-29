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
    logic [3:0] col_shift_reg;
    logic [15:0] bcd;                      // Señal BCD para los displays
    logic [11:0] acumulador;               // Acumulador de 12 bits
    logic [7:0] multiplicador_A;           // A para el multiplicador
    logic [7:0] multiplicador_B;           // B para el multiplicador
    logic [15:0] resultado_multiplicacion; // Resultado de la multiplicación
    logic [1:0] Q_LSB;
    logic [15:0] display_data;             // Datos a mostrar en el display

    // Señales de control
    logic load_A;
    logic load_B;
    logic load_add; // Control de carga de adición
    logic shift_HQ_LQ_Q_1; // Control de desplazamiento
    logic add_sub; // Control de suma/resta

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

    // Controlador de entrada para ingresar los números en orden
    input_control control_inst (
        .clk(clk),
        .rst(rst),
        .key_value(key_value),
        .key_pressed(key_pressed),
        .acumulador(acumulador),
        .multiplicador_A(multiplicador_A),
        .multiplicador_B(multiplicador_B),
        .load_A(load_A),
        .load_B(load_B),
        .shift_HQ_LQ_Q_1(shift_HQ_LQ_Q_1),
        .add_sub(add_sub)
    );

    // Muestra el resultado de acumulador o multiplicación en BCD
    assign display_data = (key_value == 4'b1010) ? resultado_multiplicacion : acumulador;
    
    bin_to_bcd converter_inst (
        .binario(acumulador),
        .bcd(bcd)
    );

    // Instancia del multiplicador de Booth
    mult_with_no_fsm #(
        .N(8)
    ) multiplier_inst (
        .clk(clk),
        .rst(rst),
        .A(multiplicador_A),
        .B(multiplicador_B),
        .load_A(load_A),               // Carga A cuando se activa
        .load_B(load_B),               // Carga B cuando se activa
        .load_add(1'b0),               // Carga de adición (ajustar según la lógica)
        .shift_HQ_LQ_Q_1(shift_HQ_LQ_Q_1), // Control de desplazamiento
        .add_sub(add_sub),             // Control de suma/resta (ajustar según la lógica)
        .Q_LSB(Q_LSB),
        .Y(resultado_multiplicacion)
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





