#include <stdio.h>
#include <unistd.h>

int main(int argc, char* argv[]) {
  int opt;

  while ((opt = getopt(argc, argv, "hf:l")) != -1) {
    switch (opt) {
    case 'h':
      printf("Usage: %s [-h] [-f file] [-l]\n", argv[0]);
      break;
    case 'l':
      printf("option: %c\n", opt);
      break;
    case 'f':
      printf("filename: %s\n", optarg);
      break;
    }
  }
  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra getopt.c -o getopt" */
/* End: */
