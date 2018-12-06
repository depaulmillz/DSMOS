;ignore first 11 bytes
;3.5 double sided 80 tracks per side 18 sectors per track

jmp boot
nop

OEM_LABEL db "        "
BYTES_PER_SECTOR dw 512
SECTORS_PER_CLUSTER db 1
NUMBER_OF_RESERVED_SECTORS dw 1
NUMBER_OF_FATS db 2
MAXIMUM_NUMB_OF_ROOT_DIR_ENTRIES dw 224
TOTAL_SECTORS dw 2880
MEDIA_DES db 0xf0
SECTORS_PER_FAT dw 9
SECTORS_PER_TRACK dw 18
NUMBER_OF_HEADS dw 2
HIDDEN_SECTORS dd 0
TOTAL_SECTORS_FAT12 dd 0 ;this is FAT 12
BOOT_SIG db 41 ;signature for floppy
VOL_ID dd 0x0
VOL_LABEL db "DSMOS      "
FILE_SYS_TYPE db "FAT12   "



[org 0x7c00]

boot:	

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
KERNEL_OFFSET equ 0x1000

times 510 - ($-$$) db 0
dw 0xaa55


