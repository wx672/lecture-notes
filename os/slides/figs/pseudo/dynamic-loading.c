dynamic_loading(){
  if(a_routine_is_called && !loaded)
      load_routine_into_memory();

  pass_ctrl(routine);
}  
