#include<stdio.h>

int main(void)
{
    int *p = 5; /* should be (int *)5 */

    printf(" p = %p\n",  p); /*  p = 0x5 */
    printf("&p = %p\n", &p); /* &p = 0x7ffda48a2068 */
    printf("*p = %c\n", *p); /* Invalid memory access */
    return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra ptr2-wrong2.c -o /tmp/a.out" */
/* End: */
