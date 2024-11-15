module BoothMul(clk, rst, start, A, B, valid, Y);

    input clk;
    input rst;
    input start;
    input signed [3:0] A, B;
    output signed [7:0] Y;
    output valid;

    reg signed [7:0] Y, next_Y, Y_temp;
    reg next_state, pres_state;
    reg [1:0] temp, next_temp;
    reg [1:0] count, next_count;
    reg valid, next_valid;

    parameter IDLE = 1'b0;
    parameter START = 1'b1;

    always @(posedge clk or negedge rst)
    begin
    if (!rst)
    begin
            Y          <= 8'd0;
            valid      <= 1'b0;
            pres_state <= 1'b0;
            temp       <= 2'd0;
            count      <= 2'd0;
        end
        else
        begin
            Y          <= next_Y;
            valid      <= next_valid;
            pres_state <= next_state;
            temp       <= next_temp;
            count      <= next_count;
        end
        end

        always @(*)
        begin 
        case (pres_state)
            IDLE:
            begin
            next_count = 2'b0;
            next_valid = 1'b0;
            if (start)
            begin
                next_state = START;
                next_temp  = {A[0], 1'b0};
                next_Y     = {4'd0, A};
            end
            else
            begin
                next_state = pres_state;
                next_temp  = 2'd0;
                next_Y     = 8'd0;
            end
            end

            START:
            begin
                case (temp)
                    2'b10:   Y_temp = {Y[7:4] - B, Y[3:0]};
                    2'b01:   Y_temp = {Y[7:4] + B, Y[3:0]};
                    default: Y_temp = {Y[7:4], Y[3:0]};
                endcase
                next_temp  = {A[count + 1], A[count]};
                next_count = count + 1'b1;
                next_Y     = Y_temp >>> 1;
                next_valid = (&count) ? 1'b1 : 1'b0; 
                next_state = (&count) ? IDLE : pres_state;  
            end
        endcase
    end

endmodule

