[org 0x7c00]
KERNEL_OFFSET equ 0x1000

	mov [BOOT_DRIVE], dl
	mov bp, 0x9000
	mov sp, bp

	mov bx, MSG_REAL_MODE 
	call print
	call print_nl

	call load_kernel
	call switch_to_pm 
	jmp $

%include "bootloader/print.asm"
%include "bootloader/disk.asm"
%include "bootloader/32bit-gdt.asm"
%include "bootloader/switchfunc.asm"

[bits 16]
load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print
	call print_nl

	mov bx, KERNEL_OFFSET
	mov dh, 2
	mov dl, [BOOT_DRIVE]
	call disk_load
	
	mov bx, MSG_AFTER_CALL
	call print
	call print_nl

	ret

[bits 32]
BEGIN_PM:
	call KERNEL_OFFSET
	jmp $

BOOT_DRIVE db 0
MSG_AFTER_CALL db "Done loading", 0
MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE db "Landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0

times 510 - ($-$$) db 0
dw 0xaa55
