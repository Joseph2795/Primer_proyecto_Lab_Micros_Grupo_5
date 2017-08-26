section  .data
section  .bss
resultado: resb 50   
section .text
global _start
 _start:
nop
mov rdi, resultado 
mov rax,0x63
syscall
_breakpoint: ;Con gdb puede chequear que aca los registros rax, rbx, rcx y rdx se cargan con datos
mov rdx, [resultado+0x20] ;apunta a la direccion resultado + 0x20, toma lo que hay dentro y en el registro rdx guarda la cantidad total de memoria RAM
mov rbx, [resultado+0x24]
_breakpoint2: ;aca puede revisar cuando los registros rdx y rbx tienen la info almacenada

_breakpoint3:
;------Libera el sistema y evita el segment fault-------
mov eax,1
 mov ebx,0
  int 0x80  





