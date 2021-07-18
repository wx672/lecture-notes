while (true) {
  while (in == out); // do nothing 
  // remove an item from the buffer
  item = buffer[out];
  out = (out + 1) % BUFFER_SIZE;
  return item;
}
