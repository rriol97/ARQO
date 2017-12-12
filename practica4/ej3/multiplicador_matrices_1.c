#include <stdio.h>
#include <string.h>
#include <time.h>
#include "arqo4.h"

#define OK 1
#define ERROR -1

int main(int argc, char *argv[]){
	int i, j, k;
	int n, hilos;
	tipo **A = NULL, **B = NULL, **C = NULL;
	struct timeval fin, ini;
	double suma ;

	/** Captura parametros entrada */
	if (argc != 3){
		printf ("Error en los argumentos de entrada: <int n> <int hilos>\n");
		return ERROR;
	}
	n = atoi(argv[1]);
	hilos = atoi(argv[2]);
	omp_set_num_threads(hilos);

	/** Generamos las matrices de tamaño n */
	A = generateMatrix(n);
	B = generateMatrix(n);
	C = generateEmptyMatrix(n);

	gettimeofday(&ini,NULL); /** Tomamos el tiempo antes de empezar la rutina */

	/** Hacemos C = A * B   */
	for (i = 0; i < n; i++) {
		for (j = 0; j < n; j++) {
			suma = 0;
			#pragma omp parallel for reduction(+:suma)
			for(k = 0; k < n; k++){
				suma += A[i][k] * B[k][j]; /** No se emplea el operador += ya que el reduction se encarga de sumar los resultados parciales */
			}
			C[i][j] = suma;
		}
	}

	gettimeofday(&fin,NULL);; /** Tomamos el tiempo depues de la rutina */
	printf("%f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0); /** Calculamos el tiempo que tarda la rutina */

	freeMatrix(A);
	freeMatrix(B);
	freeMatrix(C);

	return OK;
}
