#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
  int fd, i;
  for (i = 0; i < 5; ++i)
    {
      if ((fd = open("open.c", O_RDONLY)) < 0) exit(2);
      printf("fd is %d\n", fd);
    }
  sleep(60);
  return 0;
}
