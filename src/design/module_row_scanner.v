module row_scanner (
    input logic slow_clk,
    input logic rst,
    input logic [3:0] col_shift_reg,
    input logic [3:0] row_in,
    output logic [3:0] key_value,
    output logic key_pressed,
    output logic [2:0] is_sign_key,
);

    always_comb begin
        // Inicializacion de variables
        key_value = 4'b0000;
        key_pressed = 0;
        is_sign_key = 3'b000;
            // Posibles combinaciones
            case (col_shift_reg)
                4'b0001 :  case (row_in) // cuarta columna activa
                                4'b1000 : key_value = 4'b0001;  // "1"
                                4'b0100 : key_value = 4'b0100;  // "4"
                                4'b0010 : key_value = 4'b0111;  // "7"
                                4'b0001 : begin
                                    key_value = 4'b0000;  // "*"
                                    is_sign_key = 3'b100; // signo de resta
                                end 
                           endcase
                4'b0010 :  case (row_in) // tercera columna activa
                                4'b1000 : key_value = 4'b0010;  // "2"
                                4'b0100 : key_value = 4'b0101;  // "5"
                                4'b0010 : key_value = 4'b1000;  // "8"
                                4'b0001 : key_value = 4'b0000;  // "0"
                           endcase
                4'b0100 :  case (row_in) // segunda columna activa
                                4'b1000 : key_value = 4'b0011;  // "3"
                                4'b0100 : key_value = 4'b0110;  // "6"
                                4'b0010 : key_value = 4'b1001;  // "9"
                                4'b0001 : begin
                                    key_value = 4'b0000;  // "#"
                                    is_sign_key = 3'b010;
                                end 

                           endcase
                4'b1000 :  begin
                            case (row_in) // primera columna activa
                                4'b1000 : begin
                                    key_value = 4'b1010;  // "A"
                                    is_sign_key = 3'b001;           
                                end 
                                4'b0100 : begin
                                    key_value = 4'b1011;  // "B"
                                    is_sign_key = 3'b011;           
                                end 
                                4'b0010 : begin
                                    key_value = 4'b1100;  // "C"
                                    is_sign_key = 3'b011;                                               
                                end 
                                4'b0001 : begin
                                    key_value = 4'b1111;  // "D"
                                    is_sign_key = 3'b100;           
                                end
                                
                           endcase

                end
            endcase
            if (row_in != 4'b0000) begin
                key_pressed = 1;
            end  
        end
    
endmodule
