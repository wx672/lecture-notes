#include <unistd.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
  /* link(argv[1], argv[2]); */
  /* symlink(argv[1], argv[2]); */
  unlink(argv[1]);
  perror(argv[0]);
  return 0;
}

