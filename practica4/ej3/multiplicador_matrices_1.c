#include <stdio.h>
#include <string.h>
#include <time.h>
#include "arqo4.h"


#define OK 1
#define ERROR -1

void multiplicar(tipo **a, tipo **b, tipo **c, int dim);

int main(int argc, char *argv[]){
	int i,j,k;
	int n, hilos;
	tipo **A = NULL, **B = NULL, **C = NULL;
	clock_t t_ini, t_fin;
	double secs, suma = 0;

	/** Captura parametros entrada */
	if (argc != 3){
		printf ("Error en los argumentos de entrada: <int n> <int hilos>\n");
		return ERROR;
	}
	n = atoi(argv[1]);
	hilos = atoi(argv[2]);

	/** Generamos las matrices de tamaño n */
	if (A = generateMatrix(n) == NULL) {
		return ERROR;
	}
	if (B = generateMatrix(n) == NULL) {
		return ERROR;
	}
	if (C = generateEmptyMatrix(n) == NULL) { /** Matriz resultado */
		return ERROR;
	}

	omp_set_num_threads(hilos);
	t_ini = clock(); /** Tomamos el tiempo antes de empezar la rutina */

	/** Hacemos C = A * B   */
	multiplicar(A, B, C, n);

	t_fin = clock(); /** Tomamos el tiempo depues de la rutina */
	secs = (double)(t_fin - t_ini) / CLOCKS_PER_SEC; /** Calculamos el tiempo que tarda la rutina */
	printf ("%f\n", secs);

	freeMatrix(A);
	freeMatrix(B);
	freeMatrix(C);

	return OK;
}

void multiplicar(tipo **A, tipo **B, tipo **C, int dim) {
	int i, j, k, suma = 0;
	for (i = 0; i < dim; i++) {
		for (j = 0; j < dim; j++) {
			#pragma omp parallel for reduction(+:suma)
			for (k = 0; k < dim; k++) {
				suma += A[i][k] * B[k][j];
			}
			C[i][j] = suma;
		}
	}
	return;
}