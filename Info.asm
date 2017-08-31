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

section  .data

   
  tabla: db "0123456789ABCDEF",0
  msj_cache_t : db 'Informacion de la memoria cache:  '
  msj_tam_cache_t: equ $-msj_cache_t
  cache_t db 'Cache Total=0x '
  tam_cache_t: equ $-cache_t
  limp_terminal    db 0x1b, "[2J", 0x1b, "[H"  
  limp_terminal_tam equ $ - limp_terminal
  ram_t db 'Memoria RAM total=0x '
  tam_ram_t: equ $-ram_t

  ram_libre db 'Memoria RAM libre=0x '
  tam_ram_libre: equ $-ram_libre

  SLinea db 0xa
  cons_nueva_linea: db 0xa
  
;-------------------------------------------------------------------------------------------------------------------
section  .bss
resultado: resb 56 
out: resb 1 ;Salida en formato ASCII hacia consola

;---------------------------------------------------------------------------------------------------------------------
;Segmento de codigo
section .text
    global _start
;    names	db	'FPU  VME  DE   PSE  TSC  MSR  PAE  MCE  CX8  APIC RESV SEP  MTRR PGE  MCA  CMOV PAT PSE3 PSN  CLFS RESV DS   ACPI MMX FXSR SSE  SSE2 SS   HTT  TM   RESV PBE '

;------------------------------Inicio de codigo-------------------------------------
_start:

;----------------------------------Extraccion MEM Cache-----------------------------------------

;_breakpoint: ;Con gdb puede chequear que aca los registros rax, rbx, rcx y rdx se cargan con datos

;----------------------------Etiquetas para comparar el bit 31 de los registros EAX,EBX,ECX Y EDX------------
.REAX:
	impr_texto   limp_terminal,   limp_terminal_tam
	impr_texto  msj_cache_t,  msj_tam_cache_t
	impr_linea  SLinea,cons_nueva_linea
	mov eax,2  ;Se carga a EAX con 2 para extraer la información de la Cache
     	cpuid            ; Se llama a CPUID
	mov r9,1     ; Registro utilizado para saltar en las diversas etiquetas de comparación
	mov r8,rax ; Referencia para no perder el valor precargado
	mov edx,eax 
	and edx,0xF0000000 ; Máscara para extraer el MSB
	shr edx,31 ;Corrimiento para obtener el bit 31
	cmp edx,0; Compara si es cero, para conocer si nos interesan los descriptores de EAX
	je .Print_des; Si son iguales entonces pasapos a imprimir 
	jne .REBX

;---------------------------------------------------------------------------------------------------------------------------------------------------------
;Nota: La lógica es similar a la usada para extreaer los descriptores del registro EAX
; Se decide volver a Cargar eax=2 y llamar a CPUID en cada una de estas etiquetas con la finalidad
;no perder la imformación, además se guardan los datos de EBX,ECX y EDX en EAX con la finalidad
;de poder emplear el mismo código de Print_des.
.REBX:
	mov eax,2
     	cpuid
	mov r9,2
	mov eax,ebx
	mov r8, rax
	mov edx,eax
	and edx,0xF0000000
	shr edx,31
	cmp edx,0
	je .Print_des
	jne .RECX

.RECX:
	mov eax,2
     	cpuid
	mov r9,3
	mov eax,ecx
	mov r8, rax
	mov edx,eax
	and edx,0xF0000000
	shr edx,31
	cmp edx,0
	je .Print_des
	jne .REDX

.REDX:
	mov eax,2
     	cpuid
	mov r9,4
	mov eax,edx
	mov r8, rax
	mov ecx,edx
	and ecx,0xF0000000
	shr ecx,31
	cmp ecx,0
	je .Print_des
	jne .RAM_info

;_bp:
;----------------------------------------INICIO De etiqueta para imprimir los descriotores de la Cache--------------------------
.Print_des:
;_bp1:
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

;_bp2:
;impr_texto cache_t,tam_cache_t
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

;impr_texto cache_t,tam_cache_t
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

;impr_texto cache_t,tam_cache_t
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
je .REBX
cmp r9,2 ;r9=2:definido en .REBX para poder saltar a .RECX 
je .RECX  
cmp r9,3;r9=3:definido en .RECX para poder saltar a .REDX 
je .REDX
jne .RAM_info


;-----------------------------------------FIN de etiqueta para la impresión de los descriptores----------------------------
;-----------------------------------------Inicio para la extracción de informaciñon de la Mem. RAM-----------------
.RAM_info:

nop
mov rdi, resultado 
mov rax,0x63
syscall

;-----------Extraccion MEM RAM---------------------------------------------------------------------

_breakpoint: ;Con gdb puede chequear que aca los registros rax, rbx, rcx y rdx se cargan con datos

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
jmp .fin



;-----------------------------------------Fin para la extracción de informaciñon de la Mem. RAM-----------------


.fin: ;------Libera el sistema y evita el segment fault-------
mov eax,1
mov ebx,0
int 0x80

