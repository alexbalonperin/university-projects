/*
 *  utils.h
 *  Heuristic_Projet1
 *
 *  Created by Alex on 29/03/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef UTILS
#define UTILS

#include <stdlib.h>
#include <stdio.h>

void printMatrix(long int **p, int line, int column);
void printVector( long int *p, int n);
void copyVector(long int* p , long int* p_copy, int n);
void checkForPermut(long int* p, int n);

#endif