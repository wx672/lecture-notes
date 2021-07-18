#include <sched.h>
int clone(int (*fn) (void *), void *child_stack,
          int flags, void *arg, ...);        
