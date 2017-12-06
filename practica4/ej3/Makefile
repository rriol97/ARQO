LIBS = 
LIB_DIR =  
FLAGS = -g -lgomp -Wall -D_GNU_SOURCE -fopenmp

.PHONY: clean all

all: multiplicador_matrices multiplicador_matrices_1 multiplicador_matrices_2 multiplicador_matrices_3 clear

multiplicador_matrices: multiplicador_matrices.c arqo4.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

multiplicador_matrices_1: multiplicador_matrices_1.c arqo4.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

multiplicador_matrices_2: multiplicador_matrices_2.c arqo4.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

multiplicador_matrices_3: multiplicador_matrices_3.c arqo4.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

clean:
	rm -f *.o *~ multiplicador_matrices multiplicador_matrices_1 multiplicador_matrices_2 multiplicador_matrices_3
	
clear:
	rm -f *.o *~
