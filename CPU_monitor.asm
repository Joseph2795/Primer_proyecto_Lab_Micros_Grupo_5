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

%macro impr_textocons 2 	;recibe 2 parametros
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,%1	;primer parametro: Texto
	mov rdx,%2	;segundo parametro: Tamano texto
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
	mov r13,r10;copia centenas
	mov r12,r9;copia decenas
	mov r11,r8;copia unidades
	mov [modelo],r13 ;guarda el dato
	mov [modelo2],r12 ;guarda el dato
	mov [modelo3],r11 ;guarda el dato
	_b1:
	mov rbx, 3
	mov rax, 4
	mov rcx, modelo
	mov rdx, 1
	int 0x80
	_b2:
	mov rbx, 3
	mov rax, 4
	mov rcx, modelo2
	mov rdx, 1
	int 0x80
	_b3:
	mov rbx, 3
	mov rax, 4
	mov rcx, modelo3
	mov rdx, 1
	int 0x80
%%fin:
%endmacro

section .data

filename: db "./result.txt", 0
cons_nueva_linea: db 0xa
cons_header: db 'Tiempo de espera (formato MMSS): '
cons_tam_header: equ $-cons_header
cons_error: db 'Uso del programa: Debe ingresar un límite de tiempo en segundos para monitorear'
cons_tam_error: equ $-cons_error
cons_final: db 'Muestreo completo. Resultados almacenados en el archivo'
cons_tam_final: equ $-cons_final
cons_terminando: db 'Terminando el programa.'
cons_tam_terminando: equ $-cons_terminando
cons_por: db '%'
cons_tam_por: equ $-cons_por
cons_slash: db '/'
cons_tam_slash: equ $-cons_slash
cons_menor: db '<'
cons_tam_menor: equ $-cons_menor
cons_mayor: db '>'
cons_tam_mayor: equ $-cons_mayor
cons_gui: db '-'
cons_tam_gui: equ $-cons_gui
cons_arch: db '*****Recopilacion de resultados en archivo*****'
cons_tam_arch: equ $-cons_arch

section .bss
;Variable reservada para recibir datos
result_fd: resb 8
uptime: resw 4
modelo: resb 8
modelo2: resb 8
modelo3: resb 8
result1: resb 56
fecha: resb 56
ano: resb 56
mes: resb 56
dia: resb 56
hora: resb 56
minu: resb 8
segu: resb 56
un_byte: resb 1
valor_max: resb 3
tiempo_espera:
	tv_sec: resq 1 ;Cantidad de espera en segundos
	tv_nsec: resq 9 ;cantidad de espera en nanosegundos

section .text

global _start

_start: 

;ABRIR ARCHIVO
mov EAX, 8
mov EBX, filename
mov ECX, 0700
int 0x80

mov EBX, 3
mov EAX, 4
mov ECX, cons_arch
mov EDX, cons_tam_arch
int 0x80

mov EBX, 3
mov EAX, 4
mov ECX, cons_nueva_linea
mov EDX, 1
int 0x80

mov rax,96
mov rdi,fecha
syscall
mov r8,[fecha]
mov rdx,0x0
mov rax,r8
mov r9,0x01E1853E
div r9
mov r15,rax
mov r8,0x7B2
add r8,rax
mov [ano],r8

_mes:

mov r8,[fecha]
mov rdx,0x0
mov rax,r8
mov r9, 0x0028206F
div r9
mov r9,rax
mov rdx,0x0
mov rax,r15
mov r14,0xC
mul r14
sub r9,rax
add r9,1
mov [mes],r9
mov 

_dia:

mov r8,[fecha]
add r8,20000
mov rdx,0x0
mov rax,r8
mov r9,86400
div r9
mov r9,rax
mov rdx,0x0
mov rax,r15
mov r14,365
mul r14
sub r9,rax
sub r9,10
mov [dia],r9

_hora:

add r15, 1970
mov [ano],r15

_result:

_input:

;Primero se imprime el encabezado
impr_texto cons_header,cons_tam_header
;Ahora se captura 2 teclazo
mov rax,0 ;se pone al sistema en modo lectura
mov rdi,0 ;input de entrada el teclado
mov rsi,valor_max ;direccion donde se va a guardar el dato
mov rdx,4 ;se captura dos teclazos
syscall

mov r8,[valor_max]
mov r9,[valor_max]
mov r10,[valor_max]
mov r11,[valor_max]
shr r11,24
and r10,0x00FF0000
shr r10,16
and r9,0x0000FF00
shr r9,8
and r8,0x000000FF

sub r8,0x30
sub r9,0x30
sub r10,0x30
sub r11,0x30


mov rdx,0x0 ;limpia este registro, debido a que se ocupa para guardar lo 64 bits superiores 
mov rax,r8; primer factor
mov r12,0xA; almacena el otro factor de la multiplicacion, en este caso el # 100
mul r12; se realiza la multiplicacion
mov r8,rax

mov rdx,0x0
mov rax,r10
mov r12,0xA
mul r12
mov r10,rax

add r8,r9
add r10,r11


mov rdx,0x0
mov rax,r8
mov r13,0x3C
mul r13
mov r8,rax
add r8,r10
mov [valor_max],r8
xor r15,r15
mov r15,[valor_max]
;impr_dec [valor_max]

;El valor capturado es el que se va a esperar (en segundos)

_esperar:

;mov rax,35 ;syscall
;mov rdi,tiempo_espera
;xor rsi,rsi
;syscall

_start_l:

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

_divo:

impr_dec [result1]
impr_textocons cons_por,cons_tam_por
xor r9,r9
mov r9, 1
mov [tv_sec],r9
xor r10,r10
mov r10,0
mov [tv_nsec],r10
_bp00:
mov rax,35 ;syscall
mov rdi,tiempo_espera
xor rsi,rsi
syscall

_saltodelinea:

mov rax,1     ;sys_writ
mov rdi,1       ;std_ou
mov rsi,cons_nueva_linea        ;primer parametro: Texto
mov rdx,1       ;segundo parametro: Tamano texto
syscall

mov EBX, 3
mov EAX, 4
mov ECX, cons_por
mov EDX, cons_tam_por
int 0x80

mov EBX, 3
mov EAX, 4
mov ECX, cons_nueva_linea
mov EDX, 1
int 0x80

sub r15, 1
jnz _start_l

;************************************
;FINAL DE EJECUCION
;************************************

_final:

mov EAX, 6
int 0x80

impr_texto cons_terminando,cons_tam_terminando
xor r9,r9
mov r9, 2
mov [tv_sec],r9
xor r10,r10
mov r10,0
mov [tv_nsec],r10
_bp09:
mov rax,35 ;syscall
mov rdi,tiempo_espera
xor rsi,rsi
syscall

_bp1:
mov eax,1
mov ebx,0
int 0x80

;****************************************
