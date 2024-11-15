module BoothMul(

    input clk,
    input rst,
    input start,
    input signed [6:0] A, B,   // Entrada de 7 bits
    output signed [15:0] Y,    // Salida de 16 bits
    output valid
);

    reg signed [15:0] Y, next_Y, Y_temp; // Ajuste de tamaño de Y a 16 bits
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
            Y <= 16'd0;            // Ajuste de tamaño de Y
            valid <= 1'b0;
            pres_state <= 1'b0;
            temp <= 3'd0;          // Ajuste de tamaño de temp
            count <= 4'd0;         // Ajuste de tamaño de count
        end
        else
        begin
            Y <= next_Y;
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
                next_temp = {A[0], 2'b0};  // Ajuste para 7 bits
                next_Y = {9'd0, A};         // Ajuste para 7 bits de A
            end
            else
            begin
                next_state = pres_state;
                next_temp = 3'b0;           // Ajuste para 7 bits
                next_Y = 16'd0;             // Ajuste de tamaño de Y
            end
        end

        START:s
        begin
            case(temp)
            3'b100:   Y_temp = {Y[15:8] - B, Y[7:0]};   // Ajuste de tamaño de Y
            3'b011:   Y_temp = {Y[15:8] + B, Y[7:0]};   // Ajuste de tamaño de Y
            default:  Y_temp = {Y[15:8], Y[7:0]};       // Ajuste de tamaño de Y
            endcase
            
            next_temp = {A[count+1], A[count], 1'b0}; // Ajuste para 7 bits de A
            next_count = count + 1'b1;
            next_Y = Y_temp >>> 1;  // Desplazamiento a la derecha
            next_valid = (count == 4'b111) ? 1'b1 : 1'b0; // Se activa al completar las iteraciones
            next_state = (count == 4'b111) ? IDLE : pres_state;
        end
        endcase
    end
endmodule
