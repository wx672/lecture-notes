#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main(void)
{
	int i=0;
	FILE *in, *out;
	char *f[4]={"f0","f1","f2","f3"}; /* cat f[012] >> f3 */
	int status=0;
	char str[BUFSIZ];
	pid_t pid;

	memset(str, '\0', sizeof(str));
	
    for(;i<3;i++){
		if( (pid=fork()) == 0 ){ 		/* child */
			printf("PID: %d\n",getpid());
			if( (in=fopen(f[i],"w+")) == NULL ) {
				perror("fopen<in>");
				exit(EXIT_FAILURE);
			}

			printf("Input something into file %s\n", f[i]);
			if( fgets(str,BUFSIZ,stdin)==NULL ){
					perror("fgets");
					exit(EXIT_FAILURE);
				}
			printf("Your input is: %s",str);

			if( !fputs(str, in) ){
					perror("fputs");
					exit(EXIT_FAILURE);
			}
			/* if( fflush(in) != 0 ){ */
			/* 		perror("fflush"); */
			/* 		exit(EXIT_FAILURE); */
			/* } */
			fclose(in);
			printf("Done writing into %s.\n\n", f[i]);
			exit(EXIT_SUCCESS);
		}
		else
			if( waitpid(pid,&status,WUNTRACED) == -1){
				perror("wait");
				exit(EXIT_FAILURE);
			}
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
/* compile-command: "gcc -Wall -Wextra fork-file-sharing.c -o /tmp/a.out" */
/* End: */
