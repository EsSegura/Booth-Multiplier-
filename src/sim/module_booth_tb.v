`timescale 1ns/1ps

module tb_mult_with_no_fsm;
    parameter N = 12;  // Ancho de bits de entrada
    
    // Entradas del módulo
    logic clk;
    logic rst;
    logic [11:0] A, B;
    logic load_A;
    logic load_B;
    logic load_add;
    logic shift_HQ_LQ_Q_1;
    logic add_sub;
    
    // Salidas del módulo
    logic [1:0] Q_LSB;
    logic [23:0] Y;
    
    // Instancia del módulo a probar
    mult_with_no_fsm #(.N(N)) uut (
        .clk(clk),
        .rst(rst),
        .A(A),
        .B(B),
        .load_A(load_A),
        .load_B(load_B),
        .load_add(load_add),
        .shift_HQ_LQ_Q_1(shift_HQ_LQ_Q_1),
        .add_sub(add_sub),
        .Q_LSB(Q_LSB),
        .Y(Y)
    );
    
    // Generación del reloj
    always #5 clk = ~clk;  // Periodo de 10 ns (frecuencia de 100 MHz)
    
    // Monitor para observar el estado del sistema
    initial begin
        $monitor("Time: %0t ns | clk = %b | rst = %b | A = %d | B = %d | load_A = %b | load_B = %b | load_add = %b | shift_HQ_LQ_Q_1 = %b | add_sub = %b | Q_LSB = %b | Y = %d", 
                 $time, clk, rst, A, B, load_A, load_B, load_add, shift_HQ_LQ_Q_1, add_sub, Q_LSB, Y);
    end
    
    // Procedimiento de prueba
    initial begin
        // Inicialización
        clk = 0;
        rst = 0;
        load_A = 0;
        load_B = 0;
        load_add = 0;
        shift_HQ_LQ_Q_1 = 0;
        add_sub = 0;
        A = 8'd0;
        B = 8'd0;
        
        // Reset
        rst = 1;
        #10 rst = 0;
        #10 rst = 1;

        // Cargar valores en A y B
        A = 12'd15;   // Valor de prueba para A
        B = 12'd3;    // Valor de prueba para B
        load_A = 1;
        #10 load_A = 0;
        load_B = 1;
        #10 load_B = 0;

        // Iniciar la secuencia de multiplicación
        repeat (N) begin
            if (Q_LSB == 2'b01) begin
                // Si Q_LSB indica el valor de bit para suma
                add_sub = 1;     // Seleccionar suma
                load_add = 1;    // Cargar resultado de la suma
                #10 load_add = 0;
            end
            else if (Q_LSB == 2'b10) begin
                // Si Q_LSB indica el valor de bit para resta
                add_sub = 0;     // Seleccionar resta
                load_add = 1;    // Cargar resultado de la resta
                #10 load_add = 0;
            end
            
            // Desplazamiento aritmético a la derecha
            shift_HQ_LQ_Q_1 = 1;
            #10 shift_HQ_LQ_Q_1 = 0;
            #10;
        end
        
        // Verificar el resultado en Y
        $display("Resultado de la multiplicación: A = %d, B = %d, Y = %d", A, B, Y);
        
        // Finalizar la simulación
        #10 $stop;
    end
initial begin
    $dumpfile("tb_mult_with_no_fsm.vcd");  // Nombre del archivo de salida VCD
    $dumpvars(0, tb_mult_with_no_fsm);     // Registrar todas las señales del testbench actual
end

endmodule
