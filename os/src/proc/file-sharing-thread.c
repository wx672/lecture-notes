#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>

void *writefile(void *arg)
{
	FILE *in;
	char str[BUFSIZ];

	memset(str, '\0', sizeof(str));
	
	if( (in=fopen((char *)arg,"w+")) == NULL ) {
		perror("fopen<in>");
		exit(EXIT_FAILURE);
	}

	printf("Input something into file %s\n", (char *)arg);

	if( fgets(str,BUFSIZ,stdin)==NULL ){
		perror("fgets");
		exit(EXIT_FAILURE);
	}

	printf("Your input is: %s",str);

	if( !fputs(str, in) ){
		perror("fputs");
		exit(EXIT_FAILURE);
	}

	fclose(in);

	printf("Done writing into %s.\n\n", (char *)arg);

	pthread_exit(NULL);
}

int main(void)
{
	int i=0, status;
	FILE *in, *out;
	char *f[4]={"f0","f1","f2","f3"}; /* cat f[012] >> f3 */
	pthread_t t[3];
	char str[BUFSIZ];

	memset(str, '\0', sizeof(str));
  
	for (; i<3; i++){
		printf("Main: creating thread %d... ", i);

		if( (status = pthread_create(&t[i], NULL, writefile, (void *)f[i])) ){
			perror("pthread_create");
			exit(-1);
		}
		puts("Done.");

		/* Joining current thread before starting another so that the STDIN won't be
		   raced by multiple threads. */
		printf("Joining thread %d... ", i);

		if( pthread_join(t[i], NULL) ){
			perror("pthread_join");
			abort() ;
		}
		puts("Done.");
	}

	/* parent */
	if( (out=fopen(f[3], "a+")) == NULL ) {
		perror("fopen<out>");
		exit(EXIT_FAILURE);
	}

	for(i=0;i<3;i++){
		if( (in=fopen(f[i],"r")) == NULL ) {
			perror("fopen<out>");
			exit(EXIT_FAILURE);
		}

		if( fgets(str,BUFSIZ,in) == NULL ){
			perror("fgets");
			exit(EXIT_FAILURE);
		}

		if( fputs(str, out) < 0 ){
			perror("fputs");
			exit(EXIT_FAILURE);
		}

		fclose(in);
	}

	if( fseek(out,0L,SEEK_END) !=0 ){
		perror("fseek");
		exit(EXIT_FAILURE);
	}

	printf("The size of %s is %ld.\n", f[3], ftell(out));	

	fclose(out);
	return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra file-sharing-thread.c -o /tmp/a.out -pthread" */
/* End: */
