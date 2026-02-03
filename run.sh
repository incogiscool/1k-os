# !/bin/bash
set -xue

# QEMU file path
QEMU=qemu-system-riscv32

# Start QEMU
$QEMU -machine virt -bios default -nographic -serial mon:stdio --no-reboot

# -machine virt -> start a virt machine. Can check other machines with the -machine '?' option
# -bios default -> use default firmware (OpenSBI)
# -nongraphic -> start QEMU without the GUI window
# -serial mon:stdio -> Connect QEMU's standard i/o to the vm's serial port. mon: allows switching from QEMU monitor by pressing Ctrl+A then C
# --no-reboot -> if the vm crashes, stop the emulator without rebooting (useful for debugging)