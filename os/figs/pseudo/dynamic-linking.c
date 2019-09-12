if(stub_is_executed){
  if(routine_is_not_in_memory)
    loads_into_memory(&routine);

  stub_replaces_itself(&routine);
  execute(routine);
}    
