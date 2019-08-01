/*--------------------------------------*/
/* extra system.h stuff */
#define NUM_SEMS 50

/* semaphore data structures */
struct semaphore {
  int allocated;
  int count;
  int use_count;
  int id;
  pid_queue queue;
};

struct semaphore sema[NUM_SEMS];
/*--------------------------------------*/
/* semaphore.c stuff */

/** attach to sem if there, else create **/
int AttachSemaphore(int key) {
   int free_slot = -1;

   /* look for an allocated semaphore with this id.
      if we don't find one, keep track of a free one to allocate */
   for (int i=0; i < NUM_SEMS; i++) {
      if (sema[i].allocated) {
	 if (sema[i].id == key) break;
      } else
	free_slot = i;
   }
   
   /* gone through all, then key does not exist */
   if (i == NUM_SEMS) {
      if (free_slot == -1) return -1; /* none free */
      /* create a new one */
      sema[free_slot].allocated = TRUE;
      sema[free_slot].count = 1; /* one allowed in, by default */
      sema[free_slot].use_count = 0; /* no one attached to start*/
      sema[free_slot].id = key;	
      makeEmpty(sema[free_slot].queue);
   }
   sema[i].use_count++;		/* one more is attached */

   return i;			/* process will use index */
}

/** deattach from semaphore, delete if last **/
int DetachSemaphore(int sid) {
   if (!sema[sid].allocated) return -1;	/* sid is invalid */

   sema[sid].use_count--;
   if (sema[sid].use_count == 0)
      sema[sid].allocated = FALSE;
   return 0;
}


/** signal **/
int SignalSemaphore(int sid) {
  int pid;

  if (!sema[sid].allocated) return -1;	/* sid is invalid */

  sema[sid].count++;
  if (sema[sid].count <= 0)
    pid = remove(sema[sid].queue);
    pd[pid].state = READY;
  }

  return 0;
}

/** wait **/
int WaitSemaphore(int sid) {
  
  if (!sema[sid].allocated) return -1;	/* sid is invalid */

  sema[sid].count--;
  if (sema[sid].count < 0) 
    insert(sema[sid].queue, current_process);
    pd[current_process].state = BLOCKED;
    Dispatcher();
  }

  return 0;
}
