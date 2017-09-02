;****************************************
%macro impr_linea 2     ;recibe 2 parametros
        mov rax,1       ;sys_write
        mov rdi,1       ;std_out
        mov rsi,%1      ;primer parametro: Texto
        mov rdx,%2      ;segundo parametro: Tamano texto
        syscall
        mov rax,1     ;sys_write
        mov rdi,1       ;std_out
        mov rsi,cons_nueva_linea        ;primer parametro: Texto
        mov rdx,1       ;segundo parametro: Tamano texto
        syscall
%endmacro

%macro impr_texto 2 	;recibe 2 parametros
	mov rax,1	;sys_write
	mov rdi,[result_fd]	;std_out
	mov rsi,%1	;primer parametro: Texto
	mov rdx,%2	;segundo parametro: Tamano texto
	syscall
%endmacro

%macro impr_dec 1 ;imprime el dato de entrada en decimal, solo puede imprimir del 0 al 99
	mov r8,%1  ;copia el dato de entrada en un registro
	mov r9,0   ;inicializa en cero un registro
	mov r10,0
%%_resta:
	cmp r8,100 ; revisa si el dato es mayor a 100
	jge %%dism100 ;si es mayor a 100, se disminuyen las centenas
	cmp r8,10 ; revisa si el dato es mayor 10
	jge %%dism10 ; si es mayor a 10, se disminuyen las decenas
	cmp r10,0 ; revisa si hay centenas a imprimir
	jne %%impr_r10 ;imprime centenas
	cmp r9,0 ; revisa si hay  decenas a imprimir
	jne %%impr_r9 ;imprime decenas


%%impr_r8:
	add r8,48 ; pasa a ascii
        mov [modelo],r8 ; guarda el dato
	impr_texto modelo,1  ;imprime la unidad
        jmp %%copiar ;copia los valores por si es necesario su posterior uso


%%impr_r9:
	add r9,48 ; se pasa a ascii
        mov [modelo],r9 ;guarda el dato
	impr_texto modelo,1  ; imprime decenas
	jmp %%impr_r8 ;va a imprimir las unidades

%%impr_r10:
        add r10,48 ;se pasa a ascii
        mov [modelo],r10 ; guarda el dato
        impr_texto modelo,1 ; imprime la centena
	jmp %%impr_r9 ; va a imprimir la decena
%%dism100:
	sub r8,100 ; se resta 100 al dato
	add r10,1 ; se suma uno al contador de centenas
	jmp %%_resta ; se devuelve al inicio de la macro
%%dism10:
	sub r8,10  ; se resta 10 al dato
	add r9,1   ; se suma uno al contador de decenas
	jmp %%_resta ; se devuelve al inicio de la macro
%%copiar:
	mov r11,r8;copia unidades
	mov r12,r9;copia decenas
	mov r13,r10;copia centenas
%%fin:
%endmacro

section .data

tabla: db "0123456789ABCDEF",0
cons_nueva_linea: db 0xa

section .bss
;Variable reservada para recibir datos
result_fd: resb 8
uptime: resw 4
modelo: resb 8
result1: resb 56
un_byte: resb 1

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
mov [result1],rax
impr_dec [result1]

_saltodelinea:

mov rax,1     ;sys_writ
mov rdi,1       ;std_ou
mov rsi,cons_nueva_linea        ;primer parametro: Texto
mov rdx,1       ;segundo parametro: Tamano texto
syscall

_bp1:
mov eax,1
mov ebx,0
int 0x80

;****************************************
