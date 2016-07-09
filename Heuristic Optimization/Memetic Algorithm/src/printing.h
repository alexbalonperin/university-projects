/*
 *  printing.h
 *  Heuristic_Projet1
 *
 *  Created by Alex on 25/03/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef PRINTING
#define PRINTING

#include <stdio.h>

#include "utils.h"

int printProcessingTime(FILE* instance_file, int* processing_time, int n);
void printWeights(FILE* instance_file, int* weight, int n);
void printDueDate(FILE* instance_file, int* due_date, int n);
void printCandidateSolution(FILE* solution_file, int* candidate_solution, int solution_file_flag, int n, char* solution_buf);

#endif


