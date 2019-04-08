/*
* Created by inna on 8/18/18.
*/

/*#include "assembler.h"*/
#include "x4asm.h"

#ifndef X4ASM_LABEL_H
#define X4ASM_LABEL_H

struct label_t { /* represent label in our assembly */
    char *name;
    label_type type;
    int value;
    bool entry; /* is label entry */
    struct label_t *next;
};

void add_label(char *name, label_type t);
int append_label(label **head, label *l);
void push_label(label **head, label *l);
char *check_for_label();
int valid_label(char *l);
char *get_entry_label();
void set_entry_label(char *name);
bool is_label(char *name);

#endif /*X4ASM_LABEL_H*/
