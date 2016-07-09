/*
 *  memetic_algorithm.h
 *  Projet_2
 *
 *  Created by Alex on 05/05/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef MEMETIC
#define MEMETIC

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

#include "moduleSelector.h"
#include "utils.h"
#include "printing.h"


long int* crossover (long int** population, long int father, long int mother);
long int* mutation(long int ** population, long int parent, long int mutationDist);
int compute_evaluation_function(long  int *p );
int findBestIndividual (long int ** population, int populationSize);
int stableFitness(double * avFitness, int size);
double averageFitness(long int** population, int size);
double averageDistance(long int** population, int size);
long int ** selection (long int** population, long int size, long int minSize);
int notSameObjectiveValue(long int ** pop, int size, long int value);
int sameIndividual(long int* ind1, long int* ind2);
int inSelection (long int ** pop, int size, long int* individual, int check);
neighborhood initializePopulation(long int **population,long int *objectiveValue, long int pop_size);
long int * generate_random_vector(  int size );
double ran01( long *idum ) ;
int pivoting_rule(neighborhood neighbor,long int *current_parent);
void allocateMemory();
void freeMemory();
void memetic_algorithm(char *argv[],FILE* instance_file, char* solution_buf,int solution_file_flag);

#endif
