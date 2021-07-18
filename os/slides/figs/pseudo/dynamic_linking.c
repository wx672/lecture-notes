if(stub_is_executed){
  if(the_needed_routine_is_not_in_memory)
      loads_the_routine_into_memory();
 
  stub_replaces_itself_with_the_address_of_the_routine();
  executes_the_routine();
}  
