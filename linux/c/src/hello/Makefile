c: hello.c
	gcc -Wall -o hello hello.c
cpp: hello.cpp
	g++ -Wall -o hello++ hello.cpp
curses: hello-curses.c
	gcc -Wall -o hello-curses hello-curses.c -lcurses
gtk2: hello-gtk.c
	gcc -Wall hello-gtk.c -o hello-gtk2 `pkg-config --cflags gtk+-2.0` `pkg-config --libs gtk+-2.0`
gtk3: hello-gtk.c
	gcc -Wall hello-gtk.c -o hello-gtk3 `pkg-config --cflags gtk+-3.0` `pkg-config --libs gtk+-3.0`
php: hello.php
	php hello.php
python: hello.py
	python hello.py

clean:
	rm -f *.o *.s *.i hello hello++ hello-curses hello-gtk?
