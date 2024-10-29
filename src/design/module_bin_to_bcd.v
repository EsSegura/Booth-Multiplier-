module bin_to_bcd (
    input [11:0] binario,  // Entrada binaria de 12 bits
    output reg [15:0] bcd   // Salida BCD de 16 bits (4 dígitos)
);
    integer i;

    always @(*) begin
        // Inicializar BCD a 0
        bcd = 16'b0;

        // Proceso de conversión de binario a BCD
        for (i = 0; i < 12; i = i + 1) begin
            // Revisar y ajustar cada grupo de 4 bits si es necesario
            if (bcd[3:0] >= 5) 
                bcd[3:0] = bcd[3:0] + 4'd3;
            if (bcd[7:4] >= 5) 
                bcd[7:4] = bcd[7:4] + 4'd3;
            if (bcd[11:8] >= 5) 
                bcd[11:8] = bcd[11:8] + 4'd3;
            if (bcd[15:12] >= 5) 
                bcd[15:12] = bcd[15:12] + 4'd3;

            // Desplazar los bits del BCD hacia la izquierda y agregar el bit de binario
            bcd = {bcd[14:0], binario[11 - i]};
        end
    end
endmodule











