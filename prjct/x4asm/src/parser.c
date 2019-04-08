#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <assert.h>
#include "label.h"
#include "x4encode.h"
#include "parser.h"

/*
 * parses line in pass 1
 */
void parse_in_line() {
    char *current_label = NULL, *current_dir = NULL, *current_instruction = NULL;

    if (isalpha(*in_line_ptr)) {
        if ((current_label = check_for_label()) != NULL) {
            if (!valid_label(current_label)) return;
            status.LBL = 1;
        }
    }

    skip_whitespaces();

    if (*in_line_ptr == '.') {
        if ((current_dir = get_dir(".data")) || (current_dir = get_dir(".string"))) {
            skip_whitespaces();
            if (status.LBL) {
                add_label(current_label, DATA_L);
            }

            if (!strcmp(current_dir, ".data")) {
                parse_data_param();
            } else {
                parse_str_param();
            }

        } else if ((current_dir = get_dir(".extern")) || (current_dir = get_dir(".entry"))) {
            skip_whitespaces();
            if (status.LBL) {
                /*printf("warning: no meaning of the label: %s\n", LINE);*/
                print_err(ERR_WARNING, "label has no meaning: %s", current_label);
            }

            if (!strcmp(current_dir, ".extern")) {
                parse_extern_param();
            }
        } else {
            /*fprintf(stderr, "%d:%d: error: unknown directive specifier\n%s\n", NLINES, INP_LINE_POS, LINE);
            status.ERR = 1;*/
            print_err(ERR_NONFATAL, "unknown directive specifier: `%s'", in_line_ptr);
            return;
        }

    } else if (*in_line_ptr >= 'a' && *in_line_ptr <= 'z') {
        if (status.LBL) {
            add_label(current_label, CODE_L);
        }
        if (!(current_instruction = get_instruction())){
            /*fprintf(stderr, "%d:%d: error: unknown instruction name: %s\n", NLINES, INP_LINE_POS, in_line_ptr);
            status.ERR = 1;*/
            print_err(ERR_NONFATAL, "unknown instruction: %s", in_line_ptr);
            return;
        } else {
            skip_whitespaces();
            parse_instruction(current_instruction, FALSE);
        }
    } else if (*in_line_ptr != '\0') {
        /*fprintf(stderr, "%d:%d: error: unrecognized char at the start of line: %s\n", NLINES, INP_LINE_POS, in_line_ptr);
        status.ERR  = 1;*/
        print_err(ERR_NONFATAL, "unexpected start of line: %s", in_line_ptr);
        return;
    }
}

/*
 * parses line in pass2
 */
void parse_in_line_2() {
    char *label;
    char *inst;

    check_for_label(); /* skip label */
    skip_whitespaces();

    if (*in_line_ptr == '.') {
        if (get_dir(".entry")) {
            skip_whitespaces();
            if (!(label = get_entry_label())) return;
            set_entry_label(label);
            return;
        } else return;
    }

    inst = get_instruction();
    skip_whitespaces();

    parse_instruction(inst, TRUE);
    IC++;

}

/*
 * checks if there is junk at end of line
 */
int is_junk() {
    while (*in_line_ptr != '\n' && *in_line_ptr != '\0') {
        if (*in_line_ptr == ' ' || *in_line_ptr == '\t') {
            skip_whitespaces();
            continue;
        } else {
            print_err(ERR_NONFATAL, "junk at the end of line: `%s'", in_line_ptr);
            status.ERR = 1;
            return TRUE;
        }
    }
    return FALSE;
}


void skip_whitespaces(){

    while (*in_line_ptr == ' ' || *in_line_ptr == '\t') {
        in_line_ptr++;
        INP_LINE_POS++;
    }
}

/*
 * returns pointer to directive name
 */
char *get_dir (const char *dir_type) {
    char *dir;
    char *line_copy;

    /* we don't want to modify original line */
    line_copy = malloc(MAX_LINE_SIZE * sizeof(char));
    if (!line_copy) print_err(ERR_FATAL, "failed to allocate memory");

    strcpy(line_copy, in_line_ptr);
    dir = strtok(line_copy, " ");
    if (!strcmp(dir, dir_type)) {
        in_line_ptr += strlen(dir);
        INP_LINE_POS += strlen(dir);
        return dir;
    }
    return NULL;
}

/*
 * returns pointer to instruction name
 */
char *get_instruction(){
    int i;
    char *inst;
    char *line_copy;

    line_copy = malloc(MAX_LINE_SIZE * sizeof(char));
    if (!line_copy) print_err(ERR_FATAL, "failed to allocate memory");

    strcpy(line_copy, in_line_ptr);
    inst = strtok(line_copy, " ");
    for (i = 0; i < NINST; i++) {
        if (!strcmp(inst, INSTRUCTIONS_LIST[i])) {
            in_line_ptr += strlen(inst);
            INP_LINE_POS += strlen(inst);
            return inst;
        }
    }

    return NULL;
}

/*
 * parses and encodes .data directive parameters
 */
int parse_data_param() {

    int i = 0, k = 0, comma = IN, state = OUT;
    char c = in_line_ptr[i];
    char *num;

    if (!isdigit(c) && c != '-') {
        print_err(ERR_NONFATAL, "unexpected `%c' after `.data'", c);
        return 1;
    }

    num = (char *)malloc(sizeof(char) * 6);
    if (!num) print_err(ERR_FATAL, "failed to allocate memory");

    while (c != '\0') {
        if ((c >= '0' && c <= '9') || c == '-' || c == '+') {
            if (comma == OUT) {
                print_err(ERR_NONFATAL, "comma is expected after `%s'", num);
                return 1;
            }
            if (state == IN && (c == '-' || c == '+')) {
                print_err(ERR_NONFATAL, "unexpected `%c' or missing comma", c);
                return 1;
            }
            num[k++] = c;
            state = IN;
        } else if (c == ' ' || c == '\t') {
            if (state) comma = OUT;
        } else if (c == ',') {
            num[k] = '\0';
            k = 0;
            comma = IN;
            state = OUT;
            encode_data(num, NUM);
        } else {
            print_err(ERR_NONFATAL, "unexpected `%c' in `.data'", c);
            return 1;
        }

        c = in_line_ptr[++i];
        INP_LINE_POS += i;
    }

    num[k] = '\0';
    if (strlen(num) > 0) {
        encode_data(num, NUM);
    } else {
        print_err(ERR_NONFATAL, "comma at the end of line");
        return 1;
    }
    return 0;
}

/*
 * parses and encodes string directive parameter
 */
int parse_str_param(){
    int i = 0, k = 0, len, data_l;
    char c = in_line_ptr[i];
    char *str;
    len = (int) strlen(in_line_ptr);
    str = (char *)malloc(sizeof(char) * len);

    if (c != '"') {
        print_err(ERR_NONFATAL, "string does not start with `\"' ");
        return 1;
    } else c = in_line_ptr[++i];

    while (c != '"' && i <= len) {
        if (c == 92) { /* got \, handle escape char*/
            if (!(c = get_escape_seq(in_line_ptr[++i]))) {
                c = in_line_ptr[i];
                print_err(ERR_WARNING, "unknown escape sequence: `\\%c'", c);
            }
        }
        str[k++] = c;
        c = in_line_ptr[++i];
    }
    INP_LINE_POS += i;
    str[k] = '\0';
    data_l = k;

    if (c != '"') {
        print_err(ERR_NONFATAL, "no terminating `\"' character at end of string");
        return 1;
    }

    if (++i < len) { /* There might be something after string ends */
        while (i < len) {
            c = in_line_ptr[i++];
            INP_LINE_POS++;
            if (c != ' ' && c != '\t') {
                print_err(ERR_NONFATAL, "unexpected character after end of string: `%c'", c);
                return 1;
            }
        }
    }

    for (i=0; i <= data_l; i++) {
        encode_data(&str[i], STR);
    }

    return 0;
}

int parse_extern_param() {
    int i = 0, k = 0, len;
    char c = in_line_ptr[i];
    char *lbl;
    len = (int) strlen(in_line_ptr);
    lbl = (char *) malloc(sizeof(char) * len);

    while ((c != ' ' && c != '\t' && c != '\0')) {
        lbl[k++] = c;
        c = in_line_ptr[++i];
    }
    lbl[k] = '\0';
    in_line_ptr += i;
    if (is_junk()) return FALSE;

    if(valid_label(lbl)) {
        INP_LINE_POS += i;
        add_label(lbl, EXTERNAL_L);
        return TRUE;
    }

    return FALSE;
}

char get_escape_seq(char c) {
    switch(c) {
        case 'a': return '\a';
        case 'b': return '\b';
        case 'f': return '\f';
        case 'n': return '\n';
        case 'r': return '\r';
        case 't': return '\t';
        case 'v': return '\v';
        case '\\': return '\\';
        case '\'': return '\'';
        case '"': return '\"';
        default:return 0;
    }
}

int parse_instruction(char *name, bool pass2) {
    int i;
    opcode opcode = {0};

    for (i = 0; i < NINST; i++) {
        if (strcmp(name, opcodes[i].name) == 0) {
            opcode = opcodes[i];
            break;
        }
    }

    parse_operands(opcode, pass2);

    return 0;
}

void parse_operands(opcode op, bool pass2) {
    switch(pass2) {
        case FALSE: {		/* in pass 1 parse all instructions */
            switch (op.type) {
                case TWOOPS: {
                    handle_ops0(op.code);
                    break;
                }
                case ONEOP: {
                    handle_ops1(op.code);
                    break;
                }
                case NOOPS: {
                    handle_ops2(op.code);
                    break;
                }
            }
            break;
        }
        case TRUE: {		/* in pass 2 only with operands */
            switch (op.type) {
                case TWOOPS: {
                    handle2_ops0(op.code);
                    break;
                }
                case ONEOP: {
                    handle2_ops1(op.code);
                    break;
                }
                default: break;
            }
            break;
        }
    }
}

/*
 * returns operand 1 (src operand)
 */
char *get_op0(){
    /* TODO: add op length validation */
    int i = 0, k = 0;
    char c;
    char *op;
    op = malloc(sizeof(char) * 30);

    c = in_line_ptr[i];

    while (c != ',' && c != '\0') {
        if (c != ' ' && c != '\t') {
            op[k++] = c;
        } else {
            break;
        }
        c = in_line_ptr[++i];
    }
    op[k] = '\0';
    in_line_ptr += i;
    skip_whitespaces();

    if (k == 0) return NULL;

    return op;
}

/*
 * returns operand 2 (dst operand)
 */
char *get_op1() {
    /* TODO: add op length validation */

    int i = 0, k = 0;
    char c;
    char *op;
    op = malloc(sizeof(char) * 30);

    c = in_line_ptr[i];

    while (c != '\0') {
        if (c != ' ' && c != '\t') {
            op[k++] = c;
        } else {
            break;
        }
        c = in_line_ptr[++i];
    }
    op[k] = '\0';
    in_line_ptr += i;
    skip_whitespaces();

    if (k == 0) return NULL;

    return op;
}

/*
 * returns operand part of of operand with parameters
 */
char *get_op_p(char *op, char **p) {
    int i = 0;
    char *result;
    result = malloc(sizeof(char) * 30);
    if (!result) print_err(ERR_FATAL, "failed to allocate memory");

    while (*op != '(') {
        result[i] = *op;
        i++;
        op++;
    }
    *p = op;
    result[i] = '\0';
    return result;
}

/*
 * returns first parameter of operand of kind 2
 */
char *get_param1(char *op, char **p) {
    int i = 0;
    char *result;
    result = malloc(sizeof(char) * 30);
    if (!result) print_err(ERR_FATAL, "failed to allocate memory");

    op++; /* eat the '(' */
    while(*op != ',') {
        if (*op == '\0') break;
        result[i] = *op;
        i++;
        op++;
    }
    *p = op;
    result[i] = '\0';

    if (*op != ',') {
        print_err(ERR_NONFATAL, "comma expected after first parameter: `%s'", result);
        return NULL;
    }

    return result;
}

/*
 * returns second parameter of operand of kind 2
 */
char *get_param2(char *op, char **p) {
    int i = 0;
    char *result;
    result = malloc(sizeof(char) * 30);
    if (!result) print_err(ERR_FATAL, "failed to allocate memory");

    op++; /* eat the ',' */
    while(*op != ')') {
        if (*op == '\0') break;
        result[i] = *op;
        i++;
        op++;
    }
    *p = op;
    result[i] = '\0';
    if (*op != ')') {
        print_err(ERR_NONFATAL, "expected ')' before end of line: `%s'", result);
        return NULL;
    }
    return result;
}

/*
 * Checks whether operand has parameters
 */
int is_op_params(char *op) {
    int i = 0;
    char c;

    while ((c = op[++i]) != '\0') {
        if (c == '(') {
            return TRUE;
        }
    }

    return FALSE;
}

int valid_int(char *s) {
    int i = 0, state = OUT;
    while (s[i] != '\0') {
        if ((isdigit(s[i]) || s[i] =='-' || s[i] == '+') && state == OUT) {
            state = IN;
        } else if ((state == IN && !isdigit(s[i])) || !isdigit(s[i])) {
            print_err(ERR_NONFATAL, "invalid integer operand: `%s'", s);
            return FALSE;
        }
        i++;
    }

    return TRUE;
}

/*
 * validates instructions of category 1 operands
 */
int validate_cat1_ops(operand op1, operand op2, instruction inst) {
    assert(inst == MOV || inst == CMP || inst == ADD || inst == SUB || inst == LEA);

    if (op1.mode == INDIRECT) {
        print_err(ERR_NONFATAL, "invalid operand `%s' for `%s' instruction",
                  op1.name, INSTRUCTIONS_LIST[inst]);
    }
    if (op2.mode == INDIRECT) {
        print_err(ERR_NONFATAL, "invalid operand `%s' for `%s' instruction",
                  op2.name, INSTRUCTIONS_LIST[inst]);
    }
    if (inst == LEA && op1.mode != DIRECT) {
        print_err(ERR_NONFATAL, "invalid operand `%s' for `%s' instruction",
                  op1.name, INSTRUCTIONS_LIST[inst]);
    }
    if (inst != CMP && op2.mode == IMMEDIATE) {
        print_err(ERR_NONFATAL, "invalid operand `%s' for `%s' instruction",
                  op2.name, INSTRUCTIONS_LIST[inst]);
    }

    if (status.ERR) {
        return FALSE;
    } else {
        return TRUE;
    }
}
