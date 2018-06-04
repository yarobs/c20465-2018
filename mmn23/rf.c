#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define WRD_SIZE 32
#define IN 1
#define OUT 0

int c;

int is_permutation_old(char * word, const char * str) {
	int i, k;
	char perm[strlen(str)];
	printf("Hello permut: word: %s str: %s\n", word, str);
	for (i=0; i < strlen(str); i++) {
		for (k=0; k < strlen(word); k++) {
			printf("Perm: str[%d]: %c word[%d]: %c\n", i, str[i], k, word[k]);
			if (str[i] == word[k]) {
				perm[k] = word[k];
				break;
			}
		}
		if (k == strlen(word)) {
			return 0;
		}
	}
	perm[i] = '\0';
	printf("%s\n", perm);
	return 1;
}

int is_permutation(char * word, const char * str) {
	int i, k, j = 0, state = OUT;
	char perm[strlen(str)];
	//printf("Hello permut: word: %s str: %s\n", word, str);
	for (i = 0, j = 0; word[i] != '\0'; i++) {
		for (k = 0; str[k] != '\0'; k++) {
			//printf("Perm: str[%d]: %c word[%d]: %c\n", i, str[i], k, word[k]);
			if (word[i] == str[k]) {
				//printf("Perm f 1.0: str[%d]: %c word[%d]: %c\n", k, str[k], i, word[i]);
				perm[j++] = word[i];
			}
		}
		//printf("Perm: j: %d k: %d\n", j, k);
		if (j == k) {
			perm[k] = '\0';
			printf("%s\n", perm);
			j = 0;
		}
	}
	
	return 1;
}

void main(int argc, char *argv[]) {

	const char *inputf = argv[1];
	const char *str = argv[2];
	int state = OUT, i = 0;
	int permlen = strlen(str), wordl, permc = 0;
	char word[WRD_SIZE];

	FILE *f = fopen(inputf, "r");

	if (f == NULL) {
		printf("Error opening file.\n");
		exit(1);
	}

	while ( (c = fgetc(f)) != EOF ) {
		if (c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z') {
			//printf("rf 1.0: i: %d c: %d\n", i, c);
			state = IN;
			word[i] = c;
			i++;
		} else if (state == IN) {
			//printf("rf 1.1: i: %d\n", i);
			word[i]='\0';
			state = OUT;
			i=0;
			wordl = strlen(word);
			if (wordl >= permlen) {
				//printf("Enter permutation: len: %d\n", wordl);
				permc += (is_permutation(word, str));
			}
		}
	}
}
