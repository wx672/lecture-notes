#include <stdio.h> 
#include <unistd.h> 

int main () 
{
	printf("pid=%d\n", getpid());	/* for watch */
	// sleep(10); 					/* for watch */
	printf("Calling execl...\n");
	
	/*
	 * replace a.out (generated from this c file) with /bin/cat.
	 */
	//	execl("/bin/cat", "cat", "./execl.c", NULL);
  
	/*
	 * argv[0] is not necessarily the program name. For instance,
	 */
	// execlp("xz", "xzcat", "/tmp/hello.xz", NULL);
	// execlp("xz", "xz", "--decompress", "--stdout", "/tmp/hello.xz", NULL);
	// execl("/bin/busybox", "ls", (char *)0);
	// execl("/bin/busybox", "cp", "execl.c", "/tmp/execl.c", (char *)0);
	// execl("/bin/ls","",(char *)0);        /* argv[0] could be NULL */
	// execl("/bin/busybox", "", (char *)0); /* applet not found */

	/* watch -n.1 'ps -o comm= -q PID' */
	/* to see sleeeeep, do: watch -n.1 'ps aux | grep sleeeeep' */
	execl("/bin/sleep", "sleeeeep","30", (char *)NULL); 	

	//	execl("/var/tmp/mybackdoor", "top", NULL);

	/* execl() doesn't return on success */	 
	printf("Useless call to printf.\n");
	 
	return 0;
}

/* Local Variables: */
/* compile-command: "gcc -Wall execl.c" -o /tmp/a.out */
/* ref: https://unix.stackexchange.com/questions/315812/why-does-argv-include-the-program-name */
/* ref: https://stackoverflow.com/questions/2050961/is-argv0-name-of-executable-an-accepted-standard-or-just-a-common-conventi */
/* ref: https://unix.stackexchange.com/questions/187666/why-do-we-have-to-pass-the-file-name-twice-in-exec-functions/187673#187673 */
/* End: */
