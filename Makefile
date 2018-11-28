all: kernel.o enterkernel.o kernel.bin boot.bin os.bin

boot.bin: boot.asm
	nasm -fbin boot.asm -o boot.bin

clean:
	-rm *.bin
	-rm *.o

kernel.o: kernel.c
	i386-elf-gcc -ffreestanding -c kernel.c -o kernel.o

enterkernel.o: enterkernel.asm
	nasm -f elf enterkernel.asm -o enterkernel.o

kernel.bin: enterkernel.o kernel.o
	i386-elf-ld -o kernel.bin -Ttext 0x1000 enterkernel.o kernel.o --oformat binary

os.bin:
	cat boot.bin kernel.bin > os.bin
