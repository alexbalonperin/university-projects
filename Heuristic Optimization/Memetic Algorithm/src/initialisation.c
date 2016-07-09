/*
 *  initialisation.c
 *  Heuristic_Projet1
 *
 *  Created by Alex on 26/03/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 */

#include "initialisation.h"

int getArgmin(int* p, int n){
	int i, min, argmin;
	
	min = 10000;
	argmin = 0;
	for (i = 0; i < n ; i++) {
		if(p[i] < min && p[i] != -1){
			min = p[i];
			argmin = i;
		}
	}
	return argmin;
}

void randomPermutation(int* p, int n){
	int save, random1,random2;
	random1 = rand()%(n-1);
	random2	= rand()%(n-1);
	save = p[random1];
	p[random1] = p[random2];
	p[random2] = save;
}

void earliestDueDate(int* p, int* due_date, int n){
	int i;
	int *dueDateCopy = malloc(n*sizeof(int*));
	copyVector(due_date, dueDateCopy,n);
	
	for (i = 0; i < n; i++) {
		p[i] = getArgmin(dueDateCopy,n);
		dueDateCopy[p[i]] = -1;
	}
	free(dueDateCopy);
	
}

