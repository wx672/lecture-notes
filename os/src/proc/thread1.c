#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

void *hello(void *arg)
{
  int i;
  for( i=0; i<20; i++ ){
	puts("Thread says hi!");
    sleep(1);
  }
  return NULL;
}

int main(void)
{
  pthread_t t;
  if( pthread_create(&t, NULL, hello, NULL) ){
    perror("error creating thread.");
    abort();
  }

  if( pthread_join(t, NULL) ){
    perror("error joining thread.");
    abort();
  }
  exit(0);
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra thread1.c -pthread -o /tmp/a.out" */
/* End: */
