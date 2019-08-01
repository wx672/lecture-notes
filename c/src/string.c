/* https://stackoverflow.com/questions/17077505/string-pointer-and-array-of-chars-in-c

   When you declare an array, however, you aren't declaring a pointer at all. You're
   reserving a certain amount of memory and giving it a name.
 */
#include<stdio.h>

#define MAX 10

int main(void)
{
	char name[] = "Apple";
	char name2[6] ={'A','p','p','l','e','\0'};
	char *name3 = "Apple";
	char name4[MAX];
	name4 = "Apple"; 			/* Wrong! */
	int i;
	
	for (i = 0; i < MAX; ++i) {
		printf("&name[%d]: %p; name[%d]: %c\n", i, &name[i], i, name[i]);		
	}

    return 0;
}

