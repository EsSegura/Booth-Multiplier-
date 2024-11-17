module tb_BoothMul;

    reg clk; // Reloj
    reg rst; // Reset
    reg start; // Señal para iniciar
    reg signed [7:0] A; // Operando A
    reg signed [7:0] B; // Operando B
    wire signed [15:0] Y; // Resultado
    wire valid; // Señal de resultado válido

    // Instanciación del módulo
    BoothMul uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .A(A),
        .B(B),
        .Y(Y),
        .valid(valid)
    );

    // Generación del reloj
    always #5 clk = ~clk; // Periodo de 10 unidades de tiempo

    // Estímulos
    initial begin
        // Inicialización
        clk = 0;
        rst = 0;
        start = 0;
        A = 0;
        B = 0;

        // Reset
        #10 rst = 1;

        // Caso de prueba: A = 12, B = -7
        #10 A = 8'd55; // Operando A
            B = 8'd75; // Operando B
            start = 1; // Iniciar operación
        #10 start = 0; // Desactivar señal de inicio

        // Esperar a que el resultado sea válido
        wait (valid);

        // Verificar resultado esperado (12 * -7 = -84)
        if (Y === -16'd84)
            $display("Test Passed: A = %d, B = %d, Y = %d", A, B, Y);
        else
            $display("Test Failed: A = %d, B = %d, Y = %d", A, B, Y);

        // Finalizar simulación
        #20 $finish;
    end

endmodule





















     













