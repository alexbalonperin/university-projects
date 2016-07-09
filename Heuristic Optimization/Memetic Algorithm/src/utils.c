/*
 *  utils.c
 *  Heuristic_Projet1
 *
 *  Created by Alex on 29/03/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "utils.h"

void printMatrix(long int **p, int line, int column){
	int i,j;
	printf("\nPrinting Matrix : \n");
	for (i=0; i<line; i++) {
		for (j=0; j<column; j++) {
			printf("%ld ", p[i][j]);
		}
		printf("\n\n");
	}
	printf("line = %d", i);
	printf("\n\n");
}

void printVector(long int *p, int n){
	int i;
	printf("\nPrinting vector : \n");
	for (i = 0; i < n ; i++) {
		printf("%ld ", p[i]);
	}
	printf("\n");
}

void copyVector(long int* p, long int* p_copy, int n){
	int i;
	for (i = 0; i < n ; i++) {
		p_copy[i] = p[i];
	}
}

void checkForPermut(long int* p, int n){
	int i,check_sum = 0;
	for ( i = 0 ; i < n ; i++) {
		check_sum += p[i];
	}
	if ( check_sum != n * (n-1) / 2) {
		printf( "\nCandidate solution is not a permutation of 100 jobs!!\n\n");
		exit(1);
	}
}
