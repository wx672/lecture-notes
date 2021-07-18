main: main.c lib.h libhi.so
	gcc -L. -Wl,-rpath=. -Wall -o main main.c -lhi
	# -L         - tells ld where to search libraries
	# -Wl,option - pass option as an option to the linker (ld)
	# -rpath=dir - Add a directory to the runtime library search path
libhi.so: hi.o hello.o
	gcc -shared -o libhi.so hi.o hello.o
hi.o: hi.c
	gcc -fPIC -c hi.c
hello.o: hello.c
	gcc -fPIC -c hello.c
clean:
	rm -f *.o *.so main

# http://www.cprogramming.com/tutorial/shared-libraries-linux-gcc.html
# http://tldp.org/HOWTO/Program-Library-HOWTO/shared-libraries.html
# https://stackoverflow.com/questions/5311515/gcc-fpic-option
