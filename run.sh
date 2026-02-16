# !/bin/bash
set -xue

# QEMU file path
QEMU=qemu-system-riscv32

# Path to clang and compier flags
CC=/opt/homebrew/opt/llvm/bin/clang
CFLAGS="-std=c11 -O2 -g3 -Wall -Wextra --target=riscv32-unknown-elf -fuse-ld=lld -fno-stack-protector -ffreestanding -nostdlib"

# Build the kernel
$CC $CFLAGS -Wl,-Tkernel.ld -Wl,-Map=kernel.map -o kernel.elf\
    kernel.c common.c

# Start QEMU
$QEMU -machine virt -bios default -nographic -serial mon:stdio --no-reboot \
    -kernel kernel.elf

# -machine virt -> start a virt machine. Can check other machines with the -machine '?' option
# -bios default -> use default firmware (OpenSBI)
# -nongraphic -> start QEMU without the GUI window
# -serial mon:stdio -> Connect QEMU's standard i/o to the vm's serial port. mon: allows switching from QEMU monitor by pressing Ctrl+A then C
# --no-reboot -> if the vm crashes, stop the emulator without rebooting (useful for debugging)
