#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXBUFLEN 1000000

void goto_matching(char **rom);

int main(int argc, char **argv) {
	for (int i = 1; i < argc; i++) {

		// Read file
		char *rom = malloc(MAXBUFLEN + 1);
		FILE *fp = fopen(argv[i], "r");
		if (fp == NULL) continue;
		size_t newLen = fread(rom, sizeof(char), MAXBUFLEN, fp);
		if (ferror( fp ) != 0)
			fputs("Error reading file", stderr);
		else
			rom[newLen++] = '\0';

		fclose(fp);

		// Yay
		char *ptr = malloc(30000);
		memset(ptr, 0, 30000);

		while (*rom) {
			switch (*rom) {
				case '+':
					*ptr += 1;
					break;
				case '-':
					*ptr -= 1;
					break;
				case '>':
					ptr++;
					break;
				case '<':
					ptr--;
					break;
				case '.':
					putchar(*ptr);
					break;
				case ',':
					*ptr = getchar();
					break;
				case '[':
					if (*ptr == 0)
						goto_matching(&rom);
					break;
				case ']':
					if (*ptr != 0)
						goto_matching(&rom);
					break;
			}
			rom++;
		}
	}
}

void goto_matching(char **rom) {
	int direction = **rom == '[' ? 1 : -1;
	int i = 0;
	while (**rom) {
		if (**rom == '[') i++;
		else if (**rom == ']') i--;
		if (i == 0) break;
		*rom += direction;
	}
}
