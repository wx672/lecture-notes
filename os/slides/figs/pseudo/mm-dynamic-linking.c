if ( stub_is_executed ){
  if ( !routine_in_memory )
     load_routine_into_memory();
  stub_replaces_itself_with_routine();
  execute_routine();
}  
