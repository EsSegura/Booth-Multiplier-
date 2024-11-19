# Calculadora multiplicadora mediante el algoritmo de Booth.
### Estudiantes:
-Christian Aparicio Cambronero

-Eric Castro Velazquez

-Esteban Segura García 
## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays
- **CLK**: Clock
- **RST**: Reset

## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

[1] Simple Tutorials for Embedded Systems, "*How to Create a 7 Segment Controller in Verilog? | Xilinx FPGA Programming Tutorials*", YouTube, 3 de octubre de 2018. Available: https://www.youtube.com/watch?v=v2CM8RaEeQU&t=116s

[2] Anas Salah Eddin, "*49 - Verilog Description of FSMs*", YouTube, 26 de marzo de 2018. Available: https://www.youtube.com/watch?v=j2v2s7caBwI

[3] Anas Salah Eddin, "*M3-6-Debouncing Circuit (FSM)*", YouTube, 4 de septiembre de 2020. Available: https://www.youtube.com/watch?v=wLqPSPC7dWE

## 3. Desarrollo

### 3.0 Descripción general del sistema


### 3.1 Módulo 1
#### 3.1.1. module_input_control
```SystemVerilog

```
#### 3.1.2. Parámetros

No se definen parámetros para este módulo.

#### 3.1.3. Entradas y salidas:



##### Descripción del módulo:


#### 3.1.4. Criterios de diseño




### 3.2 Módulo 2
#### 3.2.1 Module_7_segments
```SystemVerilog

```
#### 3.2.2. Parámetros



#### 3.2.3. Entradas y salidas:


    
##### Descripción del módulo:



#### 3.2.4. Criterios de diseño





### 3.3 Módulo 3
#### 3.3.1. module_bin_to_bcd
```SystemVerilog

```
#### 3.3.2. Parámetros

No se definen parámetros para este módulo

#### 3.3.3. Entradas y salidas:
##### Descripción de la entrada:



##### Descripción del módulo:

El módulo `bin_decimal` está diseñado para convertir un número binario de 16 bits en su equivalente en BCD de 16 bits. El proceso de conversión se realiza mediante un algoritmo de desplazamiento que itera a través de cada bit de la entrada binaria. En cada iteración, se verifica si alguno de los grupos de 4 bits en la salida BCD es mayor o igual a 5; si es así, se le suma 3 a ese grupo, siguiendo el método de corrección de BCD. Luego, el módulo desplaza el valor actual de BCD hacia la izquierda, incorporando el siguiente bit de la entrada binaria en la posición menos significativa. Este proceso se repite durante 12 ciclos, asegurando que todos los bits del número binario se conviertan adecuadamente en su representación BCD.

#### 3.3.4. Criterios de diseño



### 3.4 Módulo 4
#### 3.3.1. module_debouncer
```SystemVerilog

```
#### 3.3.2. Parámetros



#### 3.3.3. Entradas y salidas:
##### Descripción de la entrada:



##### Descripción del módulo:



#### 3.3.4. Criterios de diseño 




### 4. Testbench
Con los modulos listos, se trabajo en un testbench para poder ejecutar todo de la misma forma y al mismo tiempo, y con ello, poder observar las simulaciones y obtener una mejor visualización de como funciona todo el código. 
```SystemVerilog

```
#### Descripción del testbench 



#### 4.1.1. Parámetros


  
#### 4.1.2. Entradas y salidas:


#### 4.1.3. Criterios de diseño






### Otros modulos
En este apartado, se colocará el ultimo modulo, el cual corresponde a la unión de los 4 modulos para poder ejecutar un Makefile de manera correcta y su respectiva sincronización.
```SystemVerilog

```
#### Parámetros

No se definen parámetros para este módulo.

#### Entradas y salidas:
##### Descripción de la entrada:


##### Descripción del módulo:



#### Criterios de diseño



## 5. Consumo de recursos


   

## 6. Observaciones/Aclaraciones



## 7. Problemas encontrados durante el proyecto



