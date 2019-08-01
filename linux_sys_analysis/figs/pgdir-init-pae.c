
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
      set_pmd(pmd, __pmd(phys_addr |
			  pgprot_val(__pgprot(0x1e3))));
      /* 0x1e3 == Present, Accessed, Dirty, Read/Write,
	 Page Size, Global */
      phys_addr += PTRS_PER_PTE * PAGE_SIZE; /* 0x200000 */
    }
 }
swapper_pg_dir[0] = swapper_pg_dir[pgd_idx];
