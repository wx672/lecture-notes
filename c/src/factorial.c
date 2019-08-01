#include<stdio.h>
#include<stdlib.h>

/* https://en.wikipedia.org/wiki/C_data_types */

unsigned long long factorial(int n){
	if (n==0) return 1;
	return n*factorial(n-1);
}

int main(int argc, char *argv[argc])
{
    if (argc != 2){
		printf("Usage: %s <number>\n",argv[0]);
		return -1;
	}
	
	int n = atoi(argv[1]);
	printf("%d! = %llu\n", n, factorial(n));
	return 0;
}
