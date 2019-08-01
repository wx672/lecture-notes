/*
 * http://www.ualberta.ca/CNS/RESEARCH/LinuxClusters/mem.html
 *
 * gcc -std=c99 -Wall map.c -o map
 */
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

#define NSIZE   (5*(1<<10)) /* 5*(2^10) = 5k */
#define SLEEPT  3600

long  gx[NSIZE]; /* uninitialized global variable should be in BSS */

int
main (int argc, char *argv[])
{
  char  c[NSIZE]; /* local variable should be in stack */
  int  *px = malloc (NSIZE*sizeof(int)); /* run-time allocated space should be in heap */

  for (int i=0; i<NSIZE; i++) {
    gx[i] = (long)i;
    px[i] = i;
    c[i]  = 'c';
  }
  printf ("uninitialized global in BSS:\t address of gx[0] = %012p\n", &gx[0]);
  printf ("malloc local varialbe in heap:\t address of px[0] = %012p\n", &px[0]);
  printf ("local variable in stack:\t address of  c[0] = %012p\n", &c[0]);

  printf ("memory map file: /proc/%d/maps\n", getpid());
  printf ("sleeping %d...", SLEEPT);
  fflush (NULL);
  sleep (SLEEPT);

  free (px);

  printf ("\ndone\n");
  exit (EXIT_SUCCESS);
}
