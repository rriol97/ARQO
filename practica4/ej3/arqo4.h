#ifndef _ARQO_P4_H_
#define _ARQO_P4_H_

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <omp.h>

#define N 1000ull
#define M 1000000ull

#if __x86_64__
	typedef double tipo;
#else
	typedef float tipo;
#endif

tipo ** generateMatrix(int);
tipo ** generateEmptyMatrix(int);
void freeMatrix(tipo **);
tipo * generateVector(int);
tipo * generateEmptyVector(int);
int * generateEmptyIntVector(int);
void freeVector(void *);



#endif /* _ARQO_P4_H_ */
