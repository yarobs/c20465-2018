#include <stdio.h>
#include "set.h"

int read_set(char *args, sets_arr *sets) {
	printf("Call read_set with args: %s\n", args);
	printf("Read: set 0: %s\n", sets[0].name);
	return 0;
}
int print_set(void) {
	return 0;
}
int union_set(void) {
	return 0;
}
int intersect_set(void) {
	return 0;
}
int sub_set(void) {
	return 0;
}
int stop(void) {
	printf("Call stop\n");
	return 0;
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