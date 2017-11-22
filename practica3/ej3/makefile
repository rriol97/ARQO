all: MultiplicarMatrices MultiplicarMatricesTraspuesta

CCFLAGS = -g -Wall -pedantic -ansi -c

MultiplicarMatrices: multiplicador_matrices.o arqo3.c arqo3.h
	gcc -o $@ $^

MultiplicarMatricesTraspuesta: multiplicador_matrices_traspuesta.o arqo3.c arqo3.h
	gcc -o $@ $^

multiplicador_matrices.o: multiplicador_matrices.c arqo3.c arqo3.h
	gcc $(CCFLAGS) multiplicador_matrices.c arqo3.c

multiplicador_matrices_traspuesta.o: multiplicador_matrices_traspuesta.c arqo3.c arqo3.h
	gcc $(CCFLAGS) multiplicador_matrices_traspuesta.c arqo3.c arqo3.h

clean:
	rm -rf *.o MultiplicarMatrices MultiplicarMatricesTraspuesta arqo3.h.gch
