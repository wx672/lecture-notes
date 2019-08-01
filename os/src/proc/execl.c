/*
  https://unix.stackexchange.com/questions/315812/why-does-argv-include-the-program-name
  https://stackoverflow.com/questions/2050961/is-argv0-name-of-executable-an-accepted-standard-or-just-a-common-conventi
  https://unix.stackexchange.com/questions/187666/why-do-we-have-to-pass-the-file-name-twice-in-exec-functions/187673#187673
*/

#include <stdio.h> 
#include <unistd.h> 

int main () 
{
	printf("pid=%d\n", getpid());	/* for watch */
	/* sleep(10); 					/\* for watch *\/ */
	printf("Calling execl...\n");
	
	/* replace a.out (generated from this c file) with /bin/cat. */
	/* execl("/bin/cat", "cat", "./execl.c", NULL); */

	/* argv[0] is not necessarily the program name. For instance,*/
	/* execl("/bin/xz", "xzcat", "somefile.xz", NULL); */
	/* execl("/bin/xz", "xz", "--decompress", "--stdout", "somefile.xz", NULL); */
	/* execl("/bin/busybox", "ls", (char *)0); */
	/* execl("/bin/busybox", "cp", "execl.c", "/tmp/execl.c", (char *)0); */
	/* execl("/bin/ls","",(char *)0);					   /\* argv[0] could be NULL *\/ */
	/* execl("/bin/busybox", "", (char *)0); /\* applet not found *\/ */
	/* execl("/bin/sleep", "sleeeeep","3", (char *)NULL); /\* watch -n.1 'ps -o comm= -q PID' */
	/* 													  to see sleeeeep, do: */
	/* 													  watch -n.1 'ps aux | grep sle' *\/ */

	execl("/var/tmp/mybackdoor", "top", NULL);
	
	printf("Useless call to printf.\n"); /* since execl() doesn't return on success */
	return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall execl.c" */
/* End: */
