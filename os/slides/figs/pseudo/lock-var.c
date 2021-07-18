int lock=0; //shared variable
{
  ...
  while(lock); //busy waiting
  lock=1;
  critical_code();
  lock=0;
  ...
}        
