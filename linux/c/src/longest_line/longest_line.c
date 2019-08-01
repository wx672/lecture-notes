/**
 * Program to process specified files and determine statistics about the
 * longest line.
 *
 * Output is one line per file, with colon (:) delimited fields:
 *
 *  length:filename:line_number:line_contents
 *
 * No output is produced for input arguments that do not correspond to valid
 * files. 
 *
 * Written by Sam Huang, Spring 2009 for CMSC 212
 */

#include <stdio.h>
#include <string.h>

#define MAX_LINE_LENGTH 4096

static void process_file(char *filename);

int main(int argc, char **argv) {
  int q;

  /* Quit if no arguments are passed. */
  if(argc <= 1) {
    printf("Usage: %s <files>\n", argv[0]);
    return 1;
  }

  /* Iterate through every argument passed into the program. */
  for(q = 1; q < argc; q++) {
    process_file(argv[q]);
  }

  return 0;
}

void process_file(char *filename) {
  char buf[MAX_LINE_LENGTH] = {0};
  FILE *file;

  char line_val[MAX_LINE_LENGTH] = {0};
  int line_len = -1;
  int line_num = -1;
  int cur_line = 1;

  file = fopen(filename, "r");
  if(file == NULL) {
    /*fprintf(stderr, "Couldn't open file %s for reading.\n", filename);*/
    return;
  }

  /* Go until the end of the file. */
  while(fgets(buf, MAX_LINE_LENGTH, file) != NULL) {
    int len_tmp = strlen(buf) - 1; /* -1 because of the newline. */

    /* Just kill the newline with an extra '\0'. */
    if(buf[len_tmp] == '\n')
      buf[len_tmp] = '\0';

    /* We've found a longer one! */
    if(line_len < len_tmp) {
      strncpy(line_val, buf, len_tmp + 1);
      line_len = len_tmp;
      line_num = cur_line;
    }

    /* Increment line counter. */
    cur_line++;
    /*printf("%s", buf);*/
  }

  /* Done reading, so close the file. */
  fclose(file);

  /* We never found a line... */
  if(line_num < 1) {
    /*fprintf(stderr, "Got no lines from file %s.\n", filename);*/
    return;
  }

  /* Print out the formatted output, etc. */
  printf("%d:%s:%d:%s\n", line_len, filename, line_num, line_val);

}
