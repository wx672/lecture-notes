int filedes[2];

if (pipe(filedes) == -1) /* Create the pipe */
  errExit("pipe");

switch (fork()) { /* Create a child process */
 case -1:
   errExit("fork");

 case 0: /* Child */
   if (close(filedes[1]) == -1) /* Close unused write end */
     errExit("close");

   /* Child now reads from pipe */
   break;

 default: /* Parent */
   if (close(filedes[0]) == -1) /* Close unused read end */
     errExit("close");

   /* Parent now writes to pipe */
   break;
 }
