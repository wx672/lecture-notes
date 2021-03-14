triple: triple.o add3.o
	gcc $(CFLAGS) -Wall triple.o add3.o -o triple

triple.o: triple.c add.h
	gcc $(CFLAGS) -Wall -c triple.c

add3.o: add3.c add.h
	gcc $(CFLAGS) -Wall -c add3.c

clean:
	rm -f triple *.o
