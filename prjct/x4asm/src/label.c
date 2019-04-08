/*
* Created by inna on 8/18/18.
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/*#include "x4asm.h"*/
#include "label.h"
#include "parser.h"

/*
 * creates label and appends it to symbol table
 */
void add_label(char *name, label_type t){
    label *l;

    l = (label *)malloc(sizeof(label));
    if (!l) die("FATAL ERROR: malloc failed");

    /*l->name = (char *)malloc(sizeof(char) * strlen(name));*/
    l->name = name;
    l->type = t;
    l->entry = FALSE;

    switch(t) {
        case DATA_L: {l->value = DC; break;}
        case CODE_L: {l->value = IC; break;}
        case EXTERNAL_L: {l->value = 0; break;}
        default: l->value = 0;
    }

    append_label(&SYMBOL_TABLE, l);
}

int append_label(label **head, label *l){
    label *tmp;
    if (*head == NULL) {
        *head = l;
        return 1;
    }
    for (tmp = *head; tmp->next != NULL; tmp = tmp->next){
        if (!(strcmp(tmp->name, l->name))) { /* label already in use */
            print_err(ERR_NONFATAL, "duplicate label `%s' defined", l->name);
            return 1;
        }
    }
    tmp->next = l;
    return 0;
}

void push_label (label **head, label *l) {
    if (*head == NULL) {
        *head = l;
    } else {
        l->next = *head;
        *head = l;
    }
}

/*
 * checks if we have label on line
 */
char *check_for_label() {
    int i = 0;
    int line_l;
    char c;
    char *label;
    line_l = (int) strlen(LINE);

    label = malloc(line_l * sizeof(char));
    if (!label) print_err(ERR_FATAL, "failed to allocate memory");

    c = in_line_ptr[i];
    while (c != ':') {
        if (i < line_l) {
            label[i++] = c;
        } else {
            return NULL;
        }
        c = in_line_ptr[i];

    }
    c = in_line_ptr[++i]; /* eat the colon */
    in_line_ptr += i;
    INP_LINE_POS += i;
    return label;
}

/*
 * validate label name
 */
int valid_label(char *l) {
    int lbl_l, i = 0;
    /*int reserved_num = sizeof(RESERVED_KEYWORDS) / sizeof(*RESERVED_KEYWORDS);*/

    lbl_l = (int) strlen(l);

    while (i < lbl_l) {
        if (isalnum(l[i++]) && i <= MAX_LBL_SIZE) {
            continue;
        }
        else if (i > MAX_LBL_SIZE) {
            print_err(ERR_NONFATAL, "label `%s' is longer then %d characters", l, MAX_LBL_SIZE);
            return FALSE;
        }
        else {
            print_err(ERR_NONFATAL, "invalid label name: `%s'", l);
            return FALSE;
        }
    }

    for (i=0; i < NRESERVED; i++) {
        if (!strcmp(l, RESERVED_KEYWORDS[i])) {
            print_err(ERR_NONFATAL, "label name `%s' is a reserved keyword", l);
            return FALSE;
        }
    }

    return TRUE;
}

/*
 * extracts label from entry directive
 */
char *get_entry_label() {
    int i = 0,len;
    char *l;
    char c;
    len = (int) strlen(in_line_ptr);
    l = malloc(sizeof(char) * len);
    c = in_line_ptr[i];

    while(c != ' ' && c != '\t' && c != '\0') {
        l[i++] = c;
        c = in_line_ptr[i];
    }
    l[i] = '\0';

    in_line_ptr += i;
    if (is_junk()) return NULL;

    return l;
}

void set_entry_label(char *name){
    label *l = SYMBOL_TABLE;

    while(l) {
        if (!(strcmp(name, l->name))) {
            l->entry = TRUE;
            ENTRIES_DEF = TRUE;
            return;
        }
        l = l->next;
    }

    print_err(ERR_WARNING, "entry label is declared but udefined: `%s'", name);

}

bool is_label(char * name) {
    int i;

    if (*name == '#') return FALSE;

    for (i = 0; i < NREGS; i++) {
        if (!(strcmp(name, REGISTERS_LIST[i]))) return FALSE;
    }
    return TRUE;
}
