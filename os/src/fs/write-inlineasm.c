/* Calling sys_write using inline assembly code */
/* https://jameshfisher.com/2018/02/20/c-inline-assembly-hello-world/ */
int main(void) {
  register char* arg2 asm("rsi") = "hello, world!\n";

  /* rax: sys_write; rdi: STDOUT; */
  asm("mov $1, %rax; mov $1, %rdi; mov $14, %rdx; syscall;");

  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall write-inlineasm.c -o /tmp/a.out" */
/* End: */
