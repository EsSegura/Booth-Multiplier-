module tb_memoria;
    // Señales de prueba
    logic clk;
    logic rst;
    logic key_pressed;
    logic [3:0] key_value;
    logic [7:0] op_A;
    logic [7:0] op_B;
    logic listo;

    // Instancia del módulo memoria
    memoria uut (
        .clk(clk),
        .rst(rst),
        .key_pressed(key_pressed),
        .key_value(key_value),
        .op_A(op_A),
        .op_B(op_B),
        .listo(listo)
    );

    // Generación de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Periodo del reloj de 10 unidades de tiempo
    end

    // Proceso de prueba
    initial begin
        // Inicialización
        rst = 1;
        key_pressed = 0;
        key_value = 0;
        #10;

        // Desactivar el reset
        rst = 0;
        #10;
        
        // Probar la entrada del primer operando (op_A)
        key_value = 4'b0010; // Valor '2'
        key_pressed = 1; // Simular la tecla presionada
        #10; // Esperar un ciclo de reloj
        key_pressed = 0; // Soltar la tecla
        #10; 

        // Simular el segundo dígito del primer operando
        key_value = 4'b0001; // Valor '1'
        key_pressed = 1;
        #10;
        key_pressed = 0;
        #10;

        // Probar la entrada del segundo operando (op_B)
        key_value = 4'b0100; // Valor '4'
        key_pressed = 1; // Simular la tecla presionada
        #10; // Esperar un ciclo de reloj
        key_pressed = 0; // Soltar la tecla
        #10; 

        // Simular el segundo dígito del segundo operando
        key_value = 4'b0011; // Valor '3'
        key_pressed = 1;
        #10;
        key_pressed = 0;
        #10;

        // Verificar si ambos operandos están listos
        if (listo) begin
            $display("Ambos operandos ingresados: op_A = %b, op_B = %b", op_A, op_B);
        end else begin
            $display("Los operandos no están listos.");
        end



        // Finalizar simulación
        #20;
        $finish;
    end


    // Monitoreo de señales
    initial begin
        $monitor("Time: %0t ns | clk = %b | rst = %b | key_value = %b | key_pressed = %b | op_A = %b | op_B = %b | listo = %b", 
                 $time, clk, rst, key_value, key_pressed, op_A, op_B, listo); 
    end
  
    initial begin
        $dumpfile("tb_memoria.vcd");  // Nombre del archivo de salida VCD
        $dumpvars(0, tb_memoria);  // Registrar todas las señales del testbench
    end

endmodule
