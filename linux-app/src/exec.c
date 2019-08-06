#include <unistd.h>


/* Possible calls to exec functions */
execl("/bin/ps", "ps", "ax", 0); /* assumes ps is in /bin */
execlp("ps", "ps", "ax", 0);     /* assumes /bin is in PATH */

/* Note that we need a program name for argv[0] */
char *const ps_argv[] =	{"ps", "ax", 0};
execv("/bin/ps", ps_argv);
execvp("ps", ps_argv);

char *const ps_envp[] =	{"PATH=/bin:/usr/bin", "TERM=xterm", 0};
execle("/bin/ps", "ps", "ax", 0, ps_envp); /* passes own environment */
execve("/bin/ps", ps_argv, ps_envp);


