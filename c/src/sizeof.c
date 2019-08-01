#include <stdio.h>
#include <limits.h>

int main(void)
{
    printf("Size of char: %ld\n", sizeof(char));
    printf("Size of int: %ld\n", sizeof(int));
    printf("Size of float: %ld\n", sizeof(float));
    printf("Size of double: %ld\n", sizeof(double));
    printf("short int: %ld\n", sizeof(short int));
    printf("long int: %ld\n", sizeof(long int));
    printf("unsigned long: %ld\n", sizeof(unsigned long int));
    printf("long long: %ld\n", sizeof(long long int));
    printf("unsigned long long: %ld\n", sizeof(unsigned long long int));
    return 0;
}
