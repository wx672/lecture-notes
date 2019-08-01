#include<stdio.h>

#define SQR(x) (x * x)
#define N 5

int main(void)
{
    int i = 0;

    for (i = 0; i < N; ++i) {
        printf("x = %d, SQR(x) = %d\n", i+1, SQR(i+1));
    }

    return 0;
}
