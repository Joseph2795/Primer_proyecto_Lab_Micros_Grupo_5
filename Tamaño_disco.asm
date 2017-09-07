;-------------------------  MACRO #1  ----------------------------------
;Macro-1: impr_texto.
;	Imprime un mensaje que se pasa como parametro
;	Recibe 2 parametros de entrada:
;		%1 es la direccion del texto a imprimir
;		%2 es la cantidad de bytes a imprimir
;-----------------------------------------------------------------------
%macro impr_texto 2 	;recibe 2 parametros
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,%1	;primer parametro: Texto
	mov rdx,%2	;segundo parametro: Tamano texto
	syscall
%endmacro
;------------------------- FIN DE MACRO --------------------------------

;-------------------------  MACRO #2  ----------------------------------
;Macro-2: impr_linea.
;	Imprime un mensaje que se pasa como parametro y un salto de linea
;	Recibe 2 parametros de entrada:
;		%1 es la direccion del texto a imprimir
;		%2 es la cantidad de bytes a imprimir
;-----------------------------------------------------------------------
%macro impr_linea 2 	;recibe 2 parametros
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,%1	;primer parametro: Texto
	mov rdx,%2	;segundo parametro: Tamano texto
	syscall
  mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,cons_nueva_linea	;primer parametro: Texto
	mov rdx,1	;segundo parametro: Tamano texto
	syscall
%endmacro
;------------------------- FIN DE MACRO --------------------------------

;------------------------- FIN DE MACRO --------------------------------
;-------------------------  MACRO #3  ----------------------------------
;Macro-3: capturar_tecla.
;	Lee la tecla que introduce el usuario
;	Recibe 2 parametros de entrada:
;		%1 es la direccion donde se almacena la tecla
;		%2 es la cantidad de bytes 
;-----------------------------------------------------------------------
%macro capturar_tecla 2 	;recibe 2 parametros
	mov rax,0	;"sys_read"
	mov rdi,0	;   (standard input = teclado)
	mov rsi,%1	;primer parametro: Texto
	mov rdx,%2	;segundo parametro: Tamano texto
	syscall
%endmacro
;------------------------- FIN DE MACRO --------------------------------

;-------------------------  MACRO #4  ----------------------------------
%macro impr_decfe 1 ;imprime el dato de entrada en decimal, solo puede imprimir del 0 al 99
	mov r8,%1  ;copia el dato de entrada en un registro
	mov r9,0   ;inicializa en cero un registro
%%_resta1:
	cmp r8,10 ; revisa si hay  decenas a imprimir
	jge %%dism101 ;imprime decenas
	jmp %%impr_r91
%%impr_r81:
	add r8,48 ; pasa a ascii
        mov [modelo],r8 ; guarda el dato
	impr_texto modelo,1  ;imprime la unidad
	jmp %%copia1 ;copia los valores por si es necesario su posterior uso

%%impr_r91:
	add r9,48 ; se pasa a ascii
        mov [modelo],r9 ;guarda el dato
	impr_texto modelo,1  ; imprime decenas
	jmp %%impr_r81 ;va a imprimir las unidades
%%dism101:
	sub r8,10  ; se resta 10 al dato
	add r9,1   ; se suma uno al contador de decenas
	jmp %%_resta1 ; se devuelve al inicio de la macro
%%copia1:
	mov [modelo2],r9 ;guarda el dato
	mov [modelo3],r8 ;guarda el dato
	%%_b21:
	mov r9, [modelo2]
	cmp r9,48
	jle %%_b31
	cmp r9,57
	jge %%_b31
	mov rbx, 3
	mov rax, 4
	mov rcx, modelo2
	mov rdx, 1
	int 0x80
	%%_b31:
	mov rbx, 3
	mov rax, 4
	mov rcx, modelo3
	mov rdx, 1
	int 0x80
%%fin:
%endmacro

;------------------------- FIN DE MACRO --------------------------------

section .data
nombre_archivo: db '/sys/block/sda/size',0
tam_nombre_archivo: equ $-nombre_archivo



tabla: db "0123456789ABCDEF",0
  msj_cache_t : db 'Informacion de la memoria cache:  '
  msj_tam_cache_t: equ $-msj_cache_t
  cache_t db 'Cache Total=0x '
  tam_cache_t: equ $-cache_t
  limp_terminal    db 0x1b, "[2J", 0x1b, "[H"  
  limp_terminal_tam equ $ - limp_terminal
 
 bloques db 'Número de bloques =  '
 tam_bloques: equ $-bloques

 TD db 'Tamaño de disco duro:  '
 tam_TD: equ $-TD

cons_hex_header: db ' 0x'
 cons_tam_hex_header: equ $-cons_hex_header
 cons_fabricante: db 'Fabricante: '
 cons_tam_fabricante: equ $-cons_fabricante
cons_stepping: db 'Stepping - Numero revision: '
cons_tam_stepping: equ $-cons_stepping
 cons_familia: db 'Familia: '
cons_modelo: db 'Modelo: '
cons_tam_modelo: equ $-cons_modelo
cons_tam_familia: equ $-cons_familia
cons_tipo_cpu: db 'Tipo de procesador: '
cons_tam_tipo_cpu: equ $-cons_tipo_cpu
cons_modelo_ext: db 'Modelo extendido: '
cons_tam_modelo_ext: equ $-cons_modelo_ext  
PN db  'Nombre del procesador:  ', 
tam_PN: equ $-PN
ID db  'Información del procesador:  ', 
tam_ID: equ $-ID

 GB db ' GB '
 tam_GB:  equ  $-GB


HD db  'Información del disco duro:  '
tam_HD: equ $-HD

SLinea2 db 0xa
cons_nueva_linea2: equ $-SLinea2
cores:db'Cores :'
tam_cores:equ $-cores
threads: db 'Threads : '
tam_threads:equ $-threads

  ram_libre db 'Memoria RAM libre=0x '
  tam_ram_libre: equ $-ram_libre

 SLinea db 0xa
 cons_nueva_linea: db 0xa

section .bss

modelo0: resb 8
modelo: resb 8
modelo2: resb 8
modelo3: resb 8

contenido_archivo: resb 10
out: resb 1 ;Salida en formato ASCII hacia consola
datofinal: resb 56 ;Salida en formato ASCII hacia consola
section .text
global _start

_start:
mov ebx,nombre_archivo
mov eax,5
mov ecx,0
int 80h

mov eax,3
mov ebx,3
mov ecx,contenido_archivo
mov edx,150
int 80h


impr_texto   limp_terminal,   limp_terminal_tam
impr_texto  HD,  tam_HD
impr_linea  SLinea2,cons_nueva_linea2
;impr_texto bloques,tam_bloques	; imprime encambezado
impr_texto TD,tam_TD	; imprime encambezado

mov r8,0x0      ;Limpio el registro
mov r8,[contenido_archivo]	
and r8,0x0000000F ;utilizo una màscara para extraer el dato que nos interesa
mov rax,r8		
mov r9,10000000 ; para hacer la conversión
mul r9 ; mùltiplico lo que hay en r8 con lo que tiene r9
mov r8,rax ; muevo el resultado del producto a r8 ( se encontraba almacenado en rax)
mov[datofinal],r8 


_b1:

mov r8,0x0      ;Limpio el registro
mov r8,[contenido_archivo]		;busca el segundo registro de memoria total (son ceros asi que con 1 byte basta)
and r8,0x00000F00		
shr r8,8
mov rax,r8
mov r9, 1000000
mul r9
mov r8,[datofinal]
add r8,rax
mov [datofinal],r8

_b2:



mov r8,0x0      ;Limpio el registro
mov r8,[contenido_archivo]	
and r8,0x000F0000		
shr r8,16
mov rax,r8
mov r9, 100000
mul r9
mov r8,[datofinal]
add r8,rax
mov [datofinal],r8

_b3:
mov r8,0x0      ;Limpio el registro
mov r8,[contenido_archivo]	
and r8,0x0F000000		
shr r8,24
mov rax,r8
mov r9, 10000
mul r9
mov r8,[datofinal]
add r8,rax
mov [datofinal],r8
_b4:
;____________________________________

mov r8,0x0      ;Limpio el registro
mov r8,[contenido_archivo+4]	
and r8,0x0000000F		
mov rax,r8
mov r9, 1000
mul r9
mov r8,[datofinal]
add r8,rax
mov [datofinal],r8

mov r8,0x0      ;Limpio el registro
mov r8,[contenido_archivo+4]		;busca el segundo registro de memoria total (son ceros asi que con 1 byte basta)
and r8,0x00000F00		
shr r8,8
mov rax,r8
mov r9, 100
mul r9
mov r8,[datofinal]
add r8,rax
mov [datofinal],r8

mov r8,0x0      ;Limpio el registro
mov r8,[contenido_archivo+4]	
and r8,0x000F0000		
shr r8,16
mov rax,r8
mov r9, 10
mul r9
mov r8,[datofinal]
add r8,rax
mov [datofinal],r8

mov r8,0x0      ;Limpio el registro
mov r8,[contenido_archivo+4]	
and r8,0x0F000000		
shr r8,24
mov rax,r8
mov r9, 1
mul r9
mov r8,[datofinal]
add r8,rax
mov [datofinal],r8

mov rax,[datofinal]
mov r9,2097152    ;  (1024*1024*2) para convertir en GB
div r9
mov [datofinal],rax

impr_decfe [datofinal]
impr_texto GB,tam_GB	; imprime encambezado

impr_linea  SLinea2,cons_nueva_linea2

_bp:
mov eax,1
mov ebx,0
int 0x80