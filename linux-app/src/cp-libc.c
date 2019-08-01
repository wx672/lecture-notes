#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	FILE *in, *out;	
	int c=0;

	if (argc != 3) exit(1); 

	in = fopen(argv[1], "r");
	out = fopen(argv[2], "w");

	while ( (c = fgetc(in)) != EOF )
		fputc(c, out);

	return 0;
}
