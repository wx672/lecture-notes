#include <fcntl.h>
#include <mqueue.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>

int main(int argc, char **argv)
{
  mqd_t queue;
  struct mq_attr attrs;
  char *msg_ptr;
  ssize_t recvd;
  size_t i;

  if (argc < 2){
    fprintf(stderr, "Usage: %s <queuename>\n", argv[0]);
    return 1;
  }

  queue = mq_open(argv[1], O_RDONLY | O_CREAT, S_IRUSR | S_IWUSR, NULL);
  if (queue == (mqd_t)-1){
    perror("mq_open");
    return 1;
  }

  if (mq_getattr(queue, &attrs) == -1){
    perror("mq_getattr");
    mq_close(queue);
    return 1;
  }

  msg_ptr = calloc(1, attrs.mq_msgsize);
  if (msg_ptr == NULL){
    perror("calloc for msg_ptr");
    mq_close(queue);
    return 1;
  }

  recvd = mq_receive(queue, msg_ptr, attrs.mq_msgsize, NULL);
  if (recvd == -1){
    perror("mq_receive");
    return 1;
  }

  printf("Message: ");
  for (i = 0; i < (size_t)recvd; i++)
    putchar(msg_ptr[i]);
  puts("");
}

/* Local Variables: */
/* compile-command: "gcc -Wall -Wextra mq-recv.c -o mq-recv -lrt" */
/* End: */
