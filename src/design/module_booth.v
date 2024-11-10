module mult_with_no_fsm#(
    parameter N = 8
) (
    input logic clk,
    input logic rst,
    input logic [N-1:0] A,
    input logic [N.1:0] B,
    input logic load_A,               // Control de carga de A
    input logic load_B,               // Control de carga de B
    input logic load_add,             // Control para carga de adición
    input logic shift_HQ_LQ_Q_1,      // Control de desplazamiento
    input logic add_sub,              // Control de suma/resta
    output logic [1:0] Q_LSB,
    output logic [2*N-1:0] Y
);

logic [N-1:0] M;
logic [N-1:0] adder_sub_out;
logic [2*N-1:0] shift;
logic [N-1:0] HQ;
logic [N-1:0] LQ;
logic Q_1;

// Registro de M
always_ff @(posedge clk) begin
    if (!rst)
        M <= 'b0;
    else if (load_A)
        M <= A ? A: M;
end

// Adición o sustracción
always_comb begin
    if (add_sub)
        adder_sub_out = HQ + M;   // Operación de suma
    else
        adder_sub_out = HQ - M;   // Operación de resta
end
// Asignación de HQ, LQ y Q_LSB
always_comb begin
    HQ = shift[2*N:N+1];
    LQ = shift[N:1];
    Q_1 = shift[0];
    Y = {HQ, LQ};  // Concatenar HQ y LQ para la salida completa
    Q_LSB = {LQ[0], Q_1};  // Asignación para controlar suma o resta
end
// Control y actualización del registro `shift`
always_ff @(posedge clk) begin
    if (!rst) begin
        shift <= 1'b0;
    end else if (shift_HQ_LQ_Q_1) begin
        // Desplazamiento aritmético a la derecha
        shift <= $signed(shift) >>> 1;
    end else begin
        if (load_B) begin
            shift[N:1] <= B; // Cargar B en `LQ`
            shift[0] <= 0;   // Inicializar `Q_1` a 0
        end
        if (load_add) begin
            shift[2*N:N+1] <= adder_sub_out; // Cargar el resultado en `HQ`
        end
    end
end



endmodule