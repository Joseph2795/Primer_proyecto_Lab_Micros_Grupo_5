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
	mov r11,0
%%_resta:
	cmp r8,1000; revisa si el dato es mayor a mil
	jge %%dism1000; si es mayor a 1000, se disminuyen los millares
	cmp r8,100 ; revisa si el dato es mayor a 100
	jge %%dism100 ;si es mayor a 100, se disminuyen las centenas
	cmp r8,10 ; revisa si el dato es mayor 10
	jge %%dism10 ; si es mayor a 10, se disminuyen las decenas
	cmp r11,0; revisa si hay millares a imprimir
	jne %%impr_r11; imprime millares
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
    
%%impr_r11:
    add r11,48; se pasa a ascii
    mov [modelo],r11; guarda el dato
    impr_texto modelo,1; imprime millar
    jmp %%impr_r10 ; va a imprimir la centena
    
%%dism1000:
	sub r8,1000 ; se resta 1000 al dato
	add r11,1 ; se suma uno al contador de millares
	jmp %%_resta ; se devuelve al inicio de la macro
%%dism100:
	sub r8,100 ; se resta 100 al dato
	add r10,1 ; se suma uno al contador de centenas
	jmp %%_resta ; se devuelve al inicio de la macro
%%dism10:
	sub r8,10  ; se resta 10 al dato
	add r9,1   ; se suma uno al contador de decenas
	jmp %%_resta ; se devuelve al inicio de la macro
%%copiar:
	mov [modelo0],r11 ; guarda el dato
	mov [modelo],r10 ;guarda el dato
	mov [modelo2],r9 ;guarda el dato
	mov [modelo3],r8 ;guarda el dato
	%%_b0:
	cmp r11,48
	jle %%_b1
	cmp r11,57
	jge %%_b1
	mov rbx, 3
	mov rax, 4
	mov rcx, modelo0
	mov rdx, 1
	int 0x80
	%%_b1:
	mov r10, [modelo]
	cmp r10,48
	jle %%_b2
	cmp r10,57
	jge %%_b2
	mov rbx, 3
	mov rax, 4
	mov rcx, modelo
	mov rdx, 1
	int 0x80
	%%_b2:
	mov r9, [modelo2]
	cmp r9,48
	jle %%_b3
	cmp r9,57
	jge %%_b3
	mov rbx, 3
	mov rax, 4
	mov rcx, modelo2
	mov rdx, 1
	int 0x80
	%%_b3:
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
cons_error: db 'Uso del programa: Debe ingresar un límite de tiempo en segundos'
cons_tam_error: equ $-cons_error
cons_final: db 'Muestreo completo. Resultados almacenados en el archivo <result.txt>'
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
cons_esp: db ' '
cons_tam_esp: equ $-cons_esp
cons_arch: db '*****Recopilacion de resultados en archivo*****'
cons_tam_arch: equ $-cons_arch

section .bss
;Variable reservada para recibir datos
result_fd: resb 8
uptime: resw 4
modelo0: resb 8
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
valor_max: resb 5
tiempo_espera:
	tv_sec: resq 1 ;Cantidad de espera en segundos
	tv_nsec: resq 9 ;cantidad de espera en nanosegundos

section .text

global _start

_start: 

;ABRIR ARCHIVO
mov EAX, 8
mov EBX, filename
mov ECX, 0777o; 
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

; Esta sección se encarga de conseguir la fecha y la hora actuales de computadora. 
; La función utilizada es gettimeofday, la cual me da un valor en segundos del tiempo que a pasado desde 1/1/70, a esto se le llama EPOCH.
; Debido a que el dato se obtiene en segundos, hay que realizar distintas conversiones para obtener los valores del año, mes, día, hora,
; minutos y segundos actuales

;Conseguir año
_ano:

mov rax,96; deja listo cual llamada de siste se va hacer
mov rdi,fecha; direcciona la posición en la que se va a guardar
syscall; se hace la llamada de sistema
mov r8,[fecha]; se obtiene el valor almacenado en dicha dirección, para su uso
mov rdx,0x0
mov rax,r8; se agrega el dividendo
mov r9,0x01E1853E; se agrega el divisor, en este caso corresponde al numero de segundos que hay en un año
div r9; se realiza la divison
mov r15,rax ; se almacena los número de años que han pasado desde la fecha mencionada, hasta la fecha actual
mov r8,0x7B2; se agrega el numero 1970
add r8,rax; se suma el numero de años que han pasado a 1970, para obtener el año actual
mov [ano],r8; se almacena el dato final en la variable ano

;Conseguir mes
_mes:

mov r8,[fecha]
mov rdx,0x0
mov rax,r8
mov r9, 0x0028206F ; se agrega el divisor, en este caso corresponde al numero de segundos que hay en un mes
div r9
mov r9,rax ; se almacena los número de años que han pasado desde la fecha mencionada, hasta la fecha actual
mov rdx,0x0; se limpia el registro
mov rax,r15; se agrega el primer factor, en este caso el numero de años que han pasado
mov r14,0xC; se agrega el segundo factor, en este caso el numero de meses que hay en un año
mul r14; se realiza la multiplicacion
sub r9,rax; lo que se acá, es que para obtener el mes actual, se resta el numero de meses totales que han pasado desde 1/1/70 menos
; los que han pasado hasta el 1/1/año actual, el residuo es el número de meses que han pasado desde inicio de año
add r9,1; factor de correción del numero de meses
mov [mes],r9 ; se guarda el dato

;Conseguir dia 

_dia:

mov r8,[fecha]
add r8,20000
mov rdx,0x0
mov rax,r8
mov r9,86400 ;se agrega el divisor, en este caso corresponde al numero de segundos que hay en un día
div r9
mov r9,rax
mov rdx,0x0
; similar a lo que se hizo para el mes, se realiza realiza una diferencia entre el numero total de días que han pasado hasta ahora, menos 
; los que han pasado hasta inicio de año. El valor resultante será el número del día del año (1-365). La fecha exacta del día, no se realiza
; debido a su complejidad.
mov rax,r15
mov r14,365
mul r14
sub r9,rax
sub r9,10; correción de los días bisiestos 
mov [dia],r9; se guardo el dato

_hora:

;add r15, 1970
;mov [ano],r15

_input:
;LIMPIA VARIABLES 
xor r8,r8
xor r9,r9
xor r10,r10
xor r11,r11

_rev:
;Primero se imprime el encabezado
impr_texto cons_header,cons_tam_header
;Ahora se captura 5 teclazos (cuatro del tiempo y uno de la tecla enter)
mov rax,0 ;se pone al sistema en modo lectura
mov rdi,0 ;input de entrada el teclado
mov rsi,valor_max ;direccion donde se va a guardar el dato
mov rdx,5 ;se captura 5 teclazos
syscall

_ber:
; se guarda el mismo dato en varios registros, para su posterior uso
mov r8,[valor_max]
mov r9,[valor_max]
mov r10,[valor_max]
mov r11,[valor_max]
;se comienza a adquirir número por número del dato ingresado del usuario, para su posterior conversión de ascii a int
shr r11,24 ; se adquiere unidades de los segundos
and r11,0x000000FF ; se limpia el registro de cualquier dato indeseado 
and r10,0x00FF0000 ; se limpia el registro de cualquier dato indeseado
shr r10,16 ; se adquiere las decenas de los segundos
and r9,0x0000FF00 ; se limpia el registro de cualquier dato indeseado
shr r9,8 ; se adquiere las unidades de los minutos
and r8,0x000000FF ; se limpia el registro de cualquier dato indeseado y se adquiere el las decenas de los minutos

_brev0:
;esta sección es para verificar que el usuario no ingrese ningún caracter indebido
;como los datos deben ser solo número, se realiza la comparación de los valores ascii ingresados
;con los valores ascii de 0 (48) y 9 (57). Sí se ingresa algún caracter que no este en ese rango
;se le comunica al usuario que debe ingresar solo números y se le vuelve a solicitar el dato

cmp r8, 48 ; revisa si el dato es mayor a 48
jl _error ;si es mayor a 48
cmp r8, 57 ; revisa si el dato es menor a 57
jg _error ;si es mayor a 48
cmp r9, 48 ; revisa si el dato es mayor a 48
jl _error ;si es mayor a 48
cmp r9, 57 ; revisa si el dato es menor a 57
jg _error ;si es mayor a 48
cmp r10, 48 ; revisa si el dato es mayor a 48
jl _error ;si es mayor a 48
cmp r10, 57 ; revisa si el dato es menor a 57
jg _error ;si es mayor a 48
cmp r11, 48 ; revisa si el dato es mayor a 48
jl _error ;si es mayor a 48
cmp r11, 57 ; revisa si el dato es menor a 57
jg _error ;si es mayor a 48

xor r12,r12

cmp r8, 48 ; revisa si el dato es mayor a 48
jne _continue
inc r12;
cmp r9, 48 ; revisa si el dato es mayor a 48
jne _continue
inc r12;
cmp r10, 48 ; revisa si el dato es mayor a 48
jne _continue
inc r12;
cmp r11, 48 ; revisa si el dato es mayor a 48
jne _continue
inc r12;

cmp r12, 4
je _error



;se realiza la conversión de ascii a su valor decimal, para hacer el dato útil para las operaciones

_continue:

sub r8,0x30
sub r9,0x30
sub r10,0x30
sub r11,0x30

; se obtienen los valores de las decenas

; decenas de los minutos

mov rdx,0x0 ;limpia este registro, debido a que se ocupa para guardar lo 64 bits superiores 
mov rax,r8; primer factor
mov r12,0xA; almacena el otro factor de la multiplicacion, en este caso el # 10
mul r12; se realiza la multiplicacion
mov r8,rax

;decenas de los segundos

mov rdx,0x0
mov rax,r10
mov r12,0xA
mul r12
mov r10,rax

; se obtiene el valor final de minutos y segundos por separados
add r8,r9
add r10,r11

;se obtiene el valor final de la cantidad de segundos ingresados. Se convierte la cantidad de minutos a segundos 
;y se le agrega los segundos restantes.

mov rdx,0x0 ;limpia este registro, almacena primeramente los bits superiores y luego de la operación, almacena el producto de la multiplicacion
mov rax,r8; se agrega el primer factor, en este caso el numero de segundos
mov r13,0x3C; se agrega el segundo factor, que sería 60, el equivalente de un minutos en segundos
mul r13; se realiza la multiplicacion
mov r8,rax ; se pasa el valor de la multiplicación al registro r8
add r8,r10 ; se le termina de agregar los segundos ingresados por usuario
mov [valor_max],r8 ; se almacena el dato en valor_max
xor r15,r15 ; limpia este registro
mov r15,[valor_max]; pasa el valor de valor_max al registro 15
;impr_dec [valor_max]

;El valor capturado es el que se va a esperar (en segundos)

_esperar:

;mov rax,35 ;syscall
;mov rdi,tiempo_espera
;xor rsi,rsi
;syscall


_start_l:

;esta parte es para obtener el valor de la carga de la computadora 

mov rax,0x63; realiza la llamada SysInfo, para obtener la informacion de la computadora
mov rdi, uptime; se almacena dicha info en esta direccion
mov rdx, uptime+8; se ingresa al dato de interés, en este caso la carga de la computadora en un minuto
syscall; se realiza la llamada de sistema
mov rsi,[rdx] ; se almacena la informacion a la que apunta rdx, en rsi

;Seccion que se encarga de multiplicar el dato por 100 y luego dividirlo por 65535, para obtener el porcentaje de la carga del CPU
;La multiplicacion a realizar multiplica un reg de 64bits por un # de 64 bits
;El resultado se almacena en dos reg, uno para los 64 bits superiores y otro para los 64 inferiores
;En rdx se almacenan los bits superiores y en rax, primero se encuentra uno
;de los factores y luego de la multiplicacion, se almacenan los 64 bits inferiores del producto.
;La división funciona de manera similar, solo que el dato del dividendo se almacena en dos registros,
;uno para los bits superiores y otro para los inferiores, y otro para el divisor
;Despues de la division, el dato del cociente se almacena en un solo reg de 64 bits

_mul:

mov rdx,0x0 ;limpia este registro, debido a que se ocupa para guardar lo 64 bits superiores 
mov rax,rsi; primer factor
mov r8,0x64; almacena el otro factor de la multiplicacion, en este caso el # 100
mul r8; se realiza la multiplicacion
;Seccion que se encarga de dividir el resultado de la multiplicacion por el # 65535
;El cociente se almacena en rax y el remanete en rdx

_div:

mov r9,0xffff ; se almacena el divisor, en este caso el #65535
div r9;se realiza la división, el resultado se almacena en rax
mov [result1],rax ; se almacena el dato final de la carga en result1

_divo:

impr_texto cons_menor, cons_tam_menor
mov EBX, 3
mov EAX, 4
mov ECX, cons_menor
mov EDX, cons_tam_menor
int 0x80
impr_dec [dia]
mov EBX, 3
mov EAX, 4
mov ECX, cons_slash
mov EDX, cons_tam_slash
int 0x80
impr_texto cons_slash, cons_tam_slash
impr_dec [mes]
mov EBX, 3
mov EAX, 4
mov ECX, cons_slash
mov EDX, cons_tam_slash
int 0x80
impr_texto cons_slash, cons_tam_slash
impr_dec [ano]
mov EBX, 3
mov EAX, 4
mov ECX, cons_mayor
mov EDX, cons_tam_mayor
int 0x80
impr_texto cons_mayor, cons_tam_mayor

impr_texto cons_esp, cons_tam_esp
mov EBX, 3
mov EAX, 4
mov ECX, cons_esp
mov EDX, cons_tam_esp
int 0x80

mov EBX, 3
mov EAX, 4
mov ECX, cons_menor
mov EDX, cons_tam_menor
int 0x80
impr_texto cons_menor, cons_tam_menor
impr_dec [result1]
impr_textocons cons_por,cons_tam_por
impr_texto cons_mayor, cons_tam_mayor

mov EBX, 3
mov EAX, 4
mov ECX, cons_por
mov EDX, cons_tam_por
int 0x80

mov EBX, 3
mov EAX, 4
mov ECX, cons_mayor
mov EDX, cons_tam_mayor
int 0x80

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

;para realizar un salto de línea entre cada dato que se imprime

_saltodelinea:

mov rax,1     ;sys_writ
mov rdi,1       ;std_ou
mov rsi,cons_nueva_linea        ;primer parametro: Texto
mov rdx,1       ;segundo parametro: Tamano texto
syscall

mov EBX, 3
mov EAX, 4
mov ECX, cons_nueva_linea
mov EDX, 1
int 0x80

sub r15, 1
jnz _start_l
jz _final	

_error:

impr_texto cons_error,cons_tam_error
xor r9,r9
mov r9, 2
mov [tv_sec],r9
xor r10,r10
mov r10,0
mov [tv_nsec],r10
mov rax,35 ;syscall
mov rdi,tiempo_espera
xor rsi,rsi
syscall
mov rax,1     ;sys_writ
mov rdi,1       ;std_ou
mov rsi,cons_nueva_linea        ;primer parametro: Texto
mov rdx,1       ;segundo parametro: Tamano texto
syscall

jmp _input

;************************************
;FINAL DE EJECUCION
;************************************

_final:

mov EAX, 6
int 0x80

impr_texto cons_final,cons_tam_final
xor r9,r9
mov r9, 2
mov [tv_sec],r9
xor r10,r10
mov r10,0
mov [tv_nsec],r10
mov rax,35 ;syscall
mov rdi,tiempo_espera
xor rsi,rsi
syscall
mov rax,1     ;sys_writ
mov rdi,1       ;std_ou
mov rsi,cons_nueva_linea        ;primer parametro: Texto
mov rdx,1       ;segundo parametro: Tamano texto
syscall

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
