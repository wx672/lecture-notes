#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <errno.h>

int main()
{
    if ( open("/tmp/LCK.test", O_RDWR | O_CREAT | O_EXCL, 0444) == -1) {
        perror("open");
    } else {
        puts("Open succeeded.");
    }
    exit(EXIT_SUCCESS);
}
