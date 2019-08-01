/*
** sigint.c -- grabs SIGINT
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <signal.h>

void sigint_handler(int sig)
{
	write(0, "Ahhh! SIGINT!\n", 14);
}

int main(void)
{
	void sigint_handler(int sig); /* prototype */
	char s[200];
	struct sigaction sa;

	sa.sa_handler = sigint_handler;
	sa.sa_flags = 0; // or SA_RESTART
	sigemptyset(&sa.sa_mask);

	if (sigaction(SIGINT, &sa, NULL) == -1) {
		perror("sigaction");
		exit(1);
	}

	printf("Enter a string:\n");

	if (fgets(s, sizeof s, stdin) == NULL)
		perror("fgets");
	else 
		printf("You entered: %s\n", s);

	return 0;
}

