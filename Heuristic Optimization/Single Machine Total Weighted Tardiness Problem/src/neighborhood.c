/*
 *  neighborhood.c
 *  Heuristic_Projet1
 *
 *  Created by Alex on 26/03/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "neighborhood.h"
#include <stdio.h>

void transpose(int* pi, int i, int j){
	int save;
	save = pi[i];
	pi[i] = pi[i+1];
	pi[i+1] = save;
}

void exchange(int* pi, int i, int j){
	int save;
	save = pi[i];
	pi[i] = pi[j];
	pi[j] = save;
}

void insert(int* pi, int i, int j){
	int save;
	if (i < j) {
		save = pi[i];
		for (; i<j; i++) {
			pi[i] = pi[i+1];
		}
		pi[j] = save;
	}
	else {
		save = pi[i];
		for (; i>j; i--) {
			pi[i] = pi[i-1];
		}
		pi[j] = save;
		
	}

	
	
}