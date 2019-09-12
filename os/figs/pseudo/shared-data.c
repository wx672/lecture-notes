#define BUFFER_SIZE 6
typedef struct {
	/* ... */
} item;
item buffer[BUFFER_SIZE];
int in = 0; //the next free position
int out = 0;//the first full position
