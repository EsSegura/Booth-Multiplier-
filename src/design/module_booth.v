module mult_with_no_fsm#(
    parameter N = 12
) (
    input logic clk,
    input logic rst,
    input logic [11:0] A,
    input logic [11:0] B,
    input logic load_A,               // Control de carga de A
    input logic load_B,               // Control de carga de B
    input logic load_add,             // Control para carga de adición
    input logic shift_HQ_LQ_Q_1,      // Control de desplazamiento
    input logic add_sub,              // Control de suma/resta
    output logic [1:0] Q_LSB,
    output logic [23:0] Y
);

logic [11:0] M;
logic [11:0] adder_sub_out;
logic [24:0] shift;
logic [11:0] HQ;
logic [11:0] LQ;
logic Q_1;

// Registro de M
always_ff @(posedge clk) begin
    if (!rst)
        M <= 'b0;
    else if (load_A)
        M <= A;
end

// Adición o sustracción
always_comb begin
    if (add_sub)
        adder_sub_out = HQ + M;   // Operación de suma
    else
        adder_sub_out = HQ - M;   // Operación de resta
end

// Control y actualización del registro `shift`
always_ff @(posedge clk) begin
    if (!rst) begin
        shift <= 'b0;
    end else if (shift_HQ_LQ_Q_1) begin
        // Desplazamiento aritmético a la derecha
        shift <= $signed(shift) >>> 1;
    end else begin
        if (load_B) begin
            shift[12:1] <= B; // Cargar B en `LQ`
            shift[0] <= 0;   // Inicializar `Q_1` a 0
        end
        if (load_add) begin
            shift[24:13] <= adder_sub_out; // Cargar el resultado en `HQ`
        end
    end
end

// Asignación de HQ, LQ y Q_LSB
always_comb begin
    HQ = shift[24:13];
    LQ = shift[12:1];
    Q_1 = shift[0];
    Y = {HQ, LQ};  // Concatenar HQ y LQ para la salida completa
    Q_LSB = {LQ[0], Q_1};  // Asignación para controlar suma o resta
end

endmodule
