all: MultiplicarMatrices

CCFLAGS = -g -Wall -pedantic -ansi -c

MultiplicarMatrices: multiplicador_matrices.o arqo3.c arqo3.h
	gcc -o $@ $^

multiplicador_matrices.o: multiplicador_matrices.c arqo3.c arqo3.h
	gcc $(CCFLAGS) multiplicador_matrices.c arqo3.c

clean:
	rm -rf *.o MultiplicarMatrices
