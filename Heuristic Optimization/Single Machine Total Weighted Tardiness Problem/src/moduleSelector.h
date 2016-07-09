/*
 *  moduleSelector.h
 *  Heuristic_Projet1
 *
 *  Created by Alex on 26/03/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef SELECTOR
#define SELECTOR

#include <string.h>
#include <stdio.h>
#include <string.h>

#include "initialisation.h"
#include "neighborhood.h"

/* function pointers: allows to pick dynamically the function chosen with the options of the main */
typedef void (*neighborhood) (int*,int,int); 

void chooseInitialiser(char* option, int* due_date, int* candidate_solution, int n);
neighborhood chooseNeighborhood(char* option);

#endif