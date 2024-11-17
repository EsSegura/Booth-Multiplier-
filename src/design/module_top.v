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

    logic [2:0] is_sign_key;
    logic [7:0] stored_A;
    logic [7:0] stored_B;
    logic [7:0] temp_value;
    logic [3:0] signo;
    logic [15:0] Y;
    logic start;

    logic [15:0] display_valor;
    logic [7:0] temp_value_opA;
    logic [7:0] temp_value_opB;
    logic [15:0] result_operacion;
    logic [15:0] display_out;

    logic start;
    logic done;

    // Registro de desplazamiento de columnas
    assign col_shift_reg = col_out;

    // Instancia del divisor de frecuencia
    freq_divider divisor_inst (
        .clk(clk),
        .rst(rst),
        .slow_clk(slow_clk)
    );

    // Registro de desplazamiento de columnas
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
        .temp_value(temp_value)
    );

    // Multiplicador de Booth
    BoothMul booth_multiplier_inst (
        .clk(clk),
        .rst(rst),
        .start(enable_operacion),
        .A(stored_A),
        .B(stored_B),
        .valid(ready_operandos),
        .Y(Y)
    );

    // Multiplexor para seleccionar la entrada del display
    always_comb begin
        if (ready_operandos)
            display_valor = Y;
        else
            display_valor = temp_value;
    end

    // Conversión a BCD
    bin_to_bcd converter_inst (
        .binario(stored_B),  // Limitamos a 12 bits para BCD
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









