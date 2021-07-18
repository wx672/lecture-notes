while(!done_reading_a_file())
{
  let_CPU_wait();
  /* or... */
  lend_CPU_to_others();
}
operate_on_the_file();  
