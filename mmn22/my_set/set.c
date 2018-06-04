#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "set.h"

int read_set(char **args, int *argsc, sets_arr *sets) {
	int i, k;
	char *set_name = args[0];
	char *args_term = args[*argsc-1];
	set *s;

	if (*argsc > SIZE+1) {
		fprintf(stderr, "%s: too many arguments, only 1 argument expected\n", __func__);
		return 1;
	}
	
	if (*argsc == 0) {
		fprintf(stderr, "%s: missing arguments\n", __func__);
		return 1;
	}

	for (i=0; sets[i].set != NULL; i++) {
		if (strcmp(set_name, sets[i].name) == 0) {
			/*s = sets[i].set;*/
			break;
		}
	}

	s = sets[i].set;
	if (*s == NULL) {
		fprintf(stderr, "%s:  undefined set name: %s\n", __func__, set_name);
		return 1;
	}

	if ((strcmp(args_term, "-1"))) {
		fprintf(stderr, "%s: missing input terminator\n", __func__);
		return 1;
	}

	for (i=0;i<ARR_SIZE;i++) {
		*(*s + i)=0;
	}
	for (i=1; strcmp(args[i], "-1"); i++) {
		if (!is_strint(args[i])) {
			fprintf(stderr, "%s: value is not an integer: %s\n", __func__, args[i]);
			s = 0;
			return 1;
		}
		k=atoi(args[i]);
		if (k < 0 || k >= SIZE) {
			fprintf(stderr, "%s: value out of range: %d\n", __func__, k);
			s = 0;
			return 1;
		}
		set_element(*s, k);
	}

	return 0;
}
int print_set(char **args, int *argsc, sets_arr *sets) {
	int i, n, is_empty = 1, set_start = 1;
	char *set_name = args[0];
	set *s;

	if (*argsc > 1) {
		fprintf(stderr, "%s: too many arguments, only 1 argument expected\n", __func__);
		return 1;
	}
	if (*argsc == 0) {
		fprintf(stderr, "%s: missing arguments\n", __func__);
		return 1;
	}

	for (i=0; sets[i].set != NULL; i++) {
		if (strcmp(set_name, sets[i].name) == 0) {
			/*s = sets[i].set;*/
			break;
		}
	}

	s = sets[i].set;
	if (s == NULL) {
		fprintf(stderr, "%s:  Undefined set name: %s\n", __func__, set_name);
		return 1;
	}

	for (i=0, n=0; i < SIZE; i++) {
		if (get_element(*s, i)) {
			if (set_start) {
				printf("{%3d", i);
				set_start=0;
				is_empty = 0;
			} else if (n%PRINT_PER_LINE == 0) {
				printf("\n %3d", i);
			} else {
				/* Some kind of magic is going on here ^__^ */
				printf(", %3d", i);;
			}
			n++;
		}
	}
	if (is_empty) {
		printf("Set %s is empty\n", set_name);
	} else {
		printf("}\n");
	}

	return 0;
}

int union_set(char **args, int *argsc, sets_arr *sets) {
	int i, j;
	set s_tmp={0};
	sets_arr s[3];

	if (*argsc > 3) {
		fprintf(stderr, "%s: too many arguments\n", __func__);
		return 1;
	}
	if (*argsc < 3) {
		fprintf(stderr, "%s: missing arguments\n", __func__);
		return 1;
	}

	for (i=0; i < *argsc; i++){
		for (j=0; sets[j].set != NULL; j++) {
			if (strcmp(args[i], sets[j].name) == 0) {
				break;
			}
		}
		printf("Union 1: i: %d j: %d\n", i, j);
		s[i].set = sets[j].set;
		s[i].name = sets[j].name;
		if (sets[j].set == NULL) {
			fprintf(stderr, "%s:  Undefined set name: %s\n", __func__, args[i]);
			return 1;
		}
	}

	for (i=0; i < ARR_SIZE; i++) {
		s_tmp[i] = *(*s[0].set + i) | *(*s[1].set + i);
	}
	
	for (i=0; i < ARR_SIZE; i++) {
		*(*s[2].set + i) = s_tmp[i];
	}
	
	/*for (i=0; i < ARR_SIZE; i++) {
		printf("Set 0 %d: %d\n", i, *s[0].set[i]);
		*sets[2].set[i] = *s[0].set[i] | *s[1].set[i];
	}*/
	return 0;
}
int intersect_set(char **args, int *argsc, sets_arr *sets) {
	int i, j;
	set s_tmp={0};
	sets_arr s[3];

	if (*argsc > 3) {
		fprintf(stderr, "%s: too many arguments\n", __func__);
		return 1;
	}
	if (*argsc < 3) {
		fprintf(stderr, "%s: missing arguments\n", __func__);
		return 1;
	}

	for (i=0; i < *argsc; i++){
		for (j=0; sets[j].set != NULL; j++) {
			if (strcmp(args[i], sets[j].name) == 0) {
				break;
			}
		}

		s[i].set = sets[j].set;
		s[i].name = sets[j].name;
		if (sets[j].set == NULL) {
			fprintf(stderr, "%s:  Undefined set name: %s\n", __func__, args[i]);
			return 1;
		}
	}

	for (i=0; i < ARR_SIZE; i++) {
		s_tmp[i] = *(*s[0].set + i) & *(*s[1].set + i);
	}
	
	for (i=0; i < ARR_SIZE; i++) {
		*(*s[2].set + i) = s_tmp[i];
	}

	return 0;
}
int sub_set(char **args, int *argsc, sets_arr *sets) {
	int i, j;
	set s_tmp={0};
	sets_arr s[3];

	if (*argsc > 3) {
		fprintf(stderr, "%s: too many arguments\n", __func__);
		return 1;
	}
	if (*argsc < 3) {
		fprintf(stderr, "%s: missing arguments\n", __func__);
		return 1;
	}

	for (i=0; i < *argsc; i++){
		for (j=0; sets[j].set != NULL; j++) {
			if (strcmp(args[i], sets[j].name) == 0) {
				break;
			}
		}

		s[i].set = sets[j].set;
		s[i].name = sets[j].name;
		if (sets[j].set == NULL) {
			fprintf(stderr, "%s:  Undefined set name: %s\n", __func__, args[i]);
			return 1;
		}
	}

	for (i=0; i < ARR_SIZE; i++) {
		s_tmp[i] = *(*s[0].set + i) - *(*s[1].set + i);
	}
	
	for (i=0; i < ARR_SIZE; i++) {
		*(*s[2].set + i) = s_tmp[i];
	}

	return 0;
}
int stop(void) {
	printf("Call stop\n");
	return 0;
}

int is_strint(char *str) {
	int c, i=0;
	c = str[i];
	while (c != '\0') {
		if (!(c >= '0' && c <= '9'))
			return 0;
		c = str[i++];
	}
	return 1;
}

/* Add element to set by
   setting k-th bit of the array to 1*/
void set_element(set SET, int k) {
	SET[k/INT_SIZE] |= 1 << (k%INT_SIZE);
}

/* Remove elemet from set by setting k-th bit of the array to 0*/
void del_element(set SET, int k) {
	SET[k/INT_SIZE] &= ~(1 << (k%INT_SIZE));
}

/* Check whether k is element of SET */
short get_element(set SET, int k) {
	if ( (SET[k/INT_SIZE]) & (1 << (k%INT_SIZE)) ) {
		return 1;
	}
	else {
		return 0;
	}
}