CC = gcc
LEX = lex
YACC = yacc
PROG = part2

all: $(PROG)

compile_lex: $(PROG).l
	$(LEX) -l $(PROG).l

compile_yacc: $(PROG).y
	$(YACC) -d $(PROG).y

$(PROG): compile_lex compile_yacc lex.yy.c y.tab.h y.tab.c
	$(CC) -o $(PROG) lex.yy.c y.tab.c


test: input
	cat input | ./$(PROG)

clean:
	-rm -f lex.yy.c
	-rm -f $(PROG)
	-rm -f y.tab.h
	-rm -f y.tab.c
