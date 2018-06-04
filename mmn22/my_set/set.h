#define SIZE 128 /* size in bits */
#define INT_SIZE (sizeof(int) * 8)
#define ARR_SIZE (SIZE / INT_SIZE)
#define PRINT_PER_LINE 16

typedef int set[ARR_SIZE];

struct _sets {
	char *name;
	set *set;
};

typedef struct _sets sets_arr;

struct _cmd {
	char *name;
	int (*func) ();
};

typedef struct _cmd cmd;

int read_set(char **args, int *nargs, sets_arr *sets);
int print_set(char **args, int *nargs, sets_arr *sets);
int union_set(char **args, int *nargs, sets_arr *sets);
int intersect_set(char **args, int *nargs, sets_arr *sets);
int sub_set(char **args, int *nargs, sets_arr *sets);
int stop();

int is_strint(char *str);

void set_element(set SET, int k);
void del_element(set SET, int k);
short get_element(set SET, int k);
