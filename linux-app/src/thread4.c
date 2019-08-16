#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <semaphore.h>

void *func(void *arg);
pthread_mutex_t mt;

#define BUFSIZE 1024
char buf[BUFSIZE];
int stopit = 0;

int main() {
    pthread_t t;
    
    if ( pthread_mutex_init(&mt, NULL) != 0 ) {
        perror("Mutex initialization failed");
        exit(EXIT_FAILURE);
    }

    if ( pthread_create(&t, NULL, func, NULL) != 0) {
        perror("Thread creation failed");
        exit(EXIT_FAILURE);
    }

    /* pthread_mutex_lock(&mt);	/\* compete with thread *\/ */

	puts("Input some text. Enter 'end' to finish\n");

    while(!stopit){		
		fgets(buf, BUFSIZE, stdin);

		/* pthread_mutex_unlock(&mt); */
		while(1) {
			/* pthread_mutex_lock(&mt); */
			if( buf[0] != '\0' ) {
				/* pthread_mutex_unlock(&mt); */
				puts("sleeping...");
				sleep(1);
			} else break;
		}
	}
    /* pthread_mutex_unlock(&mt); */
    puts("Waiting for thread to finish...");
    
    if( pthread_join(t, NULL) != 0 ) {
        perror("Thread join failed");
        exit(EXIT_FAILURE);
    }

    puts("Thread joined.");
    pthread_mutex_destroy(&mt);
    exit(EXIT_SUCCESS);
}

void *func(void *arg) {
    /* pthread_mutex_lock(&mt); */
	puts("t: working...");
	while( buf[0] != '\0' ) {
        printf("You input %ld characters.\n", strlen(buf)-1);
        buf[0] = '\0';
        /* pthread_mutex_unlock(&mt); */
        /* sleep(1); */
        /* pthread_mutex_lock(&mt); */
        while (buf[0] == '\0' ) {
            /* pthread_mutex_unlock(&mt); */
            sleep(1);
            /* pthread_mutex_lock(&mt); */
        }
    }
	puts("ending...");
    stopit = 1;
    buf[0] = '\0';
    /* pthread_mutex_unlock(&mt); */
    pthread_exit(0);
}
