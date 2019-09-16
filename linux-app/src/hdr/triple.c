#include "add.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    if (argc < 2) {
        fprintf(stderr, "Usage: %s number\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    int i = atoi(argv[1]);

    printf("triple of %d is %d.\n", i, triple(i));
    return 0;
}
