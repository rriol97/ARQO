#include <stdio.h>
#include <string.h>
#include <time.h>
#include "arqo3.h"

#define OK 1
#define ERROR -1

int main(int argc, char *argv[]){
	int i,j,k;
	int N, hilos;
	tipo **A, **B, **C;
	clock_t t_ini, t_fin;
	double secs, suma;

	/** Captura parametros entrada */
	if (argc != 3){
		printf ("Error en los argumentos de entrada: <int n> <int hilos>\n");
		return ERROR;
	}
	N = atoi(argv[1]);
	hilos = atoi(argv[2]);
	omp_set_num_threads(hilos);

	/** Generamos las matrices de tamaño N */
	A = generateMatrix(N);
	B = generateMatrix(N);
	C = generateEmptyMatrix(N); /** Matriz resultado */

	t_ini = clock(); /** Tomamos el tiempo antes de empezar la rutina */

	/** Hacemos C = A * B   */ 
	#pragma omp parallel for private(j, k, sum) /** Inicializamos la variables privadas dentro del bucle */
	for (i = 0; i < N; i++) {
		for (j = 0; j < N; j++) {
			suma = 0;
			for (k = 0; k < N; k++){
				suma += A[i][k] * B[k][j];
			}
			C[i][j] = suma;
		}
	}

	t_fin = clock(); /** Tomamos el tiempo depues de la rutina */
	secs = (double)(t_fin - t_ini) / CLOCKS_PER_SEC; /** Calculamos el tiempo que tarda la rutina */
	printf ("%f\n", secs);

	freeMatrix(A);
	freeMatrix(B);
	freeMatrix(C);
	return OK;
}