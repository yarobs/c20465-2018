/*
 Created by inna on 7/28/18.
*/

#include "x4asm.h"

#ifndef X4ASM_ASSEMBLER_H
#define X4ASM_ASSEMBLER_H

#define SRC_F_ ".as"
#define OBJ_F_ ".ob"
#define EXT_F_ ".ext"
#define ENT_F_ ".ent"

#define M_ZRO 0x2E /* machine's code 0 - '.' */
#define M_ONE 0x2F /* machine's code 1 - '/' */

#define CODE_MEM_OFFSET 100 /* Code segment starting address */

struct reg_t { /* representing register */
    char *name;
    register_v r; /* value of the register: from 0 to 7 */
};

struct extern_ref_t { /* represent external variables references in assembly code */
    char *name;
    int addr; /* operand address which access the given external variable */
    struct extern_ref_t *next;
};

#endif /*X4ASM_ASSEMBLER_H*/

/* Functions prototypes */

void assemble();
void init();
void pass(FILE *f, void (*func)(), char *line);
void make_files();
char *get_line(FILE *f, char *line);
void add_extern_ref(char *name, int addr);
void append_extern(extern_ref **head, extern_ref *e);
void update_labels(label *s);
void update_data_seg(data *d);
void update_code_seg(char *l_name, int addr);
operand analyze_op(char *name, bool param);
operand analyze_p_op(char *name);
register_v is_register(char *name);
char getMbit(unsigned num, int bit);
int getNthbit(unsigned num, int bit);
void print_bits(unsigned num);
void print_symbol(label *l);
void print_symbol_table(label *l);
void print_code_word(code *c);
void print_code_table(code *c);
void print_data_word(data *d);
void print_data_table(data *d);
void fprint_data_word(FILE *, data *d);
void fprint_data_table(FILE *, data *d);
void print_xcode_word(code_seg *s);
void print_xcode_table(code_seg *s);
void print_extern_ref(extern_ref *e);
void print_extern_ref_list(extern_ref *head);
void fprint_extern_ref(FILE *, extern_ref *);
void fprint_extern_ref_list(FILE *, extern_ref *);
void print_entries(label *head);
void fprint_entries(FILE *, label *head);
void fprint_bits(FILE *, unsigned);
void fprint_xcode_word(FILE *f, code_seg *s);
void fprint_xcode_table(FILE *f, code_seg *s);
char *ltype2str(label_type t);
void init_fnames(const char *name);
void print_code_bits(instruction_word c);
void print_data_bits(data_word d);