/*
* Created by yarob on 8/18/18.
*/
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include "x4asm.h"

void die(const char *msg){
    if (*msg != '\0') {
        fprintf(stderr, "%s: %s\n",PROG_NAME, msg);
    }
    exit(EXIT_FAILURE);
}

void print_err(err_severity severity, char *fmt, ...){
    va_list vargs;

    switch(severity) {
        case ERR_SYS: {
            fprintf(stderr, "%s: ", PROG_NAME);
            break;
        }
        case ERR_FATAL: {
            fprintf(stderr, "%s: fatal: ", PROG_NAME);
            break;
        }
        case ERR_NONFATAL: {
            fprintf(stderr, "%s:%d:%d: error: ", SRC_F, NLINES, INP_LINE_POS);
            status.ERR = TRUE;
            break;
        }
        case ERR_WARNING: {
            fprintf(stderr, "%s:%d:%d: warning: ", SRC_F, NLINES, INP_LINE_POS);
            status.WRN = TRUE;
            break;
        }
        default: break;
    }

    va_start(vargs, fmt);
    vfprintf(stderr, fmt, vargs);
    fputc('\n', stderr);

    if (severity == ERR_FATAL) {
        die("");
    }
}

