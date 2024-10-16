#include <semaphore.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

static int glob = 0;
static sem_t sem;

static void *threadFunc(void *arg)
{
  int j;

  for (j = 0; j < *((int *) arg); j++) {
    if (sem_wait(&sem) == -1){
      perror("sem_wait");
    }
    glob++;
    if (sem_post(&sem) == -1){
      perror("sem_post");
    }
  }

  return NULL;
}

int main(int argc, char *argv[])
{
  pthread_t t1, t2;
  int loops;

  loops = (argc > 1) ? atoi(argv[1]) : 10000000;

  if( sem_init(&sem, 0, 1) == -1 ){
      perror("sem_init");
  }
  
  if( pthread_create(&t1, NULL, threadFunc, &loops) != 0 ){
     perror("pthread_create");
  }
  
  if( pthread_create(&t2, NULL, threadFunc, &loops) != 0 ){
     perror("pthread_create");
  }
  
  if( pthread_join(t1, NULL) != 0 ){
     perror("pthread_join");
  }
  
  if( pthread_join(t2, NULL) != 0 ){
      perror("pthread_join");
  }
  
  printf("glob = %d\n", glob);
  exit(EXIT_SUCCESS);
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra mutex.c -o /tmp/mutex -pthread" */
/* End: */
