module module_top_tb;
    // Entradas
    reg clk;
    reg rst;
    reg [3:0] row_in;

    // Salidas
    wire [3:0] col_out;
    wire [6:0] catodo_po;
    wire [3:0] anodo_po;

    // Instancia del módulo a probar
    module_top uut (
        .clk(clk),
        .rst(rst),
        .row_in(row_in),
        .col_out(col_out),
        .catodo_po(catodo_po),
        .anodo_po(anodo_po)
    );

    // Generación del reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Período de 10 unidades de tiempo
    end

    // Secuencia de pruebas
    initial begin
        // Inicialización
        rst = 1;
        row_in = 4'b0000;
        #10;
        rst = 0;

        // Simulación de la pulsación de teclas
        // Primer dígito del operando A
        row_in = 4'b0001; // Suponiendo que la tecla '1' representa el primer dígito
        #20;
        row_in = 4'b0000;
        #10;

        // Segundo dígito del operando A
        row_in = 4'b0010; // Suponiendo que la tecla '2' representa el segundo dígito
        #20;
        row_in = 4'b0000;
        #10;

        // Primer dígito del operando B
        row_in = 4'b0011; // Suponiendo que la tecla '3' representa el primer dígito
        #20;
        row_in = 4'b0000;
        #10;

        // Segundo dígito del operando B
        row_in = 4'b0100; // Suponiendo que la tecla '4' representa el segundo dígito
        #20;
        row_in = 4'b0000;
        #10;

        // Esperar para que el resultado de la multiplicación esté listo
        #100;

        // Verificar el resultado en el display
        $display("Resultado en display: Catodo = %b, Anodo = %b", catodo_po, anodo_po);

        // Finalizar simulación
        #20;
        $stop;
    end
        // Monitoreo de señales
    initial begin
        $monitor("Time: %0t ns | clk = %b | rst = %b | row_in = %b | col_out = %b | catodo_po = %b | anodo_po = %b", 
                 $time, clk, rst, row_in, col_out, catodo_po, anodo_po); 
    end 
endmodule
