		; https://www.devdungeon.com/content/hello-world-nasm-assembler
		; Compile: nasm -f elf64 hello.asm -o hello.o
		;    Link: ld hello.o -o hello
		;     Run: ./hello

		; Define variables in the data section
SECTION .DATA
Msg:     db 'Hello, world!',10 	; 10 = ascii for LF
MsgLen:  equ $-Msg

		; Code goes in the text section
SECTION .TEXT
GLOBAL _start 

_start:
		mov eax,4      ; 'write' system call = 4
		mov ebx,1      ; file descriptor 1 = STDOUT
		mov ecx,Msg    ; string to write
		mov edx,MsgLen ; length of string to write
		int 80h        ; call the kernel

		; Terminate program
		mov eax,1  ; 'exit' system call
		mov ebx,0  ; exit with error code 0
		int 80h    ; call the kernel

