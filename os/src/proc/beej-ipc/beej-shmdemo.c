/*
** shmdemo.c -- read and write to a shared memory segment
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>

#define SHM_SIZE 1024  /* make it a 1K shared memory segment */

int main(int argc, char *argv[])
{
	key_t key;
	int shmid;
	char *data;
	int mode;

	if (argc > 2) {
		fprintf(stderr, "usage: shmdemo [data_to_write]\n");
		exit(1);
	}

	/* make the key: */
	if ((key = ftok("shmdemo.c", 'R')) == -1) {
		perror("ftok");
		exit(1);
	}

	/* connect to (and possibly create) the segment: */
	if ((shmid = shmget(key, SHM_SIZE, 0644 | IPC_CREAT)) == -1) {
		perror("shmget");
		exit(1);
	}

	/* attach to the segment to get a pointer to it: */
	data = shmat(shmid, (void *)0, 0);
	if (data == (char *)(-1)) {
		perror("shmat");
		exit(1);
	}

	/* read or modify the segment, based on the command line: */
	if (argc == 2) {
		printf("writing to segment: \"%s\"\n", argv[1]);
		strncpy(data, argv[1], SHM_SIZE);
	} else
		printf("segment contains: \"%s\"\n", data);

	/* detach from the segment: */
	if (shmdt(data) == -1) {
		perror("shmdt");
		exit(1);
	}

	return 0;
}
