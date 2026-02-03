/* Declares that the boot function is the entry point of the OS */
ENTRY(boot)

SECTIONS {
    /* RISC-V Kernel Entry Point Address */
    . = 0x80200000;

    /* Where all the code lies */
    .text :{
        KEEP(*(.text.boot));
        *(.text, .text.*)
    }

    /* Where all the constants and read-only data lies */
    .rodata : ALIGN(4) {
        *(.rodata .rodata.*)
    }

    /* Read/write data */
    .data : ALIGN(4) {
        *(.data .data.*)
    }

    /* Read/write data with an init val of 0 */
    .bss : ALIGN(4) {
        __bss = .;
        *(.bss .bss.* .sbss .sbss.*)
        __bss_end = .;
    }

    . = ALIGN(4);
    . += 128 * 1024; /* 128 KB */
    __stack_top = .;
    
}

/* The . means current address. Each section has a 4-byte boundary between it (ALIGN(4)), and then we increment the current adress by 128KB */
/* Wherever we do __varname = ., like __bss, __bss_end, and __stack_top, it means we are assign the current address to that symbol. We can use this variable in C with extern char varname*/