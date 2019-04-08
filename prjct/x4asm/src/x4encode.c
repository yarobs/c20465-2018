#include <assert.h>
#include <stdlib.h>
#include "data.h"
#include "x4encode.h"

/*
 * encodes given data (chars or integers) to code word and adds it to data list
 */
int encode_data (char *n, data_type t){
    int num;
    data_word dw;
    data *d;
    dw.data = 0;
    num = (t == NUM) ? atoi(n) : *n;

    if (t == NUM && (num < -8191 || num > 8191)) { /* we can hold only 14bit integer*/
        print_err(ERR_WARNING, "overflow in implicit conversion of `%d'", num);
    }

    dw.data |= num;
    d = (data *)malloc(sizeof(data));
    if (!d) die("FATAL: malloc failed");

    d->word = dw;
    d->addr = DC;
    d->next = NULL;
    DC++;
    append_data(&DATA_LIST, d);

    return 0;
}

/*
 * DEPRECATED
 */
int encode_code_word(int n, code_word_type t) {
    instruction_word iw = {0};
    code *c = NULL;

    c = (code *)malloc(sizeof(code));
    if (!c) die("FATAL: malloc failed");

    iw.opcode |= n;
    c->word = iw;
    c->addr = IC;
    c->next = NULL;
    IC++;
    append_code(&CODE_TABLE, c);

    return 0;
}

/*
 * encodes instruction and its operands to code words and adds them to code list
 */
int xencode_code_word(operand srcop, operand dstop, instruction inst) {
    code_w w1 = {{0}};
    instruction_word iw = {0};
    code_seg *s1 = NULL;

    assert(!(srcop.name && !dstop.name));

    s1 = (code_seg *)malloc(sizeof(code_seg));
    if (!s1) print_err(ERR_FATAL, "failed to allocate memory");

    /* prepare the instruction word */
    iw.are = ABS;
    iw.opcode |= inst;
    iw.are = 0;
    iw.dst_op_addr = dstop.mode;
    iw.src_op_addr = srcop.mode;
    iw.param_2 = dstop.param;
    iw.param_1 = srcop.param;

    w1.i = iw; /* copy the instruction word to code segment word */

    /* add the word to list */
    s1->name = INSTRUCTIONS_LIST[inst];
    s1->srcop = srcop.name;
    s1->dstop = dstop.name;
    s1->word = w1;
    s1->addr = IC;
    s1->next = NULL;
    IC++;
    xappend_code(&CODE_SEG_LIST, s1);

    if (srcop.name && dstop.name) {

        if (srcop.mode == REGDIRECT && dstop.mode == REGDIRECT) {
            code_w w2 = {{0}};
            register_op_w opw = {0};
            code_seg *s2 = NULL;
            s2 = (code_seg *)malloc(sizeof(code_seg));
            if (!s2) print_err(ERR_FATAL, "failed to allocate memory");

            opw.are = 0;
            opw.dstreg = dstop.value;
            opw.srcreg = srcop.value;
            w2.r = opw;
            s2->word = w2;
            s2->addr = IC;
            s2->next = NULL;
            IC++;
            xappend_code(&CODE_SEG_LIST, s2);
            return 0;
        }
        if (srcop.mode == DIRECT && dstop.mode == DIRECT) {
            code_w w2 = {{0}}, w3 = {{0}};
            other_op_w opw = {0};
            code_seg *s2 = NULL, *s3 = NULL;
            s2 = (code_seg *)malloc(sizeof(code_seg));
            if (!s2) print_err(ERR_FATAL, "failed to allocate memory");
            s3 = (code_seg *)malloc(sizeof(code_seg));
            if (!s3) print_err(ERR_FATAL, "failed to allocate memory");

            w2.o = opw;
            s2->word = w2;
            s2->addr = IC;
            s2->next = NULL;
            IC++;
            xappend_code(&CODE_SEG_LIST, s2);
            w3.o = opw;
            s3->word = w3;
            s3->addr = IC;
            s3->next = NULL;
            IC++;
            xappend_code(&CODE_SEG_LIST, s3);
            return 0;
        }
        if (srcop.mode == IMMEDIATE) {
            code_w w2 = {{0}};
            other_op_w opw = {0};
            code_seg *s2 = NULL;
            s2 = (code_seg *)malloc(sizeof(code_seg));
            if (!s2) print_err(ERR_FATAL, "failed to allocate memory");

            opw.are = 0;
            opw.val = srcop.value;
            w2.o = opw;
            s2->word = w2;
            s2->addr = IC;
            s2->next = NULL;
            IC++;
            xappend_code(&CODE_SEG_LIST, s2);
        } else if (srcop.mode == DIRECT) {
            code_w w2 = {{0}};
            other_op_w opw = {0};
            code_seg *s2 = NULL;
            s2 = (code_seg *)malloc(sizeof(code_seg));
            if (!s2) print_err(ERR_FATAL, "failed to allocate memory");

            w2.o = opw;
            s2->word = w2;
            s2->addr = IC;
            s2->next = NULL;
            IC++;
            xappend_code(&CODE_SEG_LIST, s2);
        } else if (srcop.mode == REGDIRECT) {
            code_w w2 = {{0}};
            register_op_w opw = {0};
            code_seg *s2 = NULL;
            s2 = (code_seg *)malloc(sizeof(code_seg));
            if (!s2) print_err(ERR_FATAL, "failed to allocate memory");

            opw.are = 0;
            opw.dstreg = 0;
            opw.srcreg = srcop.value;
            w2.r = opw;
            s2->word = w2;
            s2->addr = IC;
            s2->next = NULL;
            IC++;
            xappend_code(&CODE_SEG_LIST, s2);
        }
        if (dstop.mode == IMMEDIATE) {
            code_w w3 = {{0}};
            other_op_w opw = {0};
            code_seg *s3 = NULL;
            s3 = (code_seg *)malloc(sizeof(code_seg));
            if (!s3) print_err(ERR_FATAL, "failed to allocate memory");

            assert(inst == CMP);

            opw.are = 0;
            opw.val = dstop.value;
            w3.o = opw;
            s3->word = w3;
            s3->addr = IC;
            s3->next = NULL;
            IC++;
            xappend_code(&CODE_SEG_LIST, s3);
        } else if (dstop.mode == DIRECT) {
            code_w w3 = {{0}};
            other_op_w opw = {0};
            code_seg *s3 = NULL;
            s3 = (code_seg *)malloc(sizeof(code_seg));
            if (!s3) print_err(ERR_FATAL, "failed to allocate memory");

            w3.o = opw;
            s3->word = w3;
            s3->addr = IC;
            s3->next = NULL;
            IC++;
            xappend_code(&CODE_SEG_LIST, s3);
        } else if (dstop.mode == REGDIRECT) {
            code_w w3 = {{0}};
            register_op_w opw = {0};
            code_seg *s3 = NULL;
            s3 = (code_seg *)malloc(sizeof(code_seg));
            if (!s3) print_err(ERR_FATAL, "failed to allocate memory");

            opw.are = 0;
            opw.dstreg = dstop.value;
            opw.srcreg = 0;
            w3.r = opw;
            s3->word = w3;
            s3->addr = IC;
            s3->next = NULL;
            IC++;
            xappend_code(&CODE_SEG_LIST, s3);
        }
    } else if (dstop.name) {
        if (dstop.mode == IMMEDIATE) {
            code_w w2 = {{0}};
            other_op_w opw = {0};
            code_seg *s2 = NULL;
            s2 = (code_seg *)malloc(sizeof(code_seg));
            if (!s2) print_err(ERR_FATAL, "failed to allocate memory");

            assert(inst == PRN);

            opw.are = 0;
            opw.val = dstop.value;
            w2.o = opw;
            s2->word = w2;
            s2->addr = IC;
            s2->next = NULL;
            IC++;
            xappend_code(&CODE_SEG_LIST, s2);
        } else if (dstop.mode == DIRECT) {
            code_w w2 = {{0}};
            other_op_w opw = {0};
            code_seg *s2 = NULL;
            s2 = (code_seg *)malloc(sizeof(code_seg));
            if (!s2) print_err(ERR_FATAL, "failed to allocate memory");

            w2.o = opw;
            s2->word = w2;
            s2->addr = IC;
            s2->next = NULL;
            IC++;
            xappend_code(&CODE_SEG_LIST, s2);
        } else if (dstop.mode == REGDIRECT) {
            code_w w2 = {{0}};
            register_op_w opw = {0};
            code_seg *s2 = NULL;
            s2 = (code_seg *)malloc(sizeof(code_seg));
            if (!s2) print_err(ERR_FATAL, "failed to allocate memory");

            opw.are = 0;
            opw.dstreg = dstop.value;
            opw.srcreg = 0;
            w2.r = opw;
            s2->word = w2;
            s2->addr = IC;
            s2->next = NULL;
            IC++;
            xappend_code(&CODE_SEG_LIST, s2);
        }
    }

    return 0;
}

/*
 * encodes instruction and operands with parameters
 */
int xencode_param_code_word(operand op, operand p1, operand p2, instruction inst){
    code_w w1 = {{0}}, w2 = {{0}};
    instruction_word iw = {0};
    other_op_w opw1 = {0};
    code_seg *s1 = NULL, *s2 = NULL;


    s1 = (code_seg *)malloc(sizeof(code_seg));
    if (!s1) print_err(ERR_FATAL, "failed to allocate memory");
    s2 = (code_seg *)malloc(sizeof(code_seg));
    if (!s2) print_err(ERR_FATAL, "failed to allocate memory");

    /* prepare the instruction */
    iw.are = ABS;
    iw.opcode |= inst;
    iw.are = 0;
    iw.dst_op_addr = op.mode;
    iw.src_op_addr = 0;
    iw.param_2 = p2.param;
    iw.param_1 = p1.param;

    w1.i = iw; /* copy the instruction word to code segment word */

    /* add the word to list */
    s1->name = INSTRUCTIONS_LIST[inst];
    s1->srcop = NULL;
    s1->dstop = op.name;
    s1->word = w1;
    s1->addr = IC;
    s1->next = NULL;
    IC++;
    xappend_code(&CODE_SEG_LIST, s1);

    w2.o = opw1;
    s2->name = op.name;
    s2->word = w2;
    s2->addr = IC;
    s2->next = NULL;
    IC++;
    xappend_code(&CODE_SEG_LIST, s2);

    if (p1.mode == REGDIRECT && p2.mode == REGDIRECT) {
        code_w w3 = {{0}};
        register_op_w opw2 = {0};
        code_seg *s3 = NULL;
        s3 = (code_seg *)malloc(sizeof(code_seg));
        if (!s3) print_err(ERR_FATAL, "failed to allocate memory");

        opw2.are = 0;
        opw2.dstreg = p2.value;
        opw2.srcreg = p1.value;
        w3.r = opw2;
        s3->word = w3;
        s3->addr = IC;
        s3->next = NULL;
        IC++;
        xappend_code(&CODE_SEG_LIST, s3);
        return 0;
    }
    if (p1.mode == DIRECT && p2.mode == DIRECT) {
        code_w w3 = {{0}}, w4 = {{0}};
        other_op_w opw3 = {0}, opw4 = {0};
        code_seg *s3 = NULL, *s4 = NULL;
        s3 = (code_seg *)malloc(sizeof(code_seg));
        if (!s3) print_err(ERR_FATAL, "failed to allocate memory");
        s4 = (code_seg *)malloc(sizeof(code_seg));
        if (!s4) print_err(ERR_FATAL, "failed to allocate memory");

        w3.o = opw3;
        s3->word = w3;
        s3->addr = IC;
        s3->next = NULL;
        IC++;
        xappend_code(&CODE_SEG_LIST, s3);
        w4.o = opw4;
        s4->word = w4;
        s4->addr = IC;
        s4->next = NULL;
        IC++;
        xappend_code(&CODE_SEG_LIST, s4);
        return 0;
    }
    if (p1.mode == IMMEDIATE) {
        code_w w3 = {{0}};
        other_op_w opw3 = {0};
        code_seg *s3 = NULL;
        s3 = (code_seg *)malloc(sizeof(code_seg));
        if (!s3) print_err(ERR_FATAL, "failed to allocate memory");

        opw3.are = 0;
        opw3.val = p1.value;
        w3.o = opw3;
        s3->word = w3;
        s3->addr = IC;
        s3->next = NULL;
        IC++;
        xappend_code(&CODE_SEG_LIST, s3);
    } else if (p1.mode == DIRECT) {
        code_w w3 = {{0}};
        other_op_w opw3 = {0};
        code_seg *s3 = NULL;
        s3 = (code_seg *)malloc(sizeof(code_seg));
        if (!s3) print_err(ERR_FATAL, "failed to allocate memory");

        w3.o = opw3;
        s3->word = w3;
        s3->addr = IC;
        s3->next = NULL;
        IC++;
        xappend_code(&CODE_SEG_LIST, s3);
    } else if (p1.mode == REGDIRECT) {
        code_w w3 = {{0}};
        register_op_w opw3 = {0};
        code_seg *s3 = NULL;
        s3 = (code_seg *)malloc(sizeof(code_seg));
        if (!s3) print_err(ERR_FATAL, "failed to allocate memory");

        opw3.are = 0;
        opw3.dstreg = 0;
        opw3.srcreg = p1.value;
        w3.r = opw3;
        s3->word = w3;
        s3->addr = IC;
        s3->next = NULL;
        IC++;
        xappend_code(&CODE_SEG_LIST, s3);
    }
    if (p2.mode == IMMEDIATE) {
        code_w w4 = {{0}};
        other_op_w opw4= {0};
        code_seg *s4 = NULL;
        s4 = (code_seg *)malloc(sizeof(code_seg));
        if (!s4) print_err(ERR_FATAL, "failed to allocate memory");

        opw4.are = 0;
        opw4.val = p2.value;
        w4.o = opw4;
        s4->word = w4;
        s4->addr = IC;
        s4->next = NULL;
        IC++;
        xappend_code(&CODE_SEG_LIST, s4);
    } else if (p2.mode == DIRECT) {
        code_w w4 = {{0}};
        other_op_w opw4 = {0};
        code_seg *s4 = NULL;
        s4 = (code_seg *)malloc(sizeof(code_seg));
        if (!s4) print_err(ERR_FATAL, "failed to allocate memory");

        w4.o = opw4;
        s4->word = w4;
        s4->addr = IC;
        s4->next = NULL;
        IC++;
        xappend_code(&CODE_SEG_LIST, s4);
    } else if (p2.mode == REGDIRECT) {
        code_w w4 = {{0}};
        register_op_w opw4 = {0};
        code_seg *s4 = NULL;
        s4 = (code_seg *)malloc(sizeof(code_seg));
        if (!s4) print_err(ERR_FATAL, "failed to allocate memory");

        opw4.are = 0;
        opw4.dstreg = p2.value;
        opw4.srcreg = 0;
        w4.r = opw4;
        s4->word = w4;
        s4->addr = IC;
        s4->next = NULL;
        IC++;
        xappend_code(&CODE_SEG_LIST, s4);
    }

    return 0;
}


void append_code(code **head, code *c){
    code *tmp;
    if (*head == NULL) {
        *head = c;
        return;
    }
    for (tmp = *head; tmp->next != NULL; tmp = tmp->next);
    tmp->next = c;
}

void xappend_code(code_seg **head, code_seg *s){
    code_seg *tmp;
    if (*head == NULL) {
        *head = s;
        return;
    }
    for (tmp = *head; tmp->next != NULL; tmp = tmp->next);
    tmp->next = s;
}

void push_code(code **head, code *c) {
    if (*head == NULL) {
        *head = c;
    } else {
        c->next = *head;
        *head = c;
    }
}
