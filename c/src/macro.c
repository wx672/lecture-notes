#include <stdio.h>
#define SQR(x) (x * x)
int main()
{
    int counter;    /* counter for loop */
    for (counter = 0; counter < 5; ++counter)
    {
        printf("x %d, x squared %d\n",
            counter+1, SQR(counter+1));
    }
    return (0);
}
