/* https://stackoverflow.com/questions/12687274/size-of-stack-and-heap-memory */
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

void check(int depth,char a) {
    char b[1024*1024];
    char *ptr = malloc(1);
    printf("heap at %p\n", ptr);
	printf("&b: %p\n", &b);
    printf("&depth: %p, depth: %d\n", &depth,depth);
	printf("&a: %p\n\n", &a);
    if (depth <= 0) return;
    check(depth-1,a);
}

int main() {
	printf("&main: %p\n", &main);
	printf("&check: %p\n\n", &check);
    check(3,'a');
	getchar();
    return 0;
}
