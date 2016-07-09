/*
 *  moduleSelector.c
 *  Heuristic_Projet1
 *
 *  Created by Alex on 26/03/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "moduleSelector.h"


void chooseInitialiser(char* option, int* due_date, long int* candidate_solution, int n){
	
	if(strcmp(option, "--earliest-due-date") == 0){
		earliestDueDate(candidate_solution, due_date, n);
	}
	else if(strcmp(option, "--random-init") == 0){
		randomPermutation(candidate_solution, n);
	}
	else{
		fprintf(stderr,"Erreur: l'option d'initialisation choisie: %s n'existe pas!\n Option1 : --earliest-due-date\n Option2 : --random-init\n",option);
		exit(0);
	}
}

neighborhood chooseNeighborhood(char* option){
	neighborhood neighbor;
	if(strcmp(option,"--transpose") == 0){
		neighbor = transpose;
	}
	else if(strcmp(option, "--exchange") == 0){
		neighbor = exchange;
	}
	else if (strcmp(option, "--insert") == 0){
		neighbor = insert;
	}
	else{
		fprintf(stderr,"Erreur: l'option choisie : %s  n'existe pas!\n Option1 : --transpose\n Option2 : --exchange\n Option3 : --insert\n",option);
		exit(0);
	}
	return neighbor;
}