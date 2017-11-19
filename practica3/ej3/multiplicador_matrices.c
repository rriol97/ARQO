#include <stdio.h>
#include <string.h>
#include "arqo3.h"

#define OK 1
#define ERROR -1

int main(int argc, char *argv[]){
  int i,j,k,suma;
  int N;
  tipo **A, **B;

  if (argc != 2){
    printf ("Error en los argumentos de entrada: <int n>\n");
    return ERROR;
  }

  N = atoi(argv[1]);
  /** Generamos las matrices de tamaño N */
  A = generateMatrix(N); /** Matriz que vamos a multiplicar por si misma*/
  B = generateEmptyMatrix(N); /** Matriz resultado*/
  /** Hacemos B = A * A */
  for (i = 0; i < N; i++) {
    for (j = 0; j < N; j++) {
      suma = 0;
      for (k = 0; k < N; k++){
        suma += A[i][k] * A[k][j];
      }
      B [i][j] = suma;
    }
  }

  freeMatrix(A);
  freeMatrix(B);
  return OK;
}
