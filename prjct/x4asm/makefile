PROG = asm14
CC = gcc
SRCDIR = src
BUILDDIR = build
CFLAGS = -pedantic -Wall -ansi
HEADRES = $(wildcard $(SRCDIR)/*.h)
SRCS = $(wildcard $(SRCDIR)/*.c)
OBJS = $(patsubst $(SRCDIR)/%.c,$(BUILDDIR)/%.o,$(SRCS))
.PHONY: clean

$(PROG) : $(OBJS)
	$(CC) -o $(PROG) $(OBJS)

test: $(PROG)
	./$(PROG) < test
#	./$(PROG) < test2 >> output
#	./$(PROG) < test3 >> output

-include depends

$(OBJS): $(BUILDDIR)/%.o : $(SRCDIR)/%.c $(HEADERS)
	$(CC) -g -c $(CFLAGS) $< -o $@
	$(CC) -g -c $(CFLAGS) -MM $< >> depends

clean:
	rm -f $(BUILDDIR)/*.o depends
cleanasm:
	rm -f *.ob *.ent *.ext
	
