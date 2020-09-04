#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

#define NSIZE   (4*(1<<10)) /* 4*(2^10) = 4k */
#define SLEEPT  3600

long  gx[NSIZE]; /* uninitialized global variable should be in BSS */

int main (void)
{
	char c[NSIZE]; /* local variable should be in stack */
	int *px = malloc (NSIZE*sizeof(int)); /* run-time allocated space should be in heap */
	int i;
	
	for (i=0; i<NSIZE; i++)
		{
			gx[i] = (long)i;
			px[i] = i;
			c[i]  = 'c';
		}
  
	printf ("address of gx[0] = %p\t# uninitialized global variable in BSS\n", &gx[0]);
	printf ("address of px[0] = %p\t# malloc local variable in heap\n", &px[0]);
	printf ("address of  c[0] = %p\t# local variable in stack\n", &c[0]);

	printf ("memory map file: /proc/%d/maps\n", getpid());
	printf ("sleeping %d...", SLEEPT);
	fflush (NULL);

	sleep (SLEEPT);

	free (px);

	exit (EXIT_SUCCESS);
}

/* Local Variables: */
/* compile-command: "gcc -Wall map.c -o map" */
/* from: "http://www.ualberta.ca/CNS/RESEARCH/LinuxClusters/mem.html" */
/* End: */
