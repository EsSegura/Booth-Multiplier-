module tb_mult_with_no_fsm;

    // Parámetros
    parameter N = 8;

    // Señales de prueba
    logic clk;
    logic rst;
    logic [N-1:0] A;
    logic [N-1:0] B;
    logic load_A;
    logic load_B;
    logic load_add;
    logic shift_HQ_LQ_Q_1;
    logic add_sub;
    logic [1:0] Q_LSB;
    logic [2*N-1:0] Y;

    // Instanciación del módulo a probar
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

    // Generador de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Generar un reloj de 10 unidades de tiempo
    end

    // Proceso de estímulo
    initial begin
        // Inicialización
        rst = 0;
        load_A = 0;
        load_B = 0;
        load_add = 0;
        shift_HQ_LQ_Q_1 = 0;
        add_sub = 0;
        A = 0;
        B = 0;

        // Aplicar un reset
        #10 rst = 1; // Habilitar el reset
        #10 rst = 0; // Deshabilitar el reset

        // Cargar A y B
        A = 8'b00001111; // 15 en decimal
        load_A = 1;
        #10 load_A = 0; // Deshabilitar carga de A

        B = 8'b00000011; // 3 en decimal
        load_B = 1;
        #10 load_B = 0; // Deshabilitar carga de B

        // Realizar una suma
        load_add = 1;
        add_sub = 1; // Sumar
        #10 load_add = 0; // Deshabilitar carga de suma

        // Shift
        shift_HQ_LQ_Q_1 = 1; // Desplazar
        #10 shift_HQ_LQ_Q_1 = 0; // Deshabilitar el desplazamiento

        // Realizar una resta
        load_add = 1;
        add_sub = 0; // Restar
        #10 load_add = 0; // Deshabilitar carga de resta

        // Otro desplazamiento
        shift_HQ_LQ_Q_1 = 1; // Desplazar
        #10 shift_HQ_LQ_Q_1 = 0; // Deshabilitar el desplazamiento

        // Finalizar la simulación
        #10 $finish;
    end

    // Monitoreo de señales
    initial begin
        $monitor("Time: %0t | A: %b | B: %b | Y: %b | Q_LSB: %b", $time, A, B, Y, Q_LSB);
    end
    // Monitorear la salida
    initial begin
        $dumpfile("tb_mult_with_no_fsm.vcd");
        $dumpvars(0, tb_mult_with_no_fsm);
        $monitor("Time: %0t ns | clk = %b | rst = %b | A = %d | B = %d | load_A = %b | load_B = %b | load_add = %b | shift_HQ_LQ_Q_1 = %b | add_sub = %b | Q_LSB = %b | Y = %d", 
                 $time, clk, rst, A, B, load_A, load_B, load_add, shift_HQ_LQ_Q_1, add_sub, Q_LSB, Y);
    end

endmodule
