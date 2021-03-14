main: main.c lib.h libhi.a
	gcc -Wall -o main main.c libhi.a

libhi.a: hello.o hi.o
	ar crv libhi.a hello.o hi.o

hello.o: hello.c
	gcc -Wall -c hello.c

hi.o: hi.c
	gcc -Wall -c hi.c

clean:
	rm -f *.o *.a main
