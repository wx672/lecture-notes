#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <semaphore.h>

void *func(void *arg);
sem_t sem;

#define BUFSIZE 1024
char buf[BUFSIZE];

int main() {
  pthread_t t;

  if( sem_init(&sem, 0, 0) != 0 ) {
    perror("Semaphore initialization failed");
    exit(EXIT_FAILURE);
  }

  if( pthread_create(&t, NULL, func, NULL) != 0 ) {
    perror("Thread creation failed");
    exit(EXIT_FAILURE);
  }

  puts("Please input some text. Ctrl-d to quit.");

  while( fgets(buf, BUFSIZE, stdin) )
	sem_post(&sem); 

  sem_post(&sem); 				/* in case of Ctrl-d */
  
  if( pthread_join(t, NULL) != 0) {
    perror("Thread join failed");
    exit(EXIT_FAILURE);
  }

  sem_destroy(&sem);

  exit(EXIT_SUCCESS);
}

void *func(void *arg) {
  sem_wait(&sem);
  while( buf[0] != '\0' ) {
    printf("You input %ld characters\n", strlen(buf)-1);
	buf[0] = '\0';				/* in case of Ctrl-d */
    sem_wait(&sem);
  }
  pthread_exit(NULL);
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra thread3.c -o /tmp/thread3 -pthread" */
/* End: */
