module booth_tb;

    reg clk, rst, start;
    reg signed [7:0] X, Y;  // Ahora X y Y son de 8 bits para manejar hasta 99
    wire signed [15:0] Z;   // Z es ahora de 16 bits para manejar hasta 9999
    wire valid;

    always #5 clk = ~clk;  // Generación de reloj

    BoothMul inst (clk, rst, start, X, Y, valid, Z);

    initial
        $monitor($time, " X=%d, Y=%d, valid=%d, Z=%d", X, Y, valid, Z);  // Monitoreo de las señales

    initial
    begin
        X = 8'd5; Y = 8'd7; clk = 1'b1; rst = 1'b0; start = 1'b0;  // Inicialización
        #10 rst = 1'b1;  // Reset
        #10 start = 1'b1;  // Inicia multiplicación
        #10 start = 1'b0;  // Detiene el inicio
        #10;

        // Espera hasta que valid sea 1
        wait(valid == 1'b1);
        #10;  // Tiempo de espera para observar el resultado

        // Prueba con otros valores de X y Y
        X = -8'd4; Y = 8'd6; start = 1'b1;  // Cambia X y Y para otra multiplicación
        #10 start = 1'b0;
        wait(valid == 1'b1);
        #10;

        
        // Finaliza la simulación
        $finish;
    end

endmodule





















     













