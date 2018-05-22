#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#include "set.h"
#include "util.h"
#define PROMPT "> "

set SETA={0}, SETB={0}, SETC={0}, SETD={0}, SETE={0}, SETF={0};

sets_arr sets[] = {
	{"SETA", &SETA},
	{"SETB", &SETB},
	{"SETC", &SETC},
	{"SETD", &SETD},
	{"SETE", &SETE},
	{"SETF", &SETF}
};

cmd cmds[] = {
	{"read_set", &read_set},
	{"print_set", &print_set},
	{"union_set", &union_set},
	{"intersect_set", &intersect_set},
	{"sub_set", &sub_set},
	{"stop", &stop}
};

char *get_line(void) {
	int bufsize = IN_LINE_BUFSIZE, pos = 0, c;
	char *buffer = malloc(bufsize * sizeof(char*));
	
	if (!buffer) {
		fprintf(stderr, "FATAL: failed to allocate memory");
		exit(EXIT_FAILURE);
	}
	
	while (1) {
		c = getchar();
		
		if (c == EOF || c == '\n') {
			buffer[pos] = '\0';
			return buffer;
		}
		else {
			buffer[pos] = c;
		}
		pos++;
		
		if (pos >= bufsize) {
			bufsize += IN_LINE_BUFSIZE;
			buffer = realloc(buffer, bufsize);
			if (!buffer) {
				fprintf(stderr, "FATAL: failed to allocate memory");
				exit(EXIT_FAILURE);
			}
		}
	}
}

char **parse_line(char *line, int *nargs) {
	int bufsize = TOK_BUFSIZE, pos = 0;
	char **tokens = malloc(bufsize * sizeof(char*));
	char *token;

	if (!tokens) {
		fprintf(stderr, "FATAL: failed to allocate memory");
		exit(EXIT_FAILURE);
	}
	
	token = strtok(line, TOK_DELIMITER);
	printf("Parse: token: %s\n", token);
	while (token != NULL) {
		tokens[pos] = token;
		pos++;
		
		if (pos >= bufsize) {
			bufsize += TOK_BUFSIZE;
			tokens = realloc(tokens, bufsize * sizeof(char*));
			if (!tokens) {
				fprintf(stderr, "FATAL: failed to allocate memory");
				exit(EXIT_FAILURE);
			}
		}
		
		token = strtok(NULL, TOK_DELIMITER);
	}
	
	tokens[pos] = NULL;
	*nargs = pos;
	printf("Parse: pos: %d nargs: %d\n", pos, *nargs);
	return tokens;
} 

char *get_command(char *line, int *line_idx) {
	int bufsize = CMD_BUFSIZE, pos = 0, i = 0, got_cmd = 0, in_cmd = 0, c = 0;
	char *command = malloc(bufsize * sizeof(char*));
	
	if (!command) {
		fprintf(stderr, "FATAL: failed to allocate memory");
		exit(EXIT_FAILURE);
	}
	c = line[pos];
	while (c != '\n' && c != '\0' && c != EOF) {
		if ((c != ' ' && c != '\t' && c != ',') && !got_cmd ) {
			command[i++] = c;
			in_cmd = 1;
		} else if ((c == ' ' || c == '\t') && in_cmd) {
			got_cmd = 1;
			break;
		} else if (c == ',') {
			printf("Invalid comma\n");
			command[0] = '\0';
			break;
		}
		pos++;
		c = line[pos];
	}
	*line_idx += pos;
	command[i] = '\0';
	return command;
}

char *get_args(char *line, int *line_idx) {
	int c, pos = *line_idx;
	printf("Args: idx: %d\n", *line_idx);
	c = line[pos+1];
	printf("Args: c: %c\n", c);
	return "";
}

int check_command(char *command) {
	int i;

	for (i = 0; i < ncmds; i++) {
		if (strcmp(command, cmds[i].name) == 0) {
			return 0;
		}
	}
	printf("Undefined command: %s\n", command);
	return 1;
}

int exec_cmd(char *line) {
	int cmd_l;
	int line_idx = 0;
	int *idx_ptr = &line_idx;
	char *command, *args;
	

	command = get_command(line, idx_ptr);
	cmd_l = strlen(command);
	if (cmd_l == 0) {
		return 1;
	}
	if ((check_command(command)) != 0) {
		return 1;
	}

	args = get_args(line, idx_ptr);
	printf("Exec: args: %s\n", args);

	return 0;	
}

int print_line(char *line) {
	int i, c, len;
	len=strlen(line);

	for (i=0; i < len; i++) {
		c = line[i];
		if (c == ' ' || c == '\t' || c == '\n' || c == EOF) {
			continue;
		} else {
			printf("You entered: %s. Size of line: %d\n", line, len);
			return 0;
		}
	}
	return 1;
}

int main_loop(void) {
	/*int nargs = 0;
	int *nargsp = &nargs;*/
	char *line;

	while(1) {
		printf(PROMPT);
		line = get_line();
		if (print_line(line))
			continue;

		/*if (line_s > 0) {
			printf("You entered: %s. Size of line: %d\n", line, line_s);
		}
		else {
			continue;
		}*/

		/*command = parse_line(line, nargsp);
		printf("Tokens size: %lu\n", sizeof(*command));
		printf("Loop: Token 0: %s\n", command[0]);
		printf("Loop: Token 1: %s\n", command[1]);
		printf("Loop: Token 2: %s\n", command[2]);
		printf("Loop: Token 3: %s\n", command[3]);
		printf("Loop: Token 4: %s\n", command[4]);
		printf("Loop: Token 5: %s\n", command[5]);
		printf("Loop: Token 6: %s\n", command[6]);
		printf("Loop: Token 7: %s\n", command[7]);
		printf("Loop: number of args: %d\n", nargs);*/
		
		if ((exec_cmd(line)) != 0)
			continue;
		
		if (strcmp(line,"stop") == 0) {
			return EXIT_SUCCESS;
		}
	}
}

int main(int argc, char **argv) {
	int rc, i;

	printf("Welcome to set game, Inna!\n");

	ncmds = sizeof(cmds)/sizeof(cmd);
	nsets = sizeof(sets)/sizeof(set);
	printf("Number of commands: %d\n", ncmds);
	printf("Number of sets: %d\n", nsets);
	printf("\n");
	
	for (i=0; i < ncmds; i++) {
		printf("Command %d: %s\n", i, cmds[i].name);
	}

	printf("\n");
	for (i=0; i < nsets; i++) {
		printf("Set %d: %s\n", i, sets[i].name);
	}

	rc = main_loop();

	return rc;
}
