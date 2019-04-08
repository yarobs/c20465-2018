#ifndef X4ASM_PARSER_H
#define X4ASM_PARSER_H
#include "x4asm.h"
#define IN  1
#define OUT 0

void parse_in_line();
void parse_in_line_2();

int is_junk();
void skip_whitespaces();
char *get_dir(const char *dir_type);
char *get_instruction();
int parse_data_param();
int parse_str_param();
int parse_extern_param();
char get_escape_seq(char c);
int parse_instruction(char *name, bool pass2);
void parse_operands(opcode op, bool pass2);


char *get_op0();
char *get_op1();
char *get_op_p(char *op, char **p);
char *get_param1(char *op, char **p);
char *get_param2(char *op, char **p);
int is_op_params(char *op);
int valid_int(char *s);
int validate_cat1_ops(operand op1, operand op2, instruction inst);


int handle_ops0(instruction inst);
int handle_ops1(instruction inst);
int handle_ops2(instruction inst);
int handle2_ops0(instruction inst);
int handle2_ops1(instruction inst);

#endif /*X4ASM_PARSER_H*/
