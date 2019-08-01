#define MAX 10

void init_array_1(int a[]){
  int i;

  for (i = 0; i < MAX; ++i)
      a[i] = 0;
}

void init_array_2(int *ptr){
  int i;

  for (i = 0; i < MAX; ++i)
      *(ptr + i) = 0;
}
