#include <stdio.h>

void inc_count(int *count_ptr)
{
    ++(*count_ptr);
} 

int main()
{
    int count = 0; 
   
	inc_count(&count); 
	printf("%d\n", count);
    
    return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra ptr4.c -o /tmp/ptr4" */
/* End: */
