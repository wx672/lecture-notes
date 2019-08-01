#include<stdio.h>

int main(void)
{
    int i=1;
	i = (i++ * 5) + (i++ * 3);
	printf("i++ + i++ = %d\n", i);
    return i;
}
