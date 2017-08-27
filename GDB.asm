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
_bp1:
mov eax,1
mov ebx,0
int 0x80
;****************************************