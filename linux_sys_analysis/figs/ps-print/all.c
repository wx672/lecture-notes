
/* current-thread-info.c */

/* how to get the thread information struct from C */
static inline struct thread_info *current_thread_info(void)
{
  struct thread_info *ti;
  __asm__("andl %%esp, %0;" :"=r" (ti) :"0" (~(THREAD_SIZE - 1)));
  return ti;
}  

/* do-while.c */

/* Note: they use dummy do {} while construct so that
   it can be used syntactically as a single statement. */
#define INIT_LIST_HEAD(ptr) do {             \
    (ptr)->next = (ptr);(ptr)->prev= (ptr);  \
} while(0)  

/* hash-long.c */

unsigned long hash_long(unsigned long val, unsigned int bits)
{
    unsigned long hash = val * 0x9e370001UL;
    return hash >> (32 - bits);
}

/* list-for-each-1.c */

struct task_struct *task;
struct list_head *list;
for (list = (&current->children)->next;
             prefetch(list->next), list != (&current->children);
             list = list->next)
{
    task = list_entry(list, struct task_struct, sibling);
}

/* pagetable-init1.c */

pgd = swapper_pg_dir + pgd_index(PAGE_OFFSET); /* 768 */
phys_addr = 0x00000000;
while (phys_addr < (max_low_pfn * PAGE_SIZE))
{
  pmd = one_md_table_init(pgd); /* returns pgd itself */
  set_pmd(pmd, __pmd(phys_addr | pgprot_val(__pgprot(0x1e3))));
  /* 0x1e3 == Present, Accessed, Dirty, Read/Write, Page Size, Global */
  phys_addr += PTRS_PER_PTE * PAGE_SIZE; /* 0x400000, 4M */
  ++pgd;
}

/* paging-init.c */

void __init paging_init(void)
{
#ifdef CONFIG_X86_PAE
  /* ... */
#endif
  
  pagetable_init();
  load_cr3(swapper_pg_dir);

#ifdef CONFIG_X86_PAE
  /* ... */
#endif

  __flush_tlb_all();
  kmap_init();
  zone_sizes_init();
}  

/* pa-va.c */

#define __pa(x) ((unsigned long)(x)-PAGE_OFFSET)
#define __va(x) ((void *)((unsigned long)(x)+PAGE_OFFSET))  

/* pgdir-init-pae1.c */

pgd_idx = pgd_index(PAGE_OFFSET); /* 3 */
for (i=0; i<pgd_idx; i++)
  set_pgd(swapper_pg_dir + i, __pgd(__pa(empty_zero_page) + 0x001));
  /* 0x001 == Present */
pgd = swapper_pg_dir + pgd_idx;
phys_addr = 0x00000000;
for (; i<PTRS_PER_PGD; ++i, ++pgd) {
  pmd = (pmd_t *) alloc_bootmem_low_pages(PAGE_SIZE);
  set_pgd(pgd, __pgd(__pa(pmd) | 0x001)); /* 0x001 == Present */
  if (phys_addr < max_low_pfn * PAGE_SIZE)
    for (j=0; j < PTRS_PER_PMD /* 512 */
      && phys_addr < max_low_pfn*PAGE_SIZE; ++j) {
      set_pmd(pmd, __pmd(phys_addr | pgprot_val(__pgprot(0x1e3))));
      /* 0x1e3 == Present, Accessed, Dirty, Read/Write,
         Page Size, Global */
      phys_addr += PTRS_PER_PTE * PAGE_SIZE; /* 0x200000 */
    }
 }
swapper_pg_dir[0] = swapper_pg_dir[pgd_idx];  

/* pgdir-init-pae2.c */

pgd_idx = pgd_index(PAGE_OFFSET); /* 3 */

/* the first 3 entries are for user space, and are pointing to the same empty_zero_page.*/
for (i=0; i<pgd_idx; i++)
  set_pgd(swapper_pg_dir + i, __pgd(__pa(empty_zero_page) + 0x001)); /* 0x001 == Present */

/* the 4th entry is for kernel space*/
pgd = swapper_pg_dir + pgd_idx;
phys_addr = 0x00000000;

/* i=3 initially. PTRS_PER_PGD=4 */
for (; i<PTRS_PER_PGD; ++i, ++pgd) {
  /* get the address of a PMD.
     The PMD maps 1G allocated by alloc_bootmem_low_pages() */
  pmd = (pmd_t *) alloc_bootmem_low_pages(PAGE_SIZE);
  /* the 4th entry is initialized with the above PMD */
  set_pgd(pgd, __pgd(__pa(pmd) | 0x001)); /* 0x001 == Present */
  
  if (phys_addr < max_low_pfn * PAGE_SIZE) /* cover ZONE_NORMAL */
    for (j=0; j < PTRS_PER_PMD /* 512 */
      && phys_addr < max_low_pfn*PAGE_SIZE; ++j) {
      /* fill up each PMD entry */
      set_pmd(pmd, __pmd(phys_addr | pgprot_val(__pgprot(0x1e3))));
      /* 0x1e3 == Present, Accessed, Dirty, Read/Write,
         Page Size, Global */

      /* each PMD entry covers 2M */
      phys_addr += PTRS_PER_PTE * PAGE_SIZE; /* 0x200000 */
    }
 }

/* The fourth Page Global Directory entry is then copied into the first entry, so as to
   mirror the mapping of the low physical memory in the first 896 MB of the linear address
   space. This mapping is required in order to complete the initialization of SMP systems:
   when it is no longer necessary, the kernel clears the corresponding page table entries
   by invoking the zap_low_mappings() function, as in the previous cases. */
swapper_pg_dir[0] = swapper_pg_dir[pgd_idx];

/* provisional-pgdir1.c */

/*
 * Provisional PGDir and page tables setup
 * 
 * for mapping two linear address ranges to the same physical address range
 *
 *  + Linear address ranges:
 *             -   User mode: $i\times{}4M\sim{}(i+1)\times{}4M-1$
 *             - Kernel mode: $3G+i\times{}4M\sim{}3G+(i+1)\times{}4M-1$
 *  + Physical address range: $i\times{}4M\sim{}(i+1)\times{}4M-1$
 */
typedef unsigned int PTE;
PTE *pg = pg0;     /* physical address of pg0 */
PTE pte = 0x007;   /* 0x007 = PRESENT+RW+USER */
for(i=0;;i++){
  swapper_pg_dir[i] = pg + 0x007;         /* store identity PDE entry */
  swapper_pg_dir[i+page_pde_offset] = pg + 0x007; /* kernel PDE entry */
  for(j=0;j<1024;j++){               /* populating one page table */
    pg[i*1024 + j] = pte;            /* fill up one page table entry */
    pte += 0x1000;                   /* next 4k */
  }
  if(pte >= ((char*)pg + i*1024 + j)*4 + 0x007 + INIT_MAP_BEYOND_END)
    {
      init_pg_tables_end = pg + i*0x1000 + j;
      break;
    }
  }  

/* stack-start.c */

struct {
    long *a;
    short b;
} stack_start = { & user_stack [STACK_SIZE] , __BOOT_DS };

/* task-list2.c */

struct task_struct {
  struct list_head run_list;
  struct list_head tasks;
  struct list_head ptrace_children;
  struct list_head ptrace_list;
  struct list_head children; /* list of my children */
  struct list_head sibling;  /* linkage in my parent's children list */
}  

/* thread-size.c */

#ifdef CONFIG_4KSTACKS
#define THREAD_SIZE (4096)
#else
#define THREAD_SIZE (8192)
#endif  
