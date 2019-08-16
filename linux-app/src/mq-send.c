#include <fcntl.h>
#include <limits.h>
#include <mqueue.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

int main(int argc, char **argv)
{
  mqd_t queue;
  struct mq_attr attrs;
  size_t msg_len;

  if (argc < 3){
    fprintf(stderr, "Usage: %s <queuename> <message>\n", argv[0]);
    return 1;
  }

  queue = mq_open(argv[1], O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR, NULL);
  if (queue == (mqd_t)-1){
	perror("mq_open");
	return 1;
  }

  if (mq_getattr(queue, &attrs) == -1){
    perror("mq_getattr");
    mq_close(queue);
    return 1;
  }

  msg_len = strlen(argv[2]);
  if (msg_len > LONG_MAX || (long)msg_len > attrs.mq_msgsize){
    fprintf(stderr, "Your message is too long for the queue.\n");
    mq_close(queue);
    return 1;
  }

  if (mq_send(queue, argv[2], strlen(argv[2]), 0) == -1){
    perror("mq_send");
    mq_close(queue);
    return 1;
  }

  return 0;
}
