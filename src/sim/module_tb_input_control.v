module tb_module_top;

    // Parámetros de entrada
    logic clk;
    logic rst;
    logic [3:0] row_in;
    
    // Salidas del módulo a probar
    logic [3:0] col_out;
    logic [6:0] catodo_po;
    logic [3:0] anodo_po;
    logic [12:0] stored_A;

    // Instanciar el módulo a probar
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
        forever #5 clk = ~clk; // Reloj de 10 ns
    end

    // Proceso de prueba
    initial begin
        // Inicializar señales
        rst = 0;
        row_in = 4'b0000; // Fila de entrada inicial

        // Activar el reset
        #10 rst = 1;

        // Esperar un ciclo para estabilizar
        #10;
        // Simular el ingreso de números del 0 al 9
        row_in = 4'b1000; // Fila de entrada inicial
        #10;
        // Finaliza la simulación
        row_in = 4'b0000; // Fila de entrada inicial
        #10;
        // Finaliza la simulación
        row_in = 4'b0010; // Fila de entrada inicial
        
        #10;
        $finish;
    end

    // Tarea para simular presiones de teclas
    task simulate_key_presses();
        integer i;
        for (i = 0; i < 10; i = i + 1) begin
            row_in = 4'b0000; // Asegúrate de que no haya ruido
            #10; // Esperar un ciclo
            row_in = 4'b0001 << i; // Simula presionar la tecla correspondiente
            $display("Tecla presionada: %d | Acumulador: %b", i, stored_A);
            #10; // Esperar para observar el efecto
        end
    endtask

    initial begin
        $dumpfile("teclado.vcd");
        $dumpvars(0, tb_module_top);
    end

endmodule




