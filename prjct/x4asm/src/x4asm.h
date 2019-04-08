#define MAX_LBL_SIZE  31
#define MAX_DIR_SIZE  32
#define MAX_LINE_SIZE 80
#define MAX_INST_SIZE 5

#ifndef X4ASM_X4ASM_H
#define X4ASM_X4ASM_H
typedef enum {FALSE, TRUE} bool;
typedef enum {CODE_L, DATA_L, EXTERNAL_L} label_type;
typedef enum {STR, NUM} data_type;
typedef enum {R0, R1, R2, R3, R4, R5, R6, R7} register_v; /* register values */
typedef enum {MOV, CMP, ADD, SUB, NOT, CLR, LEA, INC,
              DEC, JMP, BNE, RED, PRN, JSR, RTS, STOP} instruction;
typedef enum {TWOOPS = 1, ONEOP, NOOPS} inst_category;
typedef enum {INSTRUCTION, OPERAND, EXTERN} code_word_type;
typedef enum {IMMEDIATE, DIRECT, INDIRECT, REGDIRECT} addr_mode;
typedef enum {ABS, EXT, REL} encode_type;
typedef enum {ERR_NONFATAL, ERR_FATAL, ERR_WARNING, ERR_SYS} err_severity;

typedef struct status_flags_t status_flags;
typedef struct label_t label;
typedef struct instruction_word_t instruction_word;
typedef struct regop_word_t register_op_w;
typedef struct otherop_word_t other_op_w;
typedef union code_word_t code_w;
typedef struct data_word_t data_word;
typedef struct code_t code;
typedef struct code_segment_t code_seg;
typedef struct data_t data;
typedef struct _opcode opcode;
typedef struct operand_t operand;
typedef struct reg_t reg;
typedef struct extern_ref_t extern_ref;

const char *PROG_NAME;
extern const char *INSTRUCTIONS_LIST[];
extern const char *REGISTERS_LIST[];
extern const char *RESERVED_KEYWORDS[];
int DC, IC;

extern char *in_line_ptr;
extern char *LINE;
extern int NLINES;
extern int INP_LINE_POS;
extern int NRESERVED;
extern int NINST;                /* number of instructions */
extern int NREGS;                /* number of registers */
extern char *SRC_F;
extern char *OBJ_F;
extern char *ENT_F;
extern char *EXT_F;
extern bool ENTRIES_DEF;


extern label *SYMBOL_TABLE;
extern data *DATA_LIST;
extern code *CODE_TABLE;
extern code_seg *CODE_SEG_LIST;
extern extern_ref *EXTERN_REF_LIST;
extern status_flags status;

struct status_flags_t {
    unsigned int ERR : 1;
    unsigned int LBL : 1;
    unsigned int WRN : 1;
    unsigned int : 0;
};
struct _opcode { /* holds instruction name, its opcode and category */
    const char *name;
    instruction code;
    inst_category type;
};

struct instruction_word_t { /* represents instruction encoded word in our machine*/
    unsigned int are : 2;
    unsigned int dst_op_addr : 2;
    unsigned int src_op_addr : 2;
    unsigned int opcode : 4;
    unsigned int param_2 : 2;
    unsigned int param_1 : 2;
    unsigned int : 0;
};
struct regop_word_t { /* represnts encoded words which are register operands */
    unsigned int are : 2;
    unsigned int dstreg : 6;
    unsigned int srcreg : 6;
    unsigned int : 0;
};
struct otherop_word_t { /* represents encoded words which are labels or integers */
    unsigned int are : 2;
    unsigned int val : 12;
    unsigned int : 0;
};
union code_word_t { /* represents our machine code word in bits */
    instruction_word i;
    register_op_w r;
    other_op_w o;
};
struct code_t { /* DEPRECATED */
    instruction_word word;
    int addr;
    struct code_t *next;
};
struct code_segment_t { /* to use in table of all code words */
    const char *name;
    const char *srcop;
    const char *dstop;
    code_w word;
    int addr;
    struct code_segment_t *next;
};
struct operand_t { /* represents instruction's operand value to be encoded in a code word*/
    const char *name;
    addr_mode mode;
    unsigned value : 12;
    unsigned param : 2;
    unsigned : 0;
};

extern opcode opcodes[];
void die(const char *msg);
void print_err(err_severity, char *, ...);

#endif /*X4ASM_X4ASM_H*/

