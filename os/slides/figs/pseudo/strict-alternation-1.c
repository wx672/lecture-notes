while(TRUE){
  while(turn != 0);
  critical_region();
  turn = 1;
  noncritical_region();
}      
