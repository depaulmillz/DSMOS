all: kernel.o enterkernel.o kernel.bin boot.bin os.bin

boot.bin: bootloader/boot.asm
	nasm -fbin bootloader/boot.asm -o boot.bin

clean:
	-rm *.bin
	-rm *.o

kernel.o: kernel/kernel.c
	i386-elf-gcc -ffreestanding -c kernel/kernel.c -o kernel.o

enterkernel.o: bootloader/enterkernel.asm
	nasm -f elf bootloader/enterkernel.asm -o enterkernel.o

kernel.bin: enterkernel.o kernel.o
	i386-elf-ld -o kernel.bin -Ttext 0x1000 enterkernel.o kernel.o --oformat binary

os.bin:
	cat boot.bin kernel.bin > os.bin
