PROG = myset
CC = gcc
CFLAGS = -pedantic -Wall -ansi
SRCS = $(wildcard *.c)
OBJS = $(SRCS:.c=.o)
.PHONY: clean

$(PROG) : $(OBJS)
	$(CC) -o $(PROG) $(OBJS) 
	
testrun: $(PROG)
	./$(PROG) < test1 > output
#	./$(PROG) < test2 >> output
#	./$(PROG) < test3 >> output
	
-include depends

%.o : %.c
	$(CC) -g -c $(CFLAGS) $<
	$(CC) -g -c $(CFLAGS) -MM $< >> depends 
		
clean:
	rm -f *.o depends
	 

#myset: myset.o set.o util.o
#	gcc -o myset myset.o set.o util.o
#
#myset.o: myset.c set.h util.h
#	gcc -ansi -pedantic -Wall -c myset.c
#
#set.o: set.c set.h
#	gcc -ansi -pedantic -Wall -c set.c
#
#util.o: util.c set.h util.h
#	gcc -ansi -pedantic -Wall -c util.c

 
#myset:	myset.o set.h set.c util.c
#	gcc -g -ansi -Wall -pedantic myset.o util.o set.o -o myset
#
#myset.o: myset.c
#	gcc -c -ansi -Wall -pedantic myset.c -o myset.o
#
#set.o: set.c
#	gcc -c -ansi -Wall -pedantic set.c -o set.o
#
#util.o: util.c
#	gcc -c -ansi -Wall -pedantic util.c -o util.o