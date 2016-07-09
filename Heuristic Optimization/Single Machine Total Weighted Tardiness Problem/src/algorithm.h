/*
 *  pivotingRules.h
 *  Heuristic_Projet1
 *
 *  Created by Alex on 26/03/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef PIVOTING
#define PIVOTING

#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <time.h>

#include "printing.h"
#include "moduleSelector.h"
#include "utils.h"


void checkForPermut(int* p);
long int compute_evaluation_function( int* p, int l, int k);
void allocateMemory();
void freeMemory();
void improvement(char* argv[], FILE* instance_file, char* solution_buf,int solution_file_flag);
int improvement_vnd_piped(char* neighbor);
void vnd(char *argv[], FILE* instance_file, char* solution_buf,int solution_file_flag);
void piped_vnd(char *argv[], FILE* instance_file, char* solution_buf,int solution_file_flag);

#endif