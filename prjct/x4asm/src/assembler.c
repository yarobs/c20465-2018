/* This is assembler of an imaginary computer with 14 bit CPU.
 * It has 256 cells of RAM and 8 registers. The CPU
 * has 16 instructions. It can work with signed integer numbers and
 * ASCII set of characters.
 */
#include <assert.h>

#include <ctype.h>
#include <malloc.h>
#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "assembler.h"
#include "data.h"
#include "label.h"
#include "parser.h"
#include "x4encode.h"


const char *RESERVED_KEYWORDS[] = {"r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7",
								   "mov", "cmp", "add", "sub", "not", "clr", "lea", "inc",
								   "dec", "jmp", "bne", "red", "prn", "jsr", "rts", "stop",
								   "data", "entry", "extern", "string"};

const char *INSTRUCTIONS_LIST[] = {"mov", "cmp", "add", "sub", "not", "clr", "lea", "inc",
								   "dec", "jmp", "bne", "red", "prn", "jsr", "rts", "stop"};

const char *REGISTERS_LIST[] = {"r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7"};

opcode opcodes[] = { /* array of all known instructions with code and type */
		{"mov", MOV, TWOOPS}, {"cmp", CMP, TWOOPS}, {"add", ADD, TWOOPS}, {"sub", SUB, TWOOPS},
		{"not", NOT, ONEOP},  {"clr", CLR, ONEOP},  {"lea", LEA, TWOOPS}, {"inc", INC, ONEOP},
		{"dec", DEC, ONEOP},  {"jmp", JMP, ONEOP},  {"bne", BNE, ONEOP},  {"red", RED, ONEOP},
		{"prn", PRN, ONEOP},  {"jsr", JSR,ONEOP},   {"rts", RTS, NOOPS},  {"stop", STOP, NOOPS}
};

reg registers[] = {
		{"r0", R0}, {"r1", R1}, {"r2", R2}, {"r3", R3},
		{"r4", R4}, {"r5", R5}, {"r6", R6}, {"r0", R7}
};

char *in_line_ptr;        /* pointer to current position in input line as line is parsed*/
char *LINE;               /* original input line */
int NLINES;               /* number of lines */
int INP_LINE_POS;         /* current char number in line for use in error messages */
int NINST;                /* number of instructions */
int NREGS;                /* number of registers */
int NRESERVED;            /* number of reserved keywords */
char *SRC_F;              /* assembly source file name */
char *OBJ_F;              /* object file name */
char *ENT_F;              /* entries file name */
char *EXT_F;              /* external variables file name */
bool ENTRIES_DEF;         /* boolean to check if external defined*/

label *SYMBOL_TABLE;
data *DATA_LIST;          /* list of data words */
code *CODE_TABLE;         /* list of code words  */
code_seg *CODE_SEG_LIST;  /* list of code memory segment words */
extern_ref *EXTERN_REF_LIST;  /* list of external labels refernces */
status_flags status;

/*
 * runs pass1 and pass 2 over each input file
 */
void assemble() {
	void (*pass_one)() = &parse_in_line;
	void (*pass_two)() = &parse_in_line_2;
	char *line;
	FILE *f;

	line = malloc(sizeof(char) * MAX_LINE_SIZE);
	if (!line) print_err(ERR_FATAL, "failed to allocate memory");

	NINST = sizeof(INSTRUCTIONS_LIST) / sizeof(*INSTRUCTIONS_LIST);
	NREGS = sizeof(REGISTERS_LIST) / sizeof(*REGISTERS_LIST);
	NRESERVED = sizeof(RESERVED_KEYWORDS) / sizeof(*RESERVED_KEYWORDS);
	SYMBOL_TABLE = NULL;
	DATA_LIST = NULL;
	CODE_TABLE = NULL;
	CODE_SEG_LIST = NULL;
	ENTRIES_DEF = FALSE; /* set entries to FALSE until encounter with one */
	DC = 0;

	init();

	/*printf("src: %s\n", SRC_F);
	* printf("obj: %s\n", OBJ_F);
	* printf("ent: %s\n", ENT_F);
	* printf("ext: %s\n", EXT_F);
	*/

	f = fopen(SRC_F, "r");
	if (!f) {
		print_err(ERR_SYS, "Could not open file `%s': %s", SRC_F, strerror(errno));
		return;
	}

	printf("+++++++++++++ PASS 1 +++++++++++++: %s\n", SRC_F);
	pass(f, pass_one, line);

	if (status.ERR) {
		fclose(f);
		return;
	}

	update_labels(SYMBOL_TABLE);
	update_data_seg(DATA_LIST);

	rewind(f); /* rewind to beggining of file before pass 2 */
	init(); /* and init global counters */

	printf("+++++++++++++ PASS 2 +++++++++++++: %s\n", SRC_F);
	pass(f, pass_two, line);

	if (status.ERR) {
		fclose(f);
		return;
	}

	make_files(); /* generate all output files*/

    /*printf("\n\nError flag: %d; DC: %d; IC: %d; Lines: %d\n", status.ERR, DC, IC, NLINES);
    print_symbol_table(SYMBOL_TABLE);
    print_xcode_table(CODE_SEG_LIST);
    print_data_table(DATA_LIST);
    print_extern_ref_list(EXTERN_REF_LIST);
    print_entries(SYMBOL_TABLE);*/

	fclose(f);
}

void init(){
	status.ERR = 0;
	status.LBL = 0;
	status.WRN = 0;

	IC = CODE_MEM_OFFSET;

	NLINES = 0;
	INP_LINE_POS = 1;
}

/*
 *  Runs pass 1/2 on given file
 */
void pass(FILE *f, void (*func)(), char *line) {

	while ((line = get_line(f, line))) {

		in_line_ptr = line;
		LINE = line;
		NLINES++;
		skip_whitespaces();
		if (*in_line_ptr != '\0') {
			(func)();
		}

		INP_LINE_POS = 1;
		status.LBL = 0; /* Clear label status for next line */
	}

}

/*
 * Generates all output files
 */
void make_files(){
    /* TODO: add file close validations*/
	FILE *obj = fopen(OBJ_F, "w");

	fprint_xcode_table(obj, CODE_SEG_LIST);
	fprint_data_table(obj, DATA_LIST);
	if (fclose(obj) != 0) print_err(ERR_FATAL, "failed to save file: %s: %s", obj, strerror(errno));


	if (ENTRIES_DEF) {
		FILE *ent = fopen(ENT_F, "w");
		fprint_entries(ent, SYMBOL_TABLE);
		if (fclose(ent) != 0) print_err(ERR_FATAL, "failed to save file: %s: %s", ent, strerror(errno));
	}
	if (EXTERN_REF_LIST) {
		FILE *ext = fopen(EXT_F, "w");
		fprint_extern_ref_list(ext, EXTERN_REF_LIST);
		if (fclose(ext) != 0) print_err(ERR_FATAL, "failed to save file: %s: %s", ext, strerror(errno));
	}


}

/*
 * Returns pointer to line from file
 */
char *get_line(FILE *f, char *line) {

	int i=0;
	char c;

	while ((c= (char) fgetc(f)) != EOF && c != '\n') {
		if (i < MAX_LINE_SIZE) {
			if (c != ';') { /* grab everything that ios not comment */
				line[i++] = c;
			} else { /* otherwise fast forward till end of line*/
				while ((c= (char) fgetc(f)) != '\n' && c != EOF);
				break;
			}
		} else if (i == MAX_LINE_SIZE) {
			/* if the line is longer than allowed
			 * and its not comment or whitespaces, set error
			 * */
			while (c != '\n' && c != EOF) {
				/* allow  whites anywhere */
				if (c == ' ' || c == '\t') {
					c = (char) fgetc(f);
					continue;
				} else if (c == ';') { /* comments are allowed as well */
					while ((c = (char) fgetc(f)) != '\n' && c != EOF) {}
					line[i] = '\0';
					return line;
				} else {
					status.ERR = 1;
					NLINES++;
					print_err(ERR_NONFATAL, "line is too long");
					while ((c = (char) fgetc(f)) != '\n' && c != EOF) {}
					break;
				}
				c = (char) fgetc(f);
			}
			/* skip to next line if over-sized line found */
			if (status.ERR == 1) {
				NLINES++;
				i = 0;
				/*continue;*/
			}
		}

	}

	if (c == EOF && i == 0) {
		line = NULL;
		return line;
	}

	line[i] = '\0';

	return line;
}

/*
 * updates labels address in pass 2
 */
void update_labels(label *s) {
	label *tmp = s;

	while (tmp) {
		if (tmp->type == DATA_L) {
			tmp->value += IC;
		}
		tmp = tmp->next;
	}
}

/*
 * updates data segment address in pass 2
 */
void update_data_seg(data *d) {
	data *tmp = d;

	while(tmp) {
		tmp->addr += IC;
		tmp = tmp->next;
	}
}

/*
 * uppdates operands values at given address with label addresses in pass 2
 */
void update_code_seg(char *l_name, int addr) {
	label *l = SYMBOL_TABLE;
	code_seg *c = CODE_SEG_LIST;

	while (l) { /* find the label */
		if (!(strcmp(l_name, l->name))) {
			break;
		}
		l = l->next;
	}

	if (!l) {
		print_err(ERR_NONFATAL, "undefined label: `%s'\n", l_name);
		return;
	}

	while (c) { /* find requested operand and update its value and ARE */
		if (c->addr == addr) {
			c->word.o.val |= l->value;
			if (l->type == EXTERNAL_L) {
				c->word.o.are = EXT;
				add_extern_ref(l->name, addr);
			} else {
				c->word.o.are = REL;
			}
		}
		c = c->next;
	}
}

/*
 * adds external variables to a list
 * to dump to output file later
 */
void add_extern_ref(char *name, int addr){
	extern_ref *e;

	e = (extern_ref *)malloc(sizeof(extern_ref));
	e->name = name;
	e->addr = addr;
	e->next = NULL;

	append_extern(&EXTERN_REF_LIST, e);
}

void append_extern(extern_ref **head, extern_ref *e){
	extern_ref *tmp;

	if (*head == NULL) {
		*head = e;
		return;
	}
	for (tmp = *head; tmp->next != NULL; tmp = tmp->next);
	tmp->next = e;
}

/*
 * gets and encodes instruction and operands of a given instruction
 */
int handle_ops0(instruction inst) { /* handle operands of category 1 (2 ops) instructions */
	char *srcop, *dstop;
	char c;
	operand op1, op2;

	/* should not reach this part if instruction is other then below */
	assert(inst == MOV || inst == CMP || inst == ADD || inst == SUB || inst == LEA);
	srcop = get_op0();
	if (!srcop) {
		c = *in_line_ptr;
		if (c == ',') {
			print_err(ERR_NONFATAL, "unexpected comma after instruction");
			return 1;
		} else if (c == '\0') {
			print_err(ERR_NONFATAL, "operand is expected after instruction");
			return 1;
		}
	}

	c = *in_line_ptr;
	if (c == '\0') {
		print_err(ERR_NONFATAL, "two operands expected");
		return 1;
	} else if (c != ',') {
		print_err(ERR_NONFATAL, "comma is expected after first operand");
		return 1;
	}

	in_line_ptr++; /* eat the comma */
	skip_whitespaces();

	dstop = get_op0();
	if (!dstop) {
		print_err(ERR_NONFATAL, "operand is expected after comma");
	}

	if (is_junk()) return 1;

	op1 = analyze_op(srcop, FALSE);
	if (op1.name == NULL) return FALSE;
	op2 = analyze_op(dstop, FALSE);
	if (op2.name == NULL) return FALSE;
	if (op2.name == NULL) return FALSE;

	if (!validate_cat1_ops(op1, op2, inst)) {
		return FALSE;
	}

	xencode_code_word(op1, op2, inst);

	return 0;
}

/*
 *  encodes instruction and operands words of type 2 (one operand) in pass 1
 */
int handle_ops1(instruction inst){
	char *dstop;

	operand op, op_null = {0};

	assert(inst == NOT || inst == CLR || inst == INC || inst == DEC || inst == JMP
					   || inst == BNE || inst == RED || inst == PRN || inst == JSR);

	dstop = get_op1();
	if (!dstop) {
		print_err(ERR_NONFATAL, "valid operand is expected after `%s' instruction", INSTRUCTIONS_LIST[inst]);
		return 1;
	}

	skip_whitespaces();
	if (is_junk()) return 1;

	if (is_op_params(dstop)) {
		char *param_op, *param1, *param2;

		operand opparam1, opparam2;

		param_op = get_op_p(dstop, &dstop);
		param1 = get_param1(dstop, &dstop);
		if (!param1) return 1;

		param2 = get_param2(dstop, &dstop);
		if (!param2) return 1;

		op = analyze_op(param_op, TRUE);
		opparam1 = analyze_p_op(param1);
		opparam2 = analyze_p_op(param2);

		xencode_param_code_word(op, opparam1, opparam2, inst);

	} else {
		op = analyze_op(dstop, FALSE);

		xencode_code_word(op_null, op, inst);
	}

	return 0;
}

/*
 *  encodes instruction word of type 3 (no operands) in pass 1
 */
int handle_ops2(instruction inst){
	operand op1_null = {0}, op2_null = {0};

	skip_whitespaces();
	if (is_junk()) return 1;
	xencode_code_word(op1_null, op2_null, inst);

	return 0;
}

/*
 * gets operands of instructions of type 1 (two operands) in pass 2,
 * check if its label and updates missing address in code segment
 */
int handle2_ops0(instruction inst) {
	char *srcop, *dstop;

	srcop = get_op0();
	in_line_ptr++;
	skip_whitespaces();
	dstop = get_op0();

	if (is_register(srcop) != -1 && is_register(dstop) != -1) {
		IC++;
		return 0;
	} else {
		IC++;
		if (is_label(srcop)) {
			update_code_seg(srcop, IC);
		}

		IC++;
		if (is_label(dstop)) {
			update_code_seg(dstop, IC);
		}
	}
	return 0;
}

/*
 * gets operands of instructions of type 2 (one operand) in pass 2,
 * check if its label and updates missing address in code segment
 */
int handle2_ops1(instruction inst) {
	char *dstop;

	dstop = get_op1();
	IC++;
	if (is_op_params(dstop)) {
		char *l1, *l2, *l3;
		l1 = get_op_p(dstop, &dstop);
		l2 = get_param1(dstop, &dstop);
		l3 = get_param2(dstop, &dstop);

		update_code_seg(l1, IC);
		if (is_register(l2) != -1 && is_register(l3) != -1) {
			IC++;
			return 0;
		} else {
			IC++;
			if (is_label(l2)) {
				update_code_seg(l2, IC);
			}

			IC++;
			if (is_label(l3)) {
				update_code_seg(l3, IC);
			}
		}
	} else if (is_label(dstop)) {
		update_code_seg(dstop, IC);
	}
	return 0;
}

/*
 * validates and encodes operand
 */
operand analyze_op(char *name, bool param) {
	operand op = {0};
	register_v r;
	int val;

	if ((r = is_register(name)) != -1) {
		op.name = name;
		op.value = r;
		op.mode = REGDIRECT;
		return op;
	}

	if (*name == '#') {
		op.name = name;
		name++;
		if (!valid_int(name)){
			op.name = NULL;
			return op;
		}
		val = atoi(name);

		op.value |= val;
		op.mode = IMMEDIATE;

	} else if (isalpha(*name)) {
		if (!valid_label(name)) {
			op.name = NULL;
			return op;
		}
		op.name = name;
		op.value = 0;
		op.mode = (param) ? INDIRECT : DIRECT;
	} else {
		print_err(ERR_NONFATAL, "bad operand: `%s'\n", name);
		op.name = NULL;
	}

	return op;
}

/*
 * validate and encode parameter of mode 2 operands
 */
operand analyze_p_op(char *name) {
	operand op = {0};
	register_v r;
	int val;

	if ((r = is_register(name)) != -1) {
		op.name = name;
		op.value = r;
		op.mode = REGDIRECT;
		op.param = REGDIRECT;
		return op;
	}

	if (*name == '#') {
		op.name = name;
		name++;
		if (!valid_int(name)){
			op.name = NULL;
			return op;
		}
		val = atoi(name);

		op.value |= val;
		op.mode = IMMEDIATE;
		op.param = IMMEDIATE;

	} else if (isalpha(*name)) {
		if (!valid_label(name)) {
			op.name = NULL;
			return op;
		}
		op.name = name;
		op.value = 0;
		op.mode = DIRECT;
		op.param = DIRECT;
	} else {
		print_err(ERR_NONFATAL, "bad parameter: `%s'", name);
		op.name = NULL;
	}

	return op;

}

/*
 * check if is a legal register name and return its value,
 * returns -1 otherwise
 */
register_v is_register(char *name) {
	int i;

	for (i = 0; i < NREGS; i++) {
		if ((strcmp(name, registers[i].name)) == 0) {
			return registers[i].r;
		}
	}

	return -1;
}



/*
 *  ################################################################
 */

/*
 * gets our imaginary machine encoded bit
 */
char getMbit(unsigned num, int bit){
	if (num & (1<<bit))
		return M_ONE;
	else
		return M_ZRO;
}

/*
 * gets bit N of encoded word, for debugging purposes
 */
int getNthbit(unsigned num, int bit){
	return (num & (1<<bit)) != 0;
}

/*
 * Prints our imaginary machine encoded bits to file stream
 */
void fprint_bits(FILE *f, unsigned num) {
	int i;
	for (i=13; i>=0; i--){
		fputc(getMbit(num, i), f);
	}
}

/*
 * prints bits of encoded words for debugging
 */
void print_bits(unsigned num) {
	int i;
	for (i=13; i>=0; i--){
		printf("%d", getNthbit(num, i));
	}
}

/*
 *  prints symbol table for debugging
 */
void print_symbol_table(label *l) {
	label *tmp = l;

	while(tmp) {
		print_symbol(tmp);
		tmp = tmp->next;
	}
}

/*
 * prints code table for debuigging
 */
void print_code_table(code *c){
	code *tmp = c;

	printf("+++++++++++++++CODE area++++++++++++++++\n");
	while(tmp) {
		print_code_word(tmp);
		tmp = tmp->next;
	}
}

/*
 * prints our imaginary machine code to file
 */
void fprint_xcode_table(FILE *f, code_seg *s){
	code_seg *tmp = s;

	fprintf(f, "\t%4d\t%d\n", IC-CODE_MEM_OFFSET, DC);
	while(tmp) {
		fprint_xcode_word(f, tmp);
		tmp = tmp->next;
	}
}

void print_xcode_table(code_seg *s){
	code_seg *tmp = s;

	printf("+++++++++++++++CODE area++++++++++++++++\n");
	while(tmp) {
		print_xcode_word(tmp);
		tmp = tmp->next;
	}
}

void print_extern_ref(extern_ref *e){
	printf("%s\t%d\n", e->name, e->addr);
}

void print_extern_ref_list(extern_ref *head){
	extern_ref *e = head;

	printf("############### External References ##############\n");
	while(e) {
		print_extern_ref(e);
		e = e->next;
	}
}

void fprint_extern_ref(FILE *f, extern_ref *e){
	fprintf(f, "%s\t%d\n", e->name, e->addr);
}

void fprint_extern_ref_list(FILE *f, extern_ref *head){
	extern_ref *e = head;

	while(e) {
		fprint_extern_ref(f, e);
		e = e->next;
	}
}

void print_symbol(label *l) {
	printf("-------------------- Label %s --------------------\n", l->name);
	printf("Type: %s\n", ltype2str(l->type));
	printf("Label addr: %d\n", l->value);
	printf("Entry: %d\n", l->entry);
}

void print_code_word(code *c) {
	printf("%.4d\t", c->addr);
	/*print_code_bits(c->word);*/
	print_bits(*(unsigned*)&c->word);
	printf("\n");
}

void fprint_xcode_word(FILE *f, code_seg *s) {
	fprintf(f, "%.4d\t", s->addr);
	fprint_bits(f, *(unsigned*)&s->word);
	fprintf(f, "\n");
}

void print_xcode_word(code_seg *s) {
	printf("%.4d\t", s->addr);
	/*print_code_bits(c->word);*/
	print_bits(*(unsigned*)&s->word);
	if (s->name) printf("\t%s\t%s,%s", s->name, s->srcop, s->dstop);
	printf("\n");
}

void print_data_word(data *d) {
	printf("%.4d\t", d->addr);
	/*print_data_bits(d->word);*/
	print_bits(*(unsigned*)&d->word);
	printf("\n");
}

void print_data_table(data *d) {
	data *tmp = d;

	printf("+++++++++++++++DATA area++++++++++++++++\n");
	while(tmp) {
		print_data_word(tmp);
		tmp = tmp->next;
	}
}

void fprint_data_word(FILE *f, data *d) {
	fprintf(f, "%.4d\t", d->addr);
	fprint_bits(f, *(unsigned*)&d->word);
	fprintf(f, "\n");
}

void fprint_data_table(FILE *f, data *d) {
	data *tmp = d;

	while(tmp) {
		fprint_data_word(f, tmp);
		tmp = tmp->next;
	}
}

void print_entries(label *head){
	label *l = head;

	while(l) {
		if (l->entry) {
			printf("%s\t%d\n", l->name, l->value);
		}
		l = l->next;
	}

}

void fprint_entries(FILE *f, label *head){
	label *l = head;

	while(l) {
		if (l->entry) {
			fprintf(f, "%s\t%d\n", l->name, l->value);
		}
		l = l->next;
	}
}

char *ltype2str(label_type t) {
	switch(t){
		case CODE_L: return "Code label";
		case DATA_L: return "Data label";
		case EXTERNAL_L: return "External label";
		default: return "Unknown label type";
	}
}

/*
 * Initializes names of output files
 */
void init_fnames(const char *name){
	size_t len = strlen(name);

	SRC_F = malloc(sizeof(SRC_F_) * len);
	if (!SRC_F) print_err(ERR_FATAL, "failed to allocate memory");
	OBJ_F = malloc(sizeof(OBJ_F_) * len);
	if (!OBJ_F) print_err(ERR_FATAL, "failed to allocate memory");
	ENT_F = malloc(sizeof(ENT_F_) * len);
	if (!ENT_F) print_err(ERR_FATAL, "failed to allocate memory");
	EXT_F = malloc(sizeof(EXT_F_) * len);
	if (!EXT_F) print_err(ERR_FATAL, "failed to allocate memory");

	strcat(strcpy(SRC_F, name), SRC_F_);
	strcat(strcpy(OBJ_F, name), OBJ_F_);
	strcat(strcpy(ENT_F, name), ENT_F_);
	strcat(strcpy(EXT_F, name), EXT_F_);

}


void print_code_bits(instruction_word c) {
	int i;
	for (i=13; i>=0; i--){
		printf("%d", getNthbit(*(unsigned *) &c, i));
	}
}

void print_data_bits(data_word d) {
	int i;
	for (i=13; i>=0; i--){
		printf("%d", getNthbit(d.data, i));
	}
}
