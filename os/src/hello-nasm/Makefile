x86: hello32.o
	ld hello32.o -o hello32 -m elf_i386
hello32.o: hello32.asm
	nasm -f elf hello32.asm -o hello32.o

x64: hello64.o
	ld -o hello64 hello64.o
hello64.o: hello64.s
	nasm -f elf64 -o hello64.o hello64.s

clean:
	rm *.o hello32 hello64
