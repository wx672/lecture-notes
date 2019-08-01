
typedef struct prio_array prio_array_t;

struct prio_array {
	unsigned int nr_active;
	unsigned long bitmap[BITMAP_SIZE];
	struct list_head queue[MAX_PRIO];
};
