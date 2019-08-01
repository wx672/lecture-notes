#include <stdio.h>
#include <string.h>
 
#define BUFFER_SIZE 25
 
void buffer_char(char c);
char unbuffer_char(void);
 
//a buffer with BUFFER_SIZE slots
char circular_buffer[BUFFER_SIZE];
 
//integers to index circular_buffer
int start, end;
 
int main(int argc, char *argv[])
{
        char sentence[] = {"The quick brown dog jumped over the lazy fox."};
        int i;
 
        //add sentence into the buffer
        for (i = 0; i < strlen(sentence); i++) {
                buffer_char(sentence[i]);
        }
 
        //read the contents of the buffer
        while(start != end) {
                printf("%c", unbuffer_char());
        }
 
        printf("\n");
        return 0;
}
 
void buffer_char(char c)
{
        //Use modulo as a trick to wrap around the end of the buffer back to the beginning
        if ((end + 1) % BUFFER_SIZE != start) {
                circular_buffer[end] = c;
                end = (end + 1) % BUFFER_SIZE;
        }
        //otherwise, the buffer is full; don't do anything
}
 
char unbuffer_char(void)
{
        char temp = circular_buffer[start];
        start = (start + 1) % BUFFER_SIZE;
        return(temp);
}
