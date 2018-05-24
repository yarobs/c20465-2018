#define SIZE 128 /* size in bits */
#define INT_SIZE (sizeof(int) * 8)
#define ARR_SIZE (SIZE / INT_SIZE)

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

int read_set(char *args, sets_arr *sets);
int print_set();
int union_set();
int intersect_set();
int sub_set();
int stop();
void set_element(set SET, int k);
void del_element(set SET, int k);
short get_element(set SET, int k);
