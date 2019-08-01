#include<stdio.h>
#include<stdlib.h>

#define DIE \
    printf("Fatal Error! Abort\n"); exit(8);

int main(void)
{
    int i = 1;
    if (i<0) DIE
    printf("Still alive!\n");
    return 0;
}
