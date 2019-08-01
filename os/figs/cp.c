#include <sys/types.h>   /* include necessary header files */
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>

#define BUF_SIZE 4096    /* use a buffer size of 4096 bytes */
#define OUTPUT_MODE 0700 /* protection bits for output file */

int main(int argc, char *argv[])
{
  int in, out, rbytes, wbytes;
  char buf[BUF_SIZE];

  if (argc != 3) exit(1); 

  if ( (in = open(argv[1], O_RDONLY)) < 0 ) exit(2); /* open source file */

  if ( (out = creat(argv[2], OUTPUT_MODE)) < 0 ) exit(3); /* create destination file */

  while (1) { /* Copy loop */
    if ( (rbytes = read(in, buf, BUF_SIZE)) <= 0 ) break;   /* read a block of data */
    if ( (wbytes = write(out, buf, rbytes)) <= 0 ) exit(4); /* write data */
  }

  close(in);
  close(out);
  if (rbytes == 0) exit(0); /* no error on last read */
  else exit(5);             /* error on last read */
}
