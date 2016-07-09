CC=gcc
CFLAGS=-W -Wall
LDFLAGS=
EXEC=heuristic_projet1
SRC=$(wildcard *.c)
OBJ=$(subst .c,.o,$(SRC))

all: $(EXEC)

heuristic_projet1: $(OBJ)
	@$(CC) -o $@ $^ $(LDFLAGS)

smtwtp_basic.o: printing.h moduleSelector.h
 
%.o: %.c
	@$(CC) -o $@ -c $< $(CFLAGS)

clean: 
	@rm *.o

mrproper: clean
	@rm $(EXEC)
