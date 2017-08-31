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
  cache_t db 'Cache Total=0x '
  tam_cache_t: equ $-cache_t

  SLinea db 0xA
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
	jne .fin

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
jne .fin 


;-----------------------------------------FIN de etiqueta para la impresión de los descriptores----------------------------

.fin: ;------Libera el sistema y evita el segment fault-------
mov eax,1
mov ebx,0
int 0x80
