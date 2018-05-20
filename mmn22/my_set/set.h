#define SIZE 128 /* size in bits */
#define INT_SIZE (sizeof(int) * 8)
#define ARR_SIZE (SIZE / INT_SIZE)

int read_set();
int print_set();
int union_set();
int intersect_set();
int sub_set();
int stop();

typedef int set[ARR_SIZE];

struct _sets {
	char *name;
	set *set;
};

typedef struct _sets sets_arr;

struct _cmd {
	char *name;
	int (*func) (char**);
};

typedef struct _cmd cmd;
