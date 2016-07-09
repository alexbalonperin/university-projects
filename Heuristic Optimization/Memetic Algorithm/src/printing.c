/*
 *  printing.c
 *  Heuristic_Projet1
 *
 *  Created by Alex on 25/03/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "printing.h"

int printProcessingTime(FILE* instance_file, int* processing_time, int n){
	int i,end = 0;
//	printf("Processing times: \n");
	for ( i = 0 ; i < n ; i++) {
		if( fscanf(instance_file, "%d", &processing_time[i]) <= 0) {
			//end = 1;
			fprintf(stderr, "%s (line %d):  error reading (%d) smtwtp_processing_time in data file\n", __FILE__, __LINE__, i);	
		} 	
		if (processing_time[0] == -1) {
			end = 1;
			break;
		}
//		printf("%d ",processing_time[i]);
	}
	return end;
}

void printWeights(FILE* instance_file, int* weight, int n){
	int i;
//	printf("\nWeights: \n");
	for ( i = 0 ; i < n ; i++) {
		if( fscanf(instance_file, "%d", &weight[i]) <= 0) {
			fprintf(stderr, "%s(line %d):  error reading (%d) smtwtp_weight in data file\n", __FILE__, __LINE__, i);
		} 
//		printf("%d ",weight[i]);
	}
}
void printDueDate(FILE* instance_file, int* due_date, int n){
	int i;
//	printf("\nDue dates: \n");
	for ( i = 0 ; i < n ; i++) {
		if( fscanf(instance_file, "%d", &due_date[i]) <= 0) {
			fprintf(stderr, "%s(line %d):  error reading (%d) smtwtp_due_dat in data file\n", __FILE__, __LINE__, i);
		}	
//		printf("%d ",due_date[i]);
	}
}

void printCandidateSolution(FILE* solution_file, int* candidate_solution, int solution_file_flag, int n, char* solution_buf){
	int i;
	
//	printf("\nCandidate solution: \n");
	if ( solution_file_flag ) {
		solution_file = fopen(solution_buf, "r");
		for ( i = 0 ; i < n ; i++) {
			if( fscanf(solution_file, "%d", &candidate_solution[i]) <= 0) {
				fprintf(stderr, "%s(line %d):  error reading (%d) smtwtp_processing_time in data file\n", __FILE__, __LINE__, i);
			} 
//			printf("%d ",candidate_solution[i]);
		}
	} else {
		/* if no candidate solution is given as input, assume 0, 1, .. n-1 as 
		 candidate solution */
		for ( i = 0 ; i < n ; i++) {
			candidate_solution[i] = i;
//			printf("%d ",candidate_solution[i]);      
		}
	}
}

