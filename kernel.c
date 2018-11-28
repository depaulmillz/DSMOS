
#define WHITE_ON_BLACK 0x0f
#define WHITE_ON_BLUE 0x9f

void kmain(void);
void kprint(char* vga, char* str, unsigned int size, unsigned char color);

void kmain(void)
{
	unsigned int maxCol = 80;
	unsigned int maxRows = 25;
	char *vga = (char*) 0xb8000;

	for(int i = 0; i < maxRows*maxCol; i++)
	{
		kprint(vga + i*2, " ",1, WHITE_ON_BLUE);
	}
	
	kprint(vga+74, "DSM OS", 6, WHITE_ON_BLUE);
}

void kprint(char *vga ,char* str, unsigned int size, unsigned char color)
{
	int j = 0;
	for(int i = 0; i < size; i++)
	{
		vga[j] = str[i];
		vga[j+1] = color;
		j+=2;
	}
}
