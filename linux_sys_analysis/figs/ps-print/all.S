
# head5.S

page_pde_offset = (__PAGE_OFFSET >> 20);

        movl $(pg0 - __PAGE_OFFSET), %edi
        movl $(swapper_pg_dir - __PAGE_OFFSET), %edx
        movl $0x007, %eax       # 0x007 = PRESENT+RW+USER
10:
        leal 0x007(%edi), %ecx  # Create PDE entry
        movl %ecx, (%edx)       # Store identity PDE entry
        movl %ecx, page_pde_offset(%edx)  # Store kernel PDE entry
        addl $4, %edx
        movl $1024, %ecx
11:
        stosl   # movl %eax, (%edi)
                # addl $4, %edi
        addl $0x1000, %eax
        loop 11b
        # End condition: we must map up to and including INIT_MAP_BEYOND_END 
        # bytes beyond the end of our own page tables; the +0x007 is the
        # attribute bits 
        leal (INIT_MAP_BEYOND_END + 0x007)(%edi), %ebp
        cmpl %ebp, %eax
        jb 10b
        movl %edi, (init_pg_tables_end - __PAGE_OFFSET)

# head6.S

# Enable paging
movl $swapper_pg_dir - __PAGE_OFFSET, %eax
movl %eax, %cr3  # set the page table pointer..
movl %cr0, %eax
 orl $0x80000000, %eax
movl %eax, %cr0  # ..and set paging (PG) bit

# head-clr-bss.S

xorl %eax, %eax
movl $_edata, %edi
movl $_end, %ecx
subl %edi, %ecx
cld
rep
stosb

# head-gdt-setup.S

    lgdt boot_gdt_descr - __PAGE_OFFSET

    ...
    lgdt cpu_gdt_descr
    ...
    
boot_gdt_descr:
    .word __BOOT_DS+7                     # limit (31, end of DS)
    .long boot_gdt_table - __PAGE_OFFSET  # base location

ENTRY(boot_gdt_table)
    .fill GDT_ENTRY_BOOT_CS,8,0
    .quad 0x00cf9a000000ffff  # kernel 4GB code at 0x00000000 
    .quad 0x00cf92000000ffff  # kernel 4GB data at 0x00000000 

cpu_gdt_descr:
    .word GDT_ENTRIES*8-1
    .long cpu_gdt_table

    .fill NR_CPUS-1,8,0       # space for the other GDT descriptors
        
ENTRY(cpu_gdt_table)
    ...
    # Entry 12-15 
    .quad 0x00cf9a000000ffff  # 0x60 kernel 4GB code at 0x00000000 
    .quad 0x00cf92000000ffff  # 0x68 kernel 4GB data at 0x00000000 
    .quad 0x00cffa000000ffff  # 0x73 user 4GB code at 0x00000000 
    .quad 0x00cff2000000ffff  # 0x7b user 4GB data at 0x00000000 
    ...

# head-kernel-bss-init.S

xorl %eax,%eax
movl $__bss_start - __PAGE_OFFSET,%edi
movl $__bss_stop - __PAGE_OFFSET,%ecx
subl %edi,%ecx
shrl $2,%ecx
rep ; stosl

# head-kernel-pgt-init.S

page_pde_offset = (__PAGE_OFFSET >> 20);

    movl $(pg0 - __PAGE_OFFSET), %edi
    movl $(swapper_pg_dir - __PAGE_OFFSET), %edx
    movl $0x007, %eax                # 0x007 = PRESENT+RW+USER 
10:
    leal 0x007(%edi),%ecx            # Create PDE entry 
    movl %ecx,(%edx)                 # Store identity PDE entry 
    movl %ecx,page_pde_offset(%edx)  # Store kernel PDE entry 
    addl $4,%edx
    movl $1024, %ecx
11:
    stosl
    addl $0x1000,%eax
    loop 11b
    # End condition: we must map up to and including INIT_MAP_BEYOND_END 
    # bytes beyond the end of our own page tables; the +0x007 is the attribute bits 
    leal (INIT_MAP_BEYOND_END+0x007)(%edi),%ebp
    cmpl %ebp,%eax
    jb 10b
    movl %edi,(init_pg_tables_end - __PAGE_OFFSET)

# head-reg-init.S

startup_32:
        cld
        cli
        movl $(__BOOT_DS),%eax
        movl %eax,%ds
        movl %eax,%es
        movl %eax,%fs
        movl %eax,%gs

        lss stack_start,%esp

# setup-func-1.S

code32_start: # here loaders can put a different
              # start address for 32-bit code.
#ifndef __BIG_KERNEL__
      .long 0x1000   # 0x1000 = default for zImage
#else
      .long 0x100000 # 0x100000 = default for big kernel
#endif

# setup-func-2.S

code32: .long 0x1000 # will be set to 0x100000 for big kernels
        .word __BOOT_CS  

# setup-func-3.S

movl %cs:code32_start, %eax
movl %eax, %cs:code32

# setup-func-4.S

xorl %eax, %eax # Compute gdt_base
movw %ds,  %ax  # (Convert %ds:gdt to a linear ptr)
shll $4,   %eax
addl $gdt, %eax
movl %eax, (gdt_48 + 2)
lgdt gdt_48     # load gdt with whatever is appropriate

# setup-func-5.S

gdt_48:
     .word gdt_end - gdt - 1 # gdt limit
     .word 0, 0              # gdt base (filled in later)

gdt:
     .fill GDT_ENTRY_BOOT_CS,8,0

     .word 0xFFFF # 4Gb - (0x100000*0x1000 = 4Gb)
     .word 0      # base address = 0
     .word 0x9A00 # code read/exec
     .word 0x00CF # granularity = 4096, 386
                  # (+5th nibble of limit)

     .word 0xFFFF # 4Gb - (0x100000*0x1000 = 4Gb)
     .word 0      # base address = 0
     .word 0x9200 # data read/write
     .word 0x00CF # granularity = 4096, 386
                  # (+5th nibble of limit)
gdt_end:

# setup-func-6.S

movw $1, %ax # protected mode (PE) bit
lmsw %ax     # This is it!

# setup-func-7.S

movl %cr0, %edx
orb $X86_CR0_PE, %dl # Protected mode
movl %edx, %cr0

# setup-func-8.S

        .byte 0x66, 0xea # prefix + jmpi-opcode
code32: .long 0x1000     # will be set to 0x100000
                         # for big kernels
        .word __BOOT_CS
