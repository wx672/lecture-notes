while(TRUE){
  while(turn != 1);
  critical_region();
  turn = 0;
  noncritical_region();
}
