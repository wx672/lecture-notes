open(const char *path, O_RDONLY);
/* In this case, the open call will block; it will not return until a process opens the
   same FIFO for writing. */

open(const char *path, O_RDONLY | O_NONBLOCK);
/* The open call will now succeed and return immediately, even if the FIFO has not been
   opened for writing by any process. */

open(const char *path, O_WRONLY);
/* In this case, the open call will block until a process opens the same FIFO for
   reading. */
    
open(const char *path, O_WRONLY | O_NONBLOCK);
/* This will always return immediately, but if no process has the FIFO open for reading,
   open will return an error, –1, and the FIFO won't be opened. If a process does have the
   FIFO open for reading, the file descriptor returned can be used for writing to the
   FIFO. */

