while (true) {
  while (((in + 1) % BUFFER_SIZE) == out);
  buffer[in] = item;
  in = (in + 1) % BUFFER_SIZE;
}      
