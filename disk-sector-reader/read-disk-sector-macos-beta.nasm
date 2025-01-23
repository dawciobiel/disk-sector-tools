; Program to read the first sector of the disk and display its raw content
; The first sector is typically the Master Boot Record (MBR), containing the bootloader and partition information
;
; Author: Dawid Bielecki - dawciobiel
; GitHub: https://github.com/dawciobiel
; Version: beta
;
; Usage:
;   ./read-disk-sector-beta-macos.out < /dev/sda | hexdump

section .bss
    ; Reserve 512 bytes for the sector data (one sector is 512 bytes in size)
    buffer resb 512        

section .text
    global _start   ; Declare the entry point of the program

_start:
    ; Step 1: Open the disk device file
    ; On macOS, you must open the device file (e.g., /dev/disk0) first
    mov rax, 0x2000005     ; Syscall number for sys_open
    lea rdi, [rel disk_path] ; Pointer to the device file path
    xor rsi, rsi           ; Flags (read-only mode)
    xor rdx, rdx           ; Mode (not needed for read-only)
    syscall                ; Execute the syscall
    mov r12, rax           ; Save the file descriptor in r12

    ; Step 2: Read the first sector
    mov rax, 0x2000003     ; Syscall number for sys_read
    mov rdi, r12           ; File descriptor for the disk
    mov rsi, buffer        ; Address of the buffer where the sector data will be stored
    mov rdx, 512           ; Number of bytes to read (one sector = 512 bytes)
    syscall                ; Execute the syscall to read data

    ; Step 3: Write the content of the sector to stdout
    mov rax, 0x2000004     ; Syscall number for sys_write
    mov rdi, 1             ; File descriptor 1 (stdout)
    mov rsi, buffer        ; Address of the buffer containing the sector data
    mov rdx, 512           ; Length of the data to write (512 bytes)
    syscall                ; Execute the syscall to write the data to stdout

    ; Step 4: Close the file descriptor
    mov rax, 0x2000006     ; Syscall number for sys_close
    mov rdi, r12           ; File descriptor to close
    syscall                ; Execute the syscall

    ; Step 5: Exit the program gracefully
    mov rax, 0x2000001     ; Syscall number for sys_exit
    xor rdi, rdi           ; Exit code 0 (no error)
    syscall                ; Execute the syscall

section .data
    disk_path db "/dev/disk0", 0 ; Path to the disk device file on macOS
