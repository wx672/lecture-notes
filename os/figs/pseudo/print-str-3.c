if (count == 0) {
  unblock_user();
} else {
  *printer_data_register = p[1];
  count = count - 1;
  i = i + 1;
}
acknowledge_interrupt();
return_from_interrupt();
