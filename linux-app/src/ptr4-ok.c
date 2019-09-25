#include <stdio.h> 

int inc_count(int count)
{
    return ++count;
} 

int main()
{
    int count = 0; 
   
	count = inc_count(count); 
	printf("%d\n", count); 
    
    return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra ptr4-ok.c -o /tmp/ptr4-ok" */
/* End: */
