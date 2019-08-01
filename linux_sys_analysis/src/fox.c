/*
  - Example program for demonstrating list_head.
  - Sec 6.1.4, p89-p90, in Linux Kernel Development, 3e
*/

struct fox {
  unsigned long tail_length;
  unsigned long weight;
  bool is_fantastic; 
  struct list_head list;
};

/*
  The list needs to be initialized before it can be used. Because most of the elements are
  created dynamically (probably why you need a linked list), the most common way of
  initializing the linked list is at run-time:
*/

struct fox *red_fox; /* just a pointer */
red_fox = kmalloc(sizeof(*red_fox), GFP_KERNEL);
red_fox->tail_length = 40;
red_fox->weight = 6;
red_fox->is_fantastic = false;
INIT_LIST_HEAD(&red_fox->list);

/*
  If the structure is statically created at compile time, and you have a direct reference
  to it, you can simply do this:
*/
struct fox red_fox = {
  .tail_length = 40,
  .weight = 6,
  .list = LIST_HEAD_INIT(red_fox.list),
};

