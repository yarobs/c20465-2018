/*
* Created by yarob on 8/18/18.
*/
#include "x4asm.h"
#ifndef X4ASM_DATA_H
#define X4ASM_DATA_H
struct data_word_t {
    unsigned int data : 14;
    unsigned int : 0;
};
struct data_t {
    data_word word;
    int addr;
    struct data_t *next;
};
void append_data(data **head, data *d);
void push_data(data **head, data *d);
#endif /*X4ASM_DATA_H*/
