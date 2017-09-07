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
section  .data

  tabla: db "0123456789ABCDEF",0
;----------------------------------Interfaz------------------------------------------------------
  limp_terminal    db 0x1b, "[2J", 0x1b, "[H"    ;Utilizado para limpiar la pantalla
  limp_terminal_tam equ $ - limp_terminal

;---------------------------------------------SUB MENU-------------------------------------------------------------------
cons_info2  db '-----------------------------------Opciones------------------------------------',13,10,13,10
                 db '1. Regresar al menú principal',13,10
                 db '2. Salir del programa',13,10
		 ;db '--------------------------------------------------------------------------------',13,10,13,10
cons_tamano_info2: equ $-cons_info2					; Longitud del banner
;----------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------MENU---------------------------------------------------------------
cons_banner: db 'Presione una tecla, y luego Enter:  '		; Banner para el usuario
cons_tamano_banner: equ $-cons_banner					; Longitud del banner
cons_info db '                       Instituto Tecnologico de Costa Rica',13,10 ; 13 es un 'enter' 10 un espacio
		 db '                                 Joseph Blanco',13,10
		 db '                               Sebastian Quesada',13,10
		 db '                                 Diego Delgado',13,10
		 db '                              Jean Carlos Gonzales',13,10
                 db '                         Escuela de Ing en Electronica',13,10
                 db '                 Laboratorio de Estructura de Microprocesadores',13,10,13,10
                 db '-------------------------------------MENU---------------------------------------',13,10,13,10
                 db '1. Ver Info del Microprocesador',13,10,13,10
                 db '2. Ver Info de la Memoria Cache',13,10
                 db '3. Ver Info de la memoria RAM',13,10
		 db '4. Ver nombre del procesador',13,10
		 db '5. Ver Cores y Threads',13,10
                 db '6. Ver info de disco duro',13,10,13,10
		 db '7. Salir',13,10,13,10
                 db '--------------------------------------------------------------------------------',13,10,13,10
                 db 'Seleccione una Opcion: ',13,10		; Banner para el usuario
cons_tamano_info: equ $-cons_info					; Longitud del banner

;------------------------------------------Salir--------------------------------------------------------------
cons_info3 db '                       Instituto Tecnologico de Costa Rica',13,10 ; 13 es un 'enter' 10 un espacio
		 db '                                 Joseph Blanco',13,10
		 db '                               Sebastian Quesada',13,10
		 db '                                 Diego Delgado',13,10
		 db '                              Jean Carlos Gonzales',13,10
                 db '                         Escuela de Ing en Electronica',13,10
                 db '                 Laboratorio de Estructura de Microprocesadores',13,10,13,10
                 db '--------------------------------------------------------------------------------',13,10,13,10
                 db '',13,10
                 db '',13,10
                 db '                           Programa finalizado',13,10
		 db '',13,10
		 db '',13,10
                 db '',13,10,13,10
                 db '--------------------------------------------------------------------------------',13,10,13,10
cons_tamano_info3: equ $-cons_info3					; Longitud del banner
variable1: db''													;Almacenamiento de la tecla capturada
;------------------------------------------------------------------------------------------------------------------------------------------------------------



;---------------------------Variables usadas en la caché----------------------------
  msj_cache_t : db 'Informacion de la memoria cache:  '
  msj_tam_cache_t: equ $-msj_cache_t
  cache_t db 'Bloque: 0x '
  tam_cache_t: equ $-cache_t
;---------------------------Variables usadas en la RAM----------------------------
  ram_t db 'Memoria RAM total: 0x '
  tam_ram_t: equ $-ram_t

  ram_libre db 'Memoria RAM libre: 0x '
  tam_ram_libre: equ $-ram_libre

MR db  'Información del la memoria RAM:  ', 
tam_MR: equ $-MR
;--------------------INFO--------------------------------------------------------------------------------------

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

;----------------------------------------Nombre del procesador-------------------------------------------
PN db  'Nombre del procesador:  ', 
tam_PN: equ $-PN
ID db  'Información del procesador:  ', 
tam_ID: equ $-ID
;----------------------------------------Cores y Threads-------------------------------------------

CT db  'Información de Cores y Threads:  ', 
tam_CT: equ $-CT
cores:db'Cores: ' 
tam_cores:equ $-cores
threads: db 'Threads: '
tam_threads:equ $-threads

;----------------------------------------Info de Disco duro--------------------------------------

nombre_archivo: db '/sys/block/sda/size',0
tam_nombre_archivo: equ $-nombre_archivo

bloques db 'Número de bloques: '
tam_bloques: equ $-bloques

TD db 'Tamaño de disco duro: '
tam_TD: equ $-TD

GB db ' GB '
tam_GB:  equ  $-GB

HD db  'Información del disco duro:  '
tam_HD: equ $-HD


;------------------------------------Saltos de linea----------------------------------------------

SLinea2 db 0xa
cons_nueva_linea2: equ $-SLinea2
SLinea db 0xa
cons_nueva_linea: db 0xa


;-----------------------------------Variables no inicializadas---------------------------
section  .bss

modelo0: resb 8
modelo: resb 8
modelo2: resb 8
modelo3: resb 8
contenido_archivo: resb 10

fabricante_id:       resd	12	 ;Identificacion del fabricante (vendor) [12 Double]
resultado: resb 56 
out: resb 1 ;Salida en formato ASCII hacia consola
variable: resb 1
variable2: resb 1
valor_max: resb 1
Pro_name: resd 48 ; Para obtener el nombre del procesador
datofinal: resb 56 ;Usado para almacenar el tamaño de disco duro
;---------------------------------------------------------------------------------------------------------

;Segmento de codigo
section .text
    global _start
;------------------------------Inicio de codigo--------------------------------------------------
_start:

jmp _MSJS
		
	
_MSJS:
		impr_texto   limp_terminal,   limp_terminal_tam
		;Imprimir el mensaje con la info
		mov rax,1							;rax = "sys_write"
		mov rdi,1							;rdi = 1 (standard output = pantalla)
		mov rsi,cons_info				;rsi = mensaje a imprimir
		mov rdx,cons_tamano_info	;rdx=tamano del string
		syscall								;Llamar al sistema

		;Imprimir el requerimiento
		mov rax,1							;rax = "sys_write"
		mov rdi,1							;rdi = 1 (standard output = pantalla)
		mov rsi,cons_banner				;rsi = mensaje a imprimir
		mov rdx,cons_tamano_banner	;rdx=tamano del string
		syscall								;Llamar al sistema	
		jmp _LIBERAR

_CAPT:

		;Segundo paso: Capturar una tecla presionada en el teclado
		mov rax,0							;rax = "sys_read"
		mov rdi,0							;rdi = 0 (standard input = teclado)
		mov rsi,variable					;rsi = direccion de memoria donde se almacena la tecla capturada 
		mov rdx,1					;rdx=1 (cuantos eventos o teclazos capturar)
		syscall							;Llamar al sistema
		mov r11, [variable]                  ;tecla capturada
		jmp _COMP


_COMP:

		cmp r11,0x31 ;compara con 1 InfoMicro
		je  _INFOMICRO
		cmp r11,0x32 ;compara con 2 cache info
		je  _REAX
		cmp r11,0x33;compara con 3 RAM info
		je  _RAM_info
		cmp r11,0x34;compara con 4 info del SO
		je _First_16b
		cmp r11,0x35;compara con 5 salida
		je _Cores_threads
		cmp r11,0x36
		je _Disco
		cmp r11,0x37
		je  _FINPROGRA
		;HAY QUE HACER UNO QUE ENVIE UN MSJ DE ERROR
		

_LIBERAR:
		mov r10,0x00000000
		mov [variable],r10
		mov rdx,r10
		mov rsi,r10
		jmp _CAPT
	
;---------------INFO DEL MICROPROCESADOR--------------------------------------------------------------------
;-------------------------------------------------------------------------------
;Primera parte: Identificacion del fabricante
				_INFOMICRO:
					impr_texto   limp_terminal,   limp_terminal_tam
					impr_texto  ID,  tam_ID
					impr_linea  SLinea2,cons_nueva_linea2
				 	mov eax,0 ;Cargando EAX=0: Leer la identificacion del fabricante
					cpuid     ;Llamada a CPUID
				;El ID de fabricante se compone de 12 bytes que se almacenan en este orden:
				;          1) Primeros 4 bytes en EBX
				;          2) Siguientes 4 bytes en EDX
				;          3) Ultimos 4 bytes en ECX
				          mov [fabricante_id],ebx
				         mov [fabricante_id+4],edx
				         mov [fabricante_id+8],ecx
				;Ahora se imprime el ID del fabricante usando la macro impr_linea
					impr_texto cons_fabricante,cons_tam_fabricante
				        impr_linea fabricante_id,12
			;-------------------------------------------------------------------------------
							
			;-------------------------------------------------------------------------------
			 	;Segunda parte: Version del procesador
					  mov eax,1
				        cpuid
					;R8 se usa como referencia con el valor precargado. No debe sobre-escribirse
					mov r8,rax
					;Imprimir los encabezados
					impr_texto cons_stepping,cons_tam_stepping
					impr_texto cons_hex_header,cons_tam_hex_header
					;EAX se va a copiar a EDX para poder hacer calculos sin perder los datos de EAX
					mov edx,eax
					;Nos interesa el nibble mas bajo de EDX (Stepping) - Se filtra con una mascara
					and edx,0x000F
					;Se carga la tabla de referencia para imprimir hexadecimales en EBX
					lea ebx,[tabla]
					;Ahora, en AL se carga el nibble que deseamos buscar en la tabla y se hace el lookup
					mov al,dl
			        	xlat
					;El resultado se guarda en "out"
					mov [out],ax
					;Ahora, en un_byte esta el caracter ASCII correspondiente al hexadecimal a imprimir
					impr_linea out,1
					
					;Ahora se pasa a calcular el modelo (Segundo nibble menos significativo)
					;Imprimir los encabezados
					impr_texto cons_modelo,cons_tam_modelo
					impr_texto cons_hex_header,cons_tam_hex_header
					;Se recuperan los valores de CPUID
					mov rax,r8
					mov edx,eax
					;Nos interesa el segundo nibble mas bajo de EDX (Modelo) - Se filtra con una mascara
					;y con un corrimiento (shift) a la derecha por 4 bits
					and edx,0x00F0
					shr edx,4
					;Se carga la tabla de referencia para imprimir hexadecimales en EBX
					lea ebx,[tabla]
					;Ahora, en AL se carga el nibble que deseamos buscar en la tabla y se hace el lookup
					mov al,dl
					xlat
					;El resultado se guarda en "un_byte"
					mov [out],ax
					;Ahora, en un_byte esta el caracter ASCII correspondiente al hexadecimal a imprimir
					impr_linea out,1
					
					;Ahora se pasa a calcular la Familia (Tercer nibble)
					;Imprimir los encabezados
					impr_texto cons_familia,cons_tam_familia
					impr_texto cons_hex_header,cons_tam_hex_header
					;Se recuperan los valores de CPUID
					mov rax,r8
					mov edx,eax
					;Nos interesa el tercer nibble mas bajo de EDX (Modelo) - Se filtra con una mascara
					;y con un corrimiento (shift) a la derecha por 8 bits
					and edx,0x0F00
					shr edx,8
					;Se carga la tabla de referencia para imprimir hexadecimales en EBX
					lea ebx,[tabla]
					;Ahora, en AL se carga el nibble que deseamos buscar en la tabla y se hace el lookup
					mov al,dl
					xlat
					;El resultado se guarda en "un_byte"
					mov [out],ax
					;Ahora, en un_byte esta el caracter ASCII correspondiente al hexadecimal a imprimir
					impr_linea out,1
				
					;Ahora se pasa a calcular el tipo de procesador
					;Imprimir los encabezados
					impr_texto cons_tipo_cpu,cons_tam_tipo_cpu
					impr_texto cons_hex_header,cons_tam_hex_header
					;Se recuperan los valores de CPUID
					mov rax,r8
					mov edx,eax
					;Nos interesa el cuarto nibble mas bajo de EDX (Tipo) - Se filtra con una mascara
					;y con un corrimiento (shift) a la derecha por 12 bits
					and edx,0xF000
					shr edx,12
					;Se carga la tabla de referencia para imprimir hexadecimales en EBX
					lea ebx,[tabla]
					;Ahora, en AL se carga el nibble que deseamos buscar en la tabla y se hace el lookup
					mov al,dl
					xlat
					;El resultado se guarda en "un_byte"
					mov [out],ax
					;Ahora, en un_byte esta el caracter ASCII correspondiente al hexadecimal a imprimir
					impr_linea out,1
					
					;Finalmente, se calcula el modelo extendido del procesador
					;Imprimir los encabezados
					impr_texto cons_modelo_ext,cons_tam_modelo_ext
					impr_texto cons_hex_header,cons_tam_hex_header
					;Se recuperan los valores de CPUID
					mov rax,r8
					;Para poder trabajar el 5to nibble, es necesario hacer un corrimiento a RAX
					;antes de procesarlo con las mascaras en EDX
					shr rax,4
					mov edx,eax
					;Nos interesa el cuarto nibble de EDX (Modelo Ext) - Se filtra con una mascara
					;y con un corrimiento (shift) a la derecha por 12 bits
					and edx,0xF000
					shr edx,12
					;Se carga la tabla de referencia para imprimir hexadecimales en EBX
					lea ebx,[tabla]
					;Ahora, en AL se carga el nibble que deseamos buscar en la tabla y se hace el lookup
					mov al,dl
					xlat
					;El resultado se guarda en "un_byte"
					mov [out],ax	
					;Ahora, en un_byte esta el caracter ASCII correspondiente al hexadecimal a imprimir
					impr_linea out,1
					 jmp  _MSJS2

				
				;-------------------------FIN DE LA INFO----------------------------------------------------------------------------------------------------------
		
		;----------------------------------Extraccion MEM Cache-------------------------------------------------------------------------------------
		
		;----------------------------Etiquetas para comparar el bit 31 de los registros EAX,EBX,ECX Y EDX------------
		_REAX:
			impr_texto   limp_terminal,   limp_terminal_tam
			impr_texto  msj_cache_t,  msj_tam_cache_t
			impr_linea  SLinea2,cons_nueva_linea2
			mov eax,2  ;Se carga a EAX con 2 para extraer la información de la Cache
		     	cpuid            ; Se llama a CPUID
			mov r9,1     ; Registro utilizado para saltar en las diversas etiquetas de comparación
			mov r8,rax ; Referencia para no perder el valor precargado
			mov edx,eax 
			and edx,0xF0000000 ; Máscara para extraer el MSB
			shr edx,31 ;Corrimiento para obtener el bit 31
			cmp edx,0; Compara si es cero, para conocer si nos interesan los descriptores de EAX
			je  _Print_des; Si son iguales entonces pasapos a imprimir 
			jne  _REBX
		
		
		;Nota: La lógica es similar a la usada para extreaer los descriptores del registro EAX
		; Se decide volver a Cargar eax=2 y llamar a CPUID en cada una de estas etiquetas con la finalidad
		;no perder la imformación, además se guardan los datos de EBX,ECX y EDX en EAX con la finalidad
		;de poder emplear el mismo código de Print_des.
		_REBX:
			mov eax,2
		     	cpuid
			mov r9,2
			mov eax,ebx
			mov r8, rax
			mov edx,eax
			and edx,0xF0000000
			shr edx,31
			cmp edx,0
			je  _Print_des
			jne  _RECX
		
		_RECX:
			mov eax,2
		     	cpuid
			mov r9,3
			mov eax,ecx
			mov r8, rax
			mov edx,eax
			and edx,0xF0000000
			shr edx,31
			cmp edx,0
			je  _Print_des
			jne  _REDX
		
		_REDX:
			mov eax,2
		     	cpuid
			mov r9,4
			mov eax,edx
			mov r8, rax
			mov ecx,edx
			and ecx,0xF0000000
			shr ecx,31
			cmp ecx,0
			je  _Print_des
			jne _start

		
		
		;----------------------------------------INICIO De etiqueta para imprimir los descriotores de la Cache--------------------------
		_Print_des:
		
			impr_texto cache_t,tam_cache_t
			mov al,0
			mov rax,r8
			mov edx, eax
			and edx,0xF0000000		;Mascara para utilizar los MSB  
			shr edx,28			;shift de 28 espacios para usar ese byte mas significativos
			lea ebx,[tabla]
			mov al,dl			
			xlat
			mov [out],ax			
			impr_texto out,1
			
		
			mov rax,r8
			mov edx,eax
			and edx,0x0F000000		;Y asi sucesivamente se va de byte en byte   
			shr edx,24
			;lea ebx,[tabla] 
			mov al,dl			
			xlat
			mov [out],ax			
			impr_linea out,1
			
			impr_texto cache_t,tam_cache_t
			mov rax,r8
			mov edx,eax
			and edx,0x00F00000		  
			shr edx,20			
			lea ebx,[tabla]
			mov al,dl			
			xlat
			mov [out],ax			
			impr_texto out,1
			

			mov rax,r8
			mov edx,eax
			and edx,0x000F0000		  
			shr edx,16			
			;lea ebx,[tabla]
			mov al,dl			
			xlat
			mov [out],ax			
			impr_linea out,1
			
			impr_texto cache_t,tam_cache_t
			mov rax,r8
			mov edx,eax
			and edx,0x0000F000		  
			shr edx,12			
			lea ebx,[tabla]
			mov al,dl			
			xlat
			mov [out],ax			
			impr_texto out,1
			

			mov rax,r8
			mov edx,eax
			and edx,0x00000F00		  
			shr edx,8			
			;lea ebx,[tabla]
			mov al,dl			
			xlat
			mov [out],ax			
			impr_linea out,1
			
			
			impr_texto cache_t,tam_cache_t
			mov rax,r8
			mov edx, eax
			and edx,0x000000F0		  
			shr edx,4	
			lea ebx,[tabla]		
			mov al,dl			
			xlat
			mov [out],ax			
			impr_texto out,1
			
			mov rax,r8
			mov edx,eax
			and edx,0x0000000F
			;shr eax,
			lea ebx,[tabla]
			mov al,dl
			xlat
			mov [out],ax
			impr_linea out,1
		
		;------------------------------------------------Saltos a las diversas etiquetas que comparan el bit 31----------------
			cmp r9,1  ;r9 =1: definido en .REAX para poder saltar a .REBX
			je  _REBX
			cmp r9,2 ;r9=2:definido en .REBX para poder saltar a .RECX 
			je  _RECX  
			cmp r9,3;r9=3:definido en .RECX para poder saltar a .REDX 
			je  _REDX
			jne  _MSJS2

		
		
		;-----------------------------------------FIN de etiqueta para la impresión de los descriptores----------------------------
		;-----------------------------------------Inicio para la extracción de informaciñon de la Mem. RAM-----------------
		_RAM_info:
		
			nop
			mov rdi, resultado 
			mov rax,0x63
			syscall
		
		;-----------Extraccion MEM RAM---------------------------------------------------------------------
		
			impr_texto   limp_terminal,   limp_terminal_tam
			impr_texto  MR,  tam_MR
			impr_linea  SLinea2,cons_nueva_linea2
			impr_texto ram_t,tam_ram_t		; imprime encambezado
			mov al,0			;pone a al en 0
			lea ebx,[tabla]			;direcciona los valores de tabla a ebx
			mov edx,[resultado + 0x24]	;busca el segundo registro de memoria total (son ceros asi que con 1 byte basta)
			and edx,0x0000000F		;hmascara para dejar solo los ultimos 4 bits del registro a manipular
			mov al,dl			;pone en el registro AL el valor a buscar en tabla
			xlat
			mov [out],ax			;pone en la direccion de out el valor del numero ASCII respectivo a esos 4 bits (CERO en este caso)
			impr_texto out,1		;imprime el primer simbolo
			
			mov edx,[resultado + 0x20]
			and edx,0xF0000000		;Mascara para utilizar los MSB  
			shr edx,28			;shift de 28 espacios para usar ese byte mas significativos
			mov al,dl			
			xlat
			mov [out],ax			
			impr_texto out,1
			
			mov edx,[resultado + 0x20]
			and edx,0x0F000000		;Y asi sucesivamente se va de byte en byte   
			shr edx,24			;shift de 24 espacios para usar ese byte mas significativos
			mov al,dl			
			xlat
			mov [out],ax			
			impr_texto out,1
			
			mov edx,[resultado + 0x20]
			and edx,0x00F00000		  
			shr edx,20			
			mov al,dl			
			xlat
			mov [out],ax			
			impr_texto out,1
			
			mov edx,[resultado + 0x20]
			and edx,0x000F0000		  
			shr edx,16			
			mov al,dl			
			xlat
			mov [out],ax			
			impr_texto out,1
			
			mov edx,[resultado + 0x20]
			and edx,0x0000F000		  
			shr edx,12			
			mov al,dl			
			xlat
			mov [out],ax			
			impr_texto out,1
			
			mov edx,[resultado + 0x20]
			and edx,0x00000F00		  
			shr edx,8			
			mov al,dl			
			xlat
			mov [out],ax			
			impr_texto out,1
			
			mov edx,[resultado + 0x20]
			and edx,0x000000F0		  
			shr edx,4			
			mov al,dl			
			xlat
			mov [out],ax			
			impr_texto out,1
			
			mov edx,[resultado + 0x20]
			and edx,0x0000000F
			mov al,dl
			xlat
			mov [out],ax
			impr_linea out,1
		
		;----------------Extraccion de la RAM libre----------------------------------------
		
			impr_texto ram_libre,tam_ram_libre		; imprime encambezado
			mov al,0			;pone a al en 0
			lea ebx,[tabla]			;Direcciona todos los valores de tabla al registro ebx
			mov edx,[resultado + 0x2c]	;Busca el segundo Reg de la RAM libre (en este caso son 0s)
			and edx,0x0000000F		;Mascara para trabajar con los LSB
			mov al,dl			                ;Coloca en AL el valor a buscar en tabla
			xlat
			mov [out],ax			;Coloca en la direccion de out el valor del numero ASCII respectivo a esos 4 bits
			impr_texto out,1		;imprime el primer simbolo
			
			mov edx,[resultado + 0x28]	;Direcciona el primer reg de la RAM total
			and edx,0xF0000000		;Mascara para los MSB del Reg, utilizamos logica de la extraccion anterior 
			shr edx,28			                ;Shift de 28 espacios a la derecha para trabajar con ellos
			mov al,dl			                
			xlat
			mov [out],ax			
			impr_texto out,1
			
			mov edx,[resultado + 0x28]	;Direcciona el primer reg de la RAM total
			and edx,0x0F000000		;Mascara para los siguientes 4 bits del Reg, utilizamos logica de la extraccion anterior 
			shr edx,24			               ;mascara para esos respectivos 4 bits, repetimos logica hasta acabar con el reg
			mov al,dl			                
			xlat
			mov [out],ax			
			impr_texto out,1
			
			mov edx,[resultado + 0x28]	
			and edx,0x00F00000		
			shr edx,20			             
			mov al,dl			                
			xlat
			mov [out],ax			
			impr_texto out,1
			
			mov edx,[resultado + 0x28]	
			and edx,0x000F0000		
			shr edx,16			             
			mov al,dl			                
			xlat
			mov [out],ax			
			impr_texto out,1
			
			mov edx,[resultado + 0x28]	
			and edx,0x0000F000		
			shr edx,12			             
			mov al,dl			                
			xlat
			mov [out],ax			
			impr_texto out,1
			
			mov edx,[resultado + 0x28]	
			and edx,0x00000F00		
			shr edx,8			             
			mov al,dl			                
			xlat
			mov [out],ax			
			impr_texto out,1
			
			mov edx,[resultado + 0x28]	
			and edx,0x000000F0		
			shr edx,4			             
			mov al,dl			                
			xlat
			mov [out],ax			
			impr_texto out,1
			
			mov edx,[resultado + 0x28]	
			and edx,0x0000000F			             
			mov al,dl			                
			xlat
			mov [out],ax			
			impr_linea  out,1
			jmp _MSJS2

; ---------------------------------------------Código para la obtención del nombre del procesador-------------------
;El BIOS reserva espacio suficiente para poder concatenar las 3 cadenas de 16 bytes que contienen
;el código ASCII que compone el nombre del procesador.
;----------------------------------------------------------------------------------------------------------------------------------------------------------
_First_16b :
			 impr_texto   limp_terminal,   limp_terminal_tam
			mov eax,80000002h  ;obtiene los primeros 16 bytes
			cpuid				      ; Llamada a CPUID
			mov r9,0                           ; registro para ir sumando 16 bytes y así completar los 48 bytes que componen el nombre del procesador
			mov r10, 1                       ;Para utilizarlo en el comparador de .Concatenar_PN
			jmp _Concatenar_PN; Salto para ir concatenado
			
_Second_16b:                                        ;obtiene los segundos 16 bytes
			mov eax,80000003h
			cpuid
			mov r10,2
			jmp _Concatenar_PN
			
_Third_16b:						 ;obtiene los terceros 16 bytes

		mov eax,80000004h
		cpuid
		mov r10,3
		jmp _Concatenar_PN

_Concatenar_PN:
			mov [Pro_name+r9], eax
			mov [Pro_name+4+r9], ebx
			mov [Pro_name+8+r9], ecx
			mov [Pro_name+12+r9], edx
			add r9,16
			cmp r10,1
			je  _Second_16b
			cmp r10,2
			je _Third_16b
			jne _Imp_PN

_Imp_PN:
	impr_texto PN, tam_PN 
        impr_linea  SLinea2,cons_nueva_linea2 
	impr_texto Pro_name, 48
	impr_linea  SLinea2,cons_nueva_linea2 
	jmp _MSJS2

;-----------------------------------------------------------Cores y Threads-------------------------------------------------------------------

_Cores_threads:
	impr_texto   limp_terminal,   limp_terminal_tam
	impr_texto  CT,  tam_CT
	impr_linea  SLinea2,cons_nueva_linea2
	mov eax,4 ;el CPUID retorna la topologia del procesador core/logica
	mov ebx,0
	mov ecx,0
	mov edx,0
	cpuid 
	mov r13,rax
	
	;Para la topologia de CORES
	impr_texto cores,tam_cores		
	mov rax,r13
	mov edx,eax
	shr edx,26
	and edx,0x000000FF
	_bp:
	add edx,0x1
	_b1:
	lea ebx,[tabla]
	mov al,dl			                
	xlat
	mov [out],ax			
	impr_linea  out,1
	
	;Para los Threads
	mov eax,4 ;el CPUID retorna la topologia del procesador core/logica
	mov ebx,0
	mov ecx,0
	mov edx,0
	cpuid 
	mov edx,eax
	impr_texto threads,tam_threads	
	lea ebx,[tabla]			
	shr edx,14
	and edx,0x00000FFF
	add edx,0x00000001
	mov al,dl			                
	xlat
	mov [out],ax			
	impr_linea  out,1

	
	jmp _MSJS2

;------------------------------------------------------------Info Disco----------------------------------------------------------------------------
_Disco:

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

jmp _MSJS2



;------------------------------------------------------------Sub Menú----------------------------------------------------------------------------


_MSJS2:
		;Imprimir el mensaje con la info
		mov rax,1							;rax = "sys_write"
		mov rdi,1							;rdi = 1 (standard output = pantalla)
		mov rsi,cons_info2			;rsi = mensaje a imprimir
		mov rdx,cons_tamano_info2	;rdx=tamano del string
		syscall								;Llamar al sistema

		;Imprimir el requerimiento
		mov rax,1							;rax = "sys_write"
		mov rdi,1							;rdi = 1 (standard output = pantalla)
		mov rsi,cons_banner				;rsi = mensaje a imprimir
		mov rdx,cons_tamano_banner	;rdx=tamano del string
		syscall								;Llamar al sistema	
		jmp _LIBERAR2

_CAPT2:

		;Segundo paso: Capturar una tecla presionada en el teclado
		mov rax,0							;rax = "sys_read"
		mov rdi,0							;rdi = 0 (standard input = teclado)
		mov rsi,variable					;rsi = direccion de memoria donde se almacena la tecla capturada 
		mov rdx,1					;rdx=1 (cuantos eventos o teclazos capturar)
		syscall							;Llamar al sistema
		mov r11, [variable]                  ;tecla capturada
		jmp _COMP2


_COMP2:

		cmp r11,0x31 ;compara con 1 InfoMicro
		je  _start
		cmp r11,0x32 ;compara con 2 cache info
		je  _FINPROGRA
		;HAY QUE HACER UNO QUE ENVIE UN MSJ DE ERROR
		

_LIBERAR2:
		mov r10,0x00000000
		mov [variable],r10
		mov rdx,r10
		mov rsi,r10
		jmp _CAPT2
	


_FINPROGRA:	
			
	;Sexto paso: Salida del programa
	impr_texto   limp_terminal,   limp_terminal_tam
	impr_texto  cons_info3, cons_tamano_info3
	mov rax,60						;se carga la llamada 60d (sys_exit) en rax
	mov rdi,0							;en rdi se carga un 0
	syscall								;se llama al sistema.
		


		
	

