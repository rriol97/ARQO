#include <stdio.h>
#include <string.h>
#include <time.h>
#include "arqo3.h"

#define OK 1
#define ERROR -1

/* tipo **traspuesta(tipo **matrix, int dim); */
void trasponer(tipo **M, tipo **Mt, int n);

int main(int argc, char *argv[]) {
	int i,j,k;
	int N;
	tipo **A, **B, **C, **Bt;
	clock_t t_ini, t_fin;
	double secs, suma;

	if (argc != 2){
		printf ("Error en los argumentos de entrada: <int n>\n");
		return ERROR;
	}

	N = atoi(argv[1]);
	/** Generamos las matrices de tamaño N */
	A = generateMatrix(N);
	B = generateMatrix(N);
	Bt = generateEmptyMatrix(N);
	C = generateEmptyMatrix(N); /** Matriz resultado*/

	t_ini = clock(); /**Tomamos el tiempo antes de empezar la rutina*/

	/**Calculamos la matriz traspuesta de B*/
	trasponer(B, Bt, N);

	/** Hacemos C = A * B   */
	for (i = 0; i < N; i++) {
		for (j = 0; j < N; j++) {
			suma = 0;
			for (k = 0; k < N; k++){
				suma += A[i][k] * Bt[j][k];
			}
			C[i][j] = suma;
		}
	}

	t_fin = clock(); /**Tomamos el tiempo depues de la rutina*/
	secs = (double)(t_fin - t_ini) / CLOCKS_PER_SEC; /** Calculamos el tiempo que tarda la rutina*/
	printf ("%f\n", secs);

	freeMatrix(A);
	freeMatrix(B);
	freeMatrix(C);
	return OK;
}

/** Implemetancion de la funcion traspuesta */
void trasponer(tipo **M, tipo **Mt, int n) {
	int i, j;

	for (i = 0; i < n; i++){
		for (j = 0; j < n; j++){
			Mt[i][j] = M[j][i];
		}
	}

	return;
}
