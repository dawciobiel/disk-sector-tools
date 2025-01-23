; Program to read the first sector of the disk and display its raw content
; The first sector is typically the Master Boot Record (MBR), containing the bootloader and partition information
;
; Author: Dawid Bielecki - dawciobiel
; GitHub: https://github.com/dawciobiel
; Version: beta
;
; Usage:
;   ./read-disk-sector-beta-win.exe > read-disk-sector-beta-win.exe.bin


section .data
    disk_path db '\\.\PhysicalDrive0', 0  ; Path to the physical drive
    bytes_per_sector equ 512             ; Size of one sector (in bytes)

section .bss
    buffer resb bytes_per_sector         ; Buffer to store sector data

section .text
    global _start

_start:
    ; Step 1: Open the disk device
    mov rax, 0x20000         ; Syscall: CreateFileA (Windows API)
    lea rdx, [rel disk_path] ; Path to the disk
    mov rcx, 0              ; Access mode: GENERIC_READ
    mov r8, 0               ; Share mode: No sharing
    mov r9, 0               ; Security attributes: NULL
    push 0                  ; Flags: Open existing
    push 0                  ; Template file: NULL
    syscall
    test rax, rax           ; Check if the handle is valid
    js error_exit           ; Exit if an error occurred
    mov r12, rax            ; Save handle to r12

    ; Step 2: Read the first sector
    mov rax, 0x2003B        ; Syscall: ReadFile (Windows API)
    mov rcx, r12            ; Handle of the disk
    lea rdx, [rel buffer]   ; Buffer to store the sector
    mov r8, bytes_per_sector ; Number of bytes to read
    sub rsp, 8              ; Overlapped parameter (NULL)
    mov qword [rsp], 0
    syscall
    test rax, rax           ; Check if read was successful
    js close_exit           ; Exit if an error occurred

    ; Step 3: Write raw sector data to stdout
    mov rax, 0x2004         ; Syscall: WriteFile (Windows API)
    mov rcx, 1              ; File descriptor: stdout
    lea rdx, [rel buffer]   ; Address of the buffer
    mov r8, bytes_per_sector ; Number of bytes to write
    sub rsp, 8              ; Overlapped parameter (NULL)
    mov qword [rsp], 0
    syscall

    ; Step 4: Exit program gracefully
close_exit:
    mov rax, 0x2004A        ; Syscall: CloseHandle (Windows API)
    mov rcx, r12            ; Handle of the disk
    syscall
error_exit:
    mov rax, 0x20005        ; Syscall: ExitProcess (Windows API)
    xor rcx, rcx            ; Exit code: 0
    syscall
