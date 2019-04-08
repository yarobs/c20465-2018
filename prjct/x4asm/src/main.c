/*
 * Inna Savchenko
 *
 * ID: 321444457
 */

#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include "assembler.h"
#include "x4asm.h"

const char *PROG_NAME;

int main(int argc, char **argv) {
    int i = 0;
    PROG_NAME = argv[0];

    if (argc < 2) die("missing arguments");

    for (i = 1; i < argc; i++) {
        init_fnames(argv[i]);
        assemble();
    }

    return status.ERR;
}

