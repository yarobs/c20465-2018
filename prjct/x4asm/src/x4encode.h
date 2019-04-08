/*
* Created by yarob on 8/18/18.
*/

#ifndef X4ASM_X4ENCODE_H
#define X4ASM_X4ENCODE_H
#include "x4asm.h"

int encode_data(char *n, data_type t);
int encode_code_word(int n, code_word_type t);

int xencode_code_word(operand srcop, operand dstop, instruction inst);
int xencode_param_code_word(operand op, operand p1, operand p2, instruction inst);

void append_code(code **head, code *c);
void xappend_code(code_seg **head, code_seg *s);
void push_code(code **head, code *c);

#endif /*X4ASM_X4ENCODE_H*/
