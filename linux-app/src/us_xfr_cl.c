#include <sys/un.h>
#include <sys/socket.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define SV_SOCK_PATH "/tmp/us_xfr"
#define BUF_SIZE 100

int main(void)
{
  struct sockaddr_un addr;
  int sfd;
  ssize_t numRead;
  char buf[BUF_SIZE];
  
  if( (sfd = socket(AF_UNIX, SOCK_STREAM, 0)) == -1 ){
      perror("socket");
      exit(EXIT_FAILURE);
  }

  memset(&addr, 0, sizeof(struct sockaddr_un));
  addr.sun_family = AF_UNIX;
  strncpy(addr.sun_path, SV_SOCK_PATH, sizeof(addr.sun_path) - 1);

  if (connect(sfd, (struct sockaddr *) &addr, sizeof(struct sockaddr_un)) == -1){
      perror("connect");
		exit(EXIT_FAILURE);
  }

  while ((numRead = read(STDIN_FILENO, buf, BUF_SIZE)) > 0)
      if (write(sfd, buf, numRead) != numRead){
          perror("partial/failed write");
			exit(EXIT_FAILURE);
		}
	
  if (numRead == -1){
      perror("read");
		exit(EXIT_FAILURE);
  }

  exit(EXIT_SUCCESS); /* Closes our socket; server sees EOF */
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra us_xfr_cl.c -o /tmp/us-xfr-cl" */
/* End: */
