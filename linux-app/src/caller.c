#include <unistd.h>

int main(void) {
  char *argv[] = {NULL};
  char *envp[] = {NULL};
  execve("callee.out", argv, envp);
}
