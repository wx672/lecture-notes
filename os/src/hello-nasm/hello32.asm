        ; https://www.devdungeon.com/content/hello-world-nasm-assembler
        ; Compile: nasm -f elf64 hello.asm -o hello.o
        ;    Link: ld hello.o -o hello
        ;     Run: ./hello
        ;
        ; strace issue: https://github.com/strace/strace/issues/103
        ; (need kernel 5.3+)
        
SECTION .DATA
Msg:     db 'Hello, world!',10  ; 10 = ascii for LF
MsgLen:  equ $-Msg
        
SECTION .TEXT
GLOBAL _start 

_start:
        mov eax, 4       ; write(
        mov ebx, 1       ;   STDOUT_FILENO,
        mov ecx, Msg     ;   "Hello, world!\n",
        mov edx, MsgLen  ;   sizeof("Hello, world!\n")
        int 80h          ; );

        mov eax, 1       ; exit(
        mov ebx, 0       ;   EXIT_SUCCESS
        int 80h          ; );
