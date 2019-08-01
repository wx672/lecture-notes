#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#define NUM_THREADS     5

void *PrintHello(void *threadid)
{
  printf("Hello! It's me, thread #%ld!\n", (long)threadid);
  /* while(1); */
  pthread_exit(NULL);
}

int main (int argc, char *argv[])
{
  pthread_t threads[NUM_THREADS];
  int rc;
  long t;
  for(t=0; t<NUM_THREADS; t++){
    rc = pthread_create(&threads[t], NULL, PrintHello, (void *)t);
    printf("In main: creating thread %ld\n", t);
    if (rc){
      printf("ERROR; return code from pthread_create() is %d\n", rc);
      exit(-1);
    }

    printf("joining thread %ld...",t);
    if(pthread_join(threads[t], NULL)){
      printf("error joining thread.");
      abort();
    }
    printf("done.\n");
  }
  /* while(1); */
   /* sleep(3); */
  return 0;
}
/* Local Variables: */
/* compile-command: "gcc -Wall thread4.c" */
/* End: */
