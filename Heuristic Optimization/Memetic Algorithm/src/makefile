CC=gcc
CFLAGS=-W -Wall
LDFLAGS=
EXEC=heuristic_projet2
SRC=$(wildcard *.c)
OBJ=$(subst .c,.o,$(SRC))

all: $(EXEC)

heuristic_projet2: $(OBJ)
	@$(CC) -o $@ $^ $(LDFLAGS)

main.o: memetic_algorithm.h 
 
%.o: %.c
	@$(CC) -o $@ -c $< $(CFLAGS)

clean: 
	@rm *.o

mrproper: clean
	@rm $(EXEC)
