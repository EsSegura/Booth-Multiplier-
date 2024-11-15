module BoothMul(clk, rst, start, X, Y, valid, Z);

input clk;
input rst;
input start;
input signed [6:0] X, Y;   // Entrada de 7 bits
output signed [15:0] Z;     // Salida de 16 bits
output valid;

reg signed [15:0] Z, next_Z, Z_temp; // Ajuste de tamaño de Z a 16 bits
reg next_state, pres_state;
reg [2:0] temp, next_temp; // Ajuste de tamaño de temp
reg [3:0] count, next_count; // Ajuste de tamaño de count
reg valid, next_valid;

parameter IDLE = 1'b0;
parameter START = 1'b1;

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        Z <= 16'd0;            // Ajuste de tamaño de Z
        valid <= 1'b0;
        pres_state <= 1'b0;
        temp <= 3'd0;          // Ajuste de tamaño de temp
        count <= 4'd0;         // Ajuste de tamaño de count
    end
    else
    begin
        Z <= next_Z;
        valid <= next_valid;
        pres_state <= next_state;
        temp <= next_temp;
        count <= next_count;
    end
end

always @ (*)
begin 
    case(pres_state)
    IDLE:
    begin
        next_count = 4'b0;     // Ajuste de tamaño de count
        next_valid = 1'b0;
        if(start)
        begin
            next_state = START;
            next_temp = {X[0], 2'b0};  // Ajuste para 7 bits
            next_Z = {9'd0, X};         // Ajuste para 7 bits de X
        end
        else
        begin
            next_state = pres_state;
            next_temp = 3'b0;           // Ajuste para 7 bits
            next_Z = 16'd0;             // Ajuste de tamaño de Z
        end
    end

    START:
    begin
        case(temp)
        3'b100:   Z_temp = {Z[15:8] - Y, Z[7:0]};   // Ajuste de tamaño de Z
        3'b011:   Z_temp = {Z[15:8] + Y, Z[7:0]};   // Ajuste de tamaño de Z
        default:  Z_temp = {Z[15:8], Z[7:0]};       // Ajuste de tamaño de Z
        endcase
        
        next_temp = {X[count+1], X[count], 1'b0}; // Ajuste para 7 bits de X
        next_count = count + 1'b1;
        next_Z = Z_temp >>> 1;  // Desplazamiento a la derecha
        next_valid = (count == 4'b111) ? 1'b1 : 1'b0; // Se activa al completar las iteraciones
        next_state = (count == 4'b111) ? IDLE : pres_state;
    end
    endcase
end
endmodule




















