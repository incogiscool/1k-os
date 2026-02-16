#include "kernel.h"
#include "common.h"

typedef unsigned char uint8_t;
typedef unsigned int uint32_t;
typedef uint32_t size_t;

/* Defining the vars from linker script */
extern char __bss[], __bss_end[], __stack_top[];

/* If we don't add the [], it means 'the value of the 0th byte of the .bss section.' With the [], it gives us the address.*/


struct sbiret sbi_call(long arg0, long arg1, long arg2, long arg3, long arg4, long arg5, long fid, long eid) {
    register long a0 __asm__("a0") = arg0;
    register long a1 __asm__("a1") = arg1;
    register long a2 __asm__("a2") = arg2;
    register long a3 __asm__("a3") = arg3;
    register long a4 __asm__("a4") = arg4;
    register long a5 __asm__("a5") = arg5;
    register long a6 __asm__("a6") = fid;
    register long a7 __asm__("a7") = eid;

    __asm__ __volatile__("ecall"
                        : "=r"(a0), "=r"(a1)
                        : "r"(a0), "r"(a1), "r"(a2), "r"(a3), "r"(a4), "r"(a5), "r"(a6), "r"(a7)
                        : "memory");
    
    return (struct sbiret) {.error = a0, .value = a1 };
}

void putchar(char ch) {
    /* Console putchar */
    sbi_call(ch, 0, 0, 0, 0, 0, 0, 1);
}



void *memset(void *buf, char c, size_t n) {
    /* Loop through the entire buffer/memory and set it to c */

    uint8_t *p = (uint8_t *) buf;

    /* Can also be written with a for loop. Currently while loop and decrements until n=0 */
    while (n--) {
        *p++ = c;
    }

    return buf;
}

void kernel_main(void) {
    // memset(__bss, 0, (size_t) __bss_end - (size_t) __bss);

    // for (;;);

    char *name = "Adam El Taha";

    printf("\n\nHello World! From: %s\n", name);

    printf("1 + 2 = %d, %x\n", 1 + 2, 0x1234abcd);

    
    for (;;) {
        __asm__ __volatile__("wfi");
    }
}


/* Controls the placement of the function in the linker script. Since OpenSBI just jumps to 0x80200000 without knowing the entry point, boot function needs to be placed there*/
__attribute__((section(".text.boot")))

/* Tells the compiler to not generate any unneeded code before and after the function body such as a return instruction. This makes sure that the inline assmebly is exact*/
__attribute__((naked))


/* This is our boot function that we defined in our linker script */
void boot(void) {
    __asm__ __volatile__ (
        "mv sp, %[stack_top]\n" // Set the stack pointer to stack_top
        "j kernel_main\n" // Jump to the kernel main function
        :
        : [stack_top] "r" (__stack_top) // Pass the stack top address as %[stack_top] as a read only (we're not writing to the variable)
    );
}