; Program to read the first sector of the disk and display its raw content
; The first sector is typically the Master Boot Record (MBR), containing the bootloader and partition information
;
; Author: Dawid Bielecki - dawciobiel
; GitHub: https://github.com/dawciobiel
; Version: 1.0
;
; Usage:
;   ./read-disk-sector-linux-x64.elf64 < /dev/sda | hexdump
;   ./read-disk-sector-linux-x64.elf64 < /dev/sda > first-sector.bin


section .bss
    ; Reserve 512 bytes for the sector data (one sector is 512 bytes in size)
    buffer resb 512        

section .text
    global _start   ; Declare the entry point of the program

_start:
    ; Step 1: Read the first sector from the disk (MBR)
    ; This syscall will read data from the disk (stdin) and store it in the buffer
    mov rax, 0x0          ; Syscall number for sys_read (0)
    mov rdi, 0            ; File descriptor 0 (stdin), which represents the disk device
    mov rsi, buffer       ; Address of the buffer where the sector data will be stored
    mov rdx, 512          ; Number of bytes to read (one sector = 512 bytes)
    syscall               ; Execute the syscall to read data from the disk

    ; Step 2: Write the content of the sector to stdout
    ; This will output the raw data read from the disk to the terminal (stdout)
    mov rax, 1            ; Syscall number for sys_write (1)
    mov rdi, 1            ; File descriptor 1 (stdout)
    mov rsi, buffer       ; Address of the buffer containing the sector data
    mov rdx, 512          ; Length of the data to write (512 bytes)
    syscall               ; Execute the syscall to write the data to stdout

    ; Step 3: Exit the program gracefully
    mov rax, 60           ; Syscall number for sys_exit (60)
    xor rdi, rdi          ; Exit code 0 (no error)
    syscall               ; Execute the syscall to exit the program

; End of program
