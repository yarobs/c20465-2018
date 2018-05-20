#include "set.h"
#include "util.h"

/* Add element to set by
   setting k-th bit of the array to 1*/
void set_element(set SET , int k) {
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
