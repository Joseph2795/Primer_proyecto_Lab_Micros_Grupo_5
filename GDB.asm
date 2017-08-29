;****************************************
section .data
section .bss
;Variable reservada para recibir datos
uptime: resw 4

section .text
global _start
_start:
mov rax,0x63
mov rdi, uptime
mov rdx, uptime+8
syscall
mov rsi,[rdx]
;Seccion que se encarga de multiplicar el dato por 100,para convertirlo a %
;La multiplicacion a realizar multiplica un reg de 64bits por un # de 64 bits
;El resultado se almacena en dos reg, uno para los 64 bits superiores y otro para los 64 inferiores
;En rdx se almacenan los bits superiores y en rax, primero se encuentra uno 
;de los factores y luego de la multiplicacion, se almacenan los 64 bits inferiores del producto
_mul:
mov rdx,0x0 ;limpia este registro, debido a que se ocupa para guardar lo 64 bits superiores 
mov rax,rsi; primer factor  
mov r8,0x64; almacena el otro factor de la multiplicacion, en este caso el # 100
mul r8; se realiza la multiplicacion
;Seccion que se encarga de dividir el resultado de la multiplicacion por el # 65535
;El cociente se almacena en rax y el remanete en rdx
_div:
mov r9,0xffff ; se almacena el divisor, en este caso el #65535
div r9;se realiza la división, el r se almacena en rax
mov r10,rax;copia el resultado de la operacion en este registro, para motivos de impresion
_bp1:
mov eax,1
mov ebx,0
int 0x80

;****************************************
