        ; https://www.devdungeon.com/content/hello-world-nasm-assembler
        ; Compile: nasm -f elf hello32.asm -o hello.o
        ;    Link: ld hello.o -o hello -m elf_i386
        ;     Run: ./hello
        ;
        ; strace issue:
		; https://github.com/strace/strace/issues/103 (need kernel 5.3+)
		; https://stackoverflow.com/questions/57850588/confused-by-strace-output-of-a-simple-helloworld-nasm-program/57884132#57884132
        ;
        
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
