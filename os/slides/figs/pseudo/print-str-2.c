copy_from_user(buffer, p, count);
enable_interrupts();
while(*printer_status_reg != READY);
*printer_data_register = p[0];
scheduler();
