#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define NUMBER_OF_THREADS 5

void *print_hello_world(void *tid)
{
	printf ("Hello from thread %ld\n", (long)tid);
	/* sleep(10); */
	pthread_exit(NULL);
}

int main(int argc, char *argv[])
{
	pthread_t threads[NUMBER_OF_THREADS];
	int status;
	long i;
	for (i=0; i<NUMBER_OF_THREADS; i++)
		{
			printf ("Main: creating thread %ld ...",i);

			if((status = pthread_create(&threads[i], NULL, print_hello_world, (void *)i))){
				printf ("Oops. pthread_create returned error code %d\n",status);
				exit(-1);
			}
			printf("done.\n");

		}
	for (i=0; i<NUMBER_OF_THREADS; i++)
		{
			printf("Joining thread %ld ...",i);
  
			if(pthread_join(threads[i], NULL)){
				printf("error joining thread.");
				abort() ;
			}
			printf("done.\n");
		}
	exit(0);
}
/* Local Variables: */
/* compile-command: "gcc -Wall thread3.c" */
/* End: */
