#include<stdio.h>
int main(void)
{
    int a = 0;
    while( a < 10 ){
        printf("a=%d\n", a);
        a++;
        if (a>5) break;
    }   
    return 0;
}
