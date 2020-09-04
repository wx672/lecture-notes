#include <sys/types.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>

#define BUF_SIZE 4096
#define OUTPUT_MODE 0700

int main(int argc, char *argv[])
{
  int in, out, rbytes;
  char buf[BUF_SIZE];

  if (argc != 3) {
	  perror(argv[0]);
	  exit(errno);
  }

  if ( (in = open(argv[1], O_RDONLY)) < 0 ) {
	  perror("open");
	  exit(errno);
  }

  if ( (out = creat(argv[2], OUTPUT_MODE)) < 0 ){
	  perror("creat");
	  exit(errno);
  }

  while (1) { /* Copy loop */
	if ( (rbytes = read(in, buf, BUF_SIZE)) <= 0 ) {
	  perror("read");
	  break;
	}
    if ( write(out, buf, rbytes) <= 0 ){
	  perror("write");
	  exit(errno);
	}
  }

  close(in); close(out);

  exit (rbytes == 0 ? EXIT_SUCCESS : errno);
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra cp-syscall.c -o /tmp/cp-syscall" */
/* End: */
