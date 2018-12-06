all: build/os.bin

build/boot.bin: bootloader/boot.asm
	nasm -fbin bootloader/boot.asm -o build/boot.bin

clean:
	-@rm build/*	

build/kernel.o: kernel/kernel.c
	i386-elf-gcc -ffreestanding -c kernel/kernel.c -o build/kernel.o

build/enterkernel.o: bootloader/enterkernel.asm
	nasm -f elf bootloader/enterkernel.asm -o build/enterkernel.o

build/kernel.bin: build/enterkernel.o build/kernel.o
	i386-elf-ld -o build/kernel.bin -Ttext 0x1000 build/enterkernel.o build/kernel.o --oformat binary

build/os.bin: build/boot.bin build/kernel.bin
	cat build/boot.bin build/kernel.bin > build/os.bin

img: build/os.bin
	dd if=/dev/zero of=build/dsmos.img bs=512 count=2
	dd if=build/os.bin of=build/dsmos.img seek=0 count=2 conv=notrunc
	
