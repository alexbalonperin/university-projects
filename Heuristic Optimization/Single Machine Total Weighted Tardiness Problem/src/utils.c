/*
 *  utils.c
 *  Heuristic_Projet1
 *
 *  Created by Alex on 29/03/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "utils.h"

void printVector(int *p, int n){
	int i;
	printf("\nPrinting vector : \n");
	for (i = 0; i < n ; i++) {
		printf("%d ", p[i]);
	}
	printf("\n");
}

void copyVector(int* p, int* p_copy, int n){
	int i;
	for (i = 0; i < n ; i++) {
		p_copy[i] = p[i];
	}
}
