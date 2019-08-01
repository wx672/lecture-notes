int main(void)
{
  int array[MAX];

  init_array_1(array);
  init_array_1(&array[0]);
  init_array_1(&array);
  init_array_2(array);
  
  return 0;
}
