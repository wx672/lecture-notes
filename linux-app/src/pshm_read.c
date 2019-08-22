#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
  int fd;
  char *addr;
  struct stat sb;

  if (argc != 2 || strcmp(argv[1], "--help") == 0){
    printf("%s shm-name\n", argv[0]);
  }
    
  if ( (fd = shm_open(argv[1], O_RDONLY, 0)) == -1 ){ 
    perror("shm_open");
  }
  
  if (fstat(fd, &sb) == -1) perror("fstat"); /* Get object size */

  addr = mmap(NULL, sb.st_size, PROT_READ, MAP_SHARED, fd, 0);
  if (addr == MAP_FAILED) perror("mmap");

  if (close(fd) == -1) perror("close");

  write(STDOUT_FILENO, addr, sb.st_size);
  printf("\n");
  exit(EXIT_SUCCESS);
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra pshm_read.c -o pshm-read -lrt" */
/* End: */
