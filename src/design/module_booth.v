module mult_with_no_fsm#(
    parameter N = 8
) (
    input logic clk,
    input logic rst,
    input logic [N-1:0] A,
    input logic [N-1:0] B,
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
logic [2*N:0] shift;
logic [N-1:0] HQ;
logic [N-1:0] LQ;
logic Q_1;

// Registro de M
always_ff @(posedge clk or posedge rst) begin
    if (rst)
        M <= 'b0;
    else if (load_A)
        M <= A;
end

// Adición o sustracción
always_comb begin
    if (add_sub)
        adder_sub_out = M + HQ;
    else
        adder_sub_out = M - HQ;
end

// Registros de desplazamiento
always_comb begin
    Y = {HQ, LQ};
    HQ = shift[2*N:N+1];
    LQ = shift[N:1];
    Q_1 = shift[0];
    Q_LSB = {LQ[0], Q_1};
end

always_ff @(posedge clk or posedge rst) begin
    if (rst)
        shift <= 'b0;
    else if (shift_HQ_LQ_Q_1)
        // Desplazamiento aritmético
        shift <= $signed(shift) >>> 1;
    else begin
        if (load_B)
            shift[N:1] <= B;
        if (load_add)
            shift[2*N:N+1] <= adder_sub_out;
    end
end

endmodule
