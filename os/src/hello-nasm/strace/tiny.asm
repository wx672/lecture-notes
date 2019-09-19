        ; Compile: nasm -f elf tiny.asm -o tiny.o
        ;    Link: ld tiny.o -o tiny -m elf_i386
        ;     Run: ./tiny
		;  strace: strace ./tiny
BITS 64
  GLOBAL _start
  SECTION .text
  _start:
                mov     eax, 1
                mov     ebx, 42  
                int     0x80
