#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>

static int glob = 0; 

static void *threadFunc(void *arg) /* loop 'arg' times */
{
  int j;

  for (j = 0; j < *((int *) arg); j++) 
    glob++;						   /* not atomic! */

  return NULL;
}

int main(int argc, char *argv[])
{
  pthread_t t1, t2;
  int loops;

  loops = (argc > 1) ? atoi(argv[1]) : 10000000;
  
  if( pthread_create(&t1, NULL, threadFunc, &loops) != 0 ){
	  perror("pthread_create 1");
  }
  
  if( pthread_create(&t2, NULL, threadFunc, &loops) != 0 ){
    perror("pthread_create 2");
  }
  
  if( pthread_join(t1, NULL) != 0 ){
    perror("pthread_join 1");
  }
  
  if( pthread_join(t2, NULL) != 0 ){
    perror("pthread_join 2");
  }
  
  printf("glob = %d\n", glob);
  exit(EXIT_SUCCESS);
}
