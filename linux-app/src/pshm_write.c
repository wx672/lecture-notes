#include <fcntl.h>
#include <sys/mman.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
  int fd;
  size_t len;                 /* Size of shared memory object */
  char *addr;

  if (argc != 3 || strcmp(argv[1], "--help") == 0){
      printf("%s shm-name string\n", argv[0]);
  }  

  if ( (fd = shm_open(argv[1], O_RDWR | O_CREAT, S_IRUSR | S_IWUSR)) == -1 ){
      perror("shm_open");
  }
  
  len = strlen(argv[2]);
  if (ftruncate(fd, len) == -1){ /* Resize object to hold string */
      perror("ftruncate");
  }
  printf("Resized to %ld bytes\n", (long)len);

  addr = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  if (addr == MAP_FAILED) perror("mmap");

  if (close(fd) == -1) perror("close");

  printf("copying %ld bytes\n", (long) len);
  memcpy(addr, argv[2], len);             /* Copy string to shared memory */
  exit(EXIT_SUCCESS);
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra pshm_write.c -o pshm-write -lrt" */
/* End: */
