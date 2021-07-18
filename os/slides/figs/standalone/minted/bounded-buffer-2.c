while (true) {
  while (in == out); /* do nothing */

  consume(buffer[out]);

  out = (out + 1) % BUFFER_SIZE;
}

