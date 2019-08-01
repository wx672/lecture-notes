#include "hello.h"
int hi(char* s){
	static char x[1024000]={1}; /* useless. just make this program bigger */
	printf ("Hello, again %s\n",s);
	return 0;
}
