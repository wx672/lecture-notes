dynamic_loading(&routine){
  if (is_called && !loaded)
     load_routine_into_memory();
  pass_control(&routine);
}  
