#include<stdio.h>
int main(void)
{
    int a = 0, sum = 0, na=0;
    while (1) {
        printf("Enter # to add or 0 to stop: \n");
        scanf("%d", &a);

        if (a==0) break;

        if (a<0) {
            na++;
            continue;
        }
        
        sum += a;
        printf("Total: %d\n", sum);
    }
    printf("Final total %d ", sum);
    printf("with %d negative items omitted.\n", na);
    return 0;
}
