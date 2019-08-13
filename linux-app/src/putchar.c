#include <stdio.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    char c;
	while (read(0,&c,1) == 1) putchar(c);
    return 0;
}
