/*
 *  pivotingRules.c
 *  Heuristic_Projet1
 *
 *  Created by Alex on 26/03/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "algorithm.h"

#define MAX(x,y)        ((x)>=(y)?(x):(y))

#define FALSE 0
#define TRUE  1

int  n = 100;           /* instance size of the SMTWTP instance */

int  *processing_time;  /* array containing the processing time of each job */
int  *weight;           /* array containing the weight (importance) of each job */
int  *due_date;         /* array containing the due dates of each job */
int  *completion_time;  /* array containing the completion times of each job */
int  *tardiness;         /* array containing the completion times of each job */

int  *candidate_solution;  /* array containing current solution */

void checkForPermut(int* p){
	 int i,check_sum = 0;
	 for ( i = 0 ; i < n ; i++) {
	 check_sum += p[i];
	 }
	 if ( check_sum != n * (n-1) / 2) {
	 printf( "\nCandidate solution is not a permutation of 100 jobs!!\n\n");
	 exit(1);
	 }
}

long int compute_evaluation_function( int *p, int l, int k) {
	/*    
	 FUNCTION:      computes the objective function value of a permutation
	 INPUT:         pointer to a permutation
	 OUTPUT:        none
	 (SIDE)EFFECTS: none
	 */
	
	int  i, job;
	int  obj_f_value = 0; 
	int  completion = 0;
	
	
	/* first compute completion times and tardiness of jobs */
	for ( i = 0 ; i < n ; i++ ) {
		job = p[i];
		completion += processing_time[job];
		completion_time[job] = completion;
		tardiness[job] = MAX( (completion_time[job] - due_date[job]),0);
		//printf("job %d, processing time %d, completion_time %d, due date %d, weight %d, tardiness %d\n",job,processing_time[job],completion,due_date[job],weight[job],tardiness[job]);
	}
	
	/* Now compute the actual objective function value */
	for ( i = 0 ; i < n ; i++ ) {
		obj_f_value += tardiness[i] * weight[i];
	}
	
	return obj_f_value;
}

void freeMemory(){	
	free ( processing_time );
	free ( weight );  
	free ( due_date ); 
	free ( completion_time ); 
	free ( tardiness ); 
	free ( candidate_solution );
}

void allocateMemory(){
	processing_time = (int*) malloc(n * sizeof(int));  
	weight = (int*) malloc(n * sizeof(int));
	due_date = (int*) malloc(n * sizeof(int));
	completion_time = (int*) malloc(n * sizeof(int));
	tardiness = (int*) malloc(n * sizeof(int));
	candidate_solution = (int*) malloc(n * sizeof(int));
	
}

void improvement(char* argv[], FILE* instance_file, char* solution_buf,int solution_file_flag){
	int i,j;
	int endInstances = 0;
	int current_objective_value;
	int previous_objective_value; 
	int evaluation_function_value; 
	int copy_candidate_solution[n];
	int counter = 1;
	time_t start, stop;
	double computation_time;
	neighborhood neighbor;
	FILE* results = NULL;
	char filename[255] = "results/ii-first-ins-earl.dat";
	results = fopen(filename, "w+");
	
	allocateMemory();
	argv+=2;
	/* INITIALISATION OF THE OPTION neighborhood */
	neighbor = chooseNeighborhood(*argv--);
	time(&start);
	if (results != NULL)
    {
		while(endInstances == 0){
			printf("%d\n", counter);
			endInstances = printProcessingTime(instance_file,processing_time,n);
			if (endInstances == 1) {
				break;
			}
			printWeights(instance_file,weight,n);
			printDueDate(instance_file, due_date,n);
			printCandidateSolution(instance_file, candidate_solution, solution_file_flag,n, solution_buf);
			chooseInitialiser(*argv++, due_date, candidate_solution, n);
			/** The next is a simple check for a necessary condition whether a 
			 candidate solution is a permutation **/
			checkForPermut(candidate_solution);
			copyVector(candidate_solution, copy_candidate_solution, n);
			evaluation_function_value  = compute_evaluation_function(copy_candidate_solution,0,n);
			current_objective_value = evaluation_function_value;
			
			if (strcmp(*argv,"--transpose") == 0) {
				argv-=2;
				do{
					previous_objective_value = current_objective_value;
					for (i=0; i < n-1; i++) {
						neighbor(copy_candidate_solution, i,0);
						checkForPermut(copy_candidate_solution);
						evaluation_function_value  = compute_evaluation_function(copy_candidate_solution,i,i+1);
						if (evaluation_function_value < current_objective_value) {
							current_objective_value = evaluation_function_value;
							copyVector(copy_candidate_solution,candidate_solution, n);
							
							if (strcmp(*argv, "--first") == 0) {
								break;
							}
						}
						copyVector(candidate_solution, copy_candidate_solution, n);
					}
				}while(current_objective_value != previous_objective_value );	
			}
			else{
				argv-=2;
				do{
					previous_objective_value = current_objective_value;
					for (i=0; i < n; i++) {
					
						for (j=i+1; j < n; j++) {
							neighbor(copy_candidate_solution, i,j);
							checkForPermut(copy_candidate_solution);
							evaluation_function_value  = compute_evaluation_function(copy_candidate_solution,i,j);
							if (evaluation_function_value < current_objective_value) {
								current_objective_value = evaluation_function_value;
								copyVector(copy_candidate_solution,candidate_solution, n);
								
								if (strcmp(*argv, "--first") == 0) {
									break;
								}
							}
							copyVector(candidate_solution, copy_candidate_solution, n);			
						}
						if (evaluation_function_value == current_objective_value) {
							break;
						}
					}
				}while(current_objective_value != previous_objective_value );
			}
			argv++;
			printf("The objective function value is %d\n\n",current_objective_value);
			fprintf(results, "%d\n", current_objective_value);
			counter++;
		}
	}
	else
	{
		printf("Couldn't open the file %s\n", filename);
		exit(1);
	}
	
	if(fclose(results) == EOF) {
		printf("Couldn't close the file %s\n", filename);
		exit(1);
	}
	if(fclose(instance_file) == EOF) {
		printf("Couldn't close the file %s\n", filename);
		exit(1);
	}
	
	time(&stop);
	computation_time = difftime(stop,start);
	printf("Computation_time : %f\n", computation_time);
	freeMemory();
}

int improvement_vnd_piped(char* neighbor){

	int i,j;
	int current_objective_value;
	int previous_objective_value; 
	int evaluation_function_value; 
	int copy_candidate_solution[n];
	
	copyVector(candidate_solution, copy_candidate_solution, n);
	evaluation_function_value  = compute_evaluation_function(copy_candidate_solution,0,n);
	current_objective_value = evaluation_function_value;
	if (strcmp(neighbor,"--transpose") == 0) {
		do{
			previous_objective_value = current_objective_value;
			for (i=0; i < n-1; i++) {
				transpose(copy_candidate_solution, i,0);
				checkForPermut(copy_candidate_solution);
				evaluation_function_value  = compute_evaluation_function(copy_candidate_solution,i,i+1);
				if (evaluation_function_value < current_objective_value) {
					current_objective_value = evaluation_function_value;
					copyVector(copy_candidate_solution,candidate_solution, n);
					break;
				}
				copyVector(candidate_solution, copy_candidate_solution, n);
			}
		}while(current_objective_value != previous_objective_value );	
	}
	else{
		do{
			previous_objective_value = current_objective_value;
			for (i=0; i < n; i++) {
				
				for (j=i+1; j < n; j++) {
					if (strcmp(neighbor,"--exchange" )==0) {
						exchange(copy_candidate_solution, i,j);
					}
					else{
						insert(copy_candidate_solution, i,j);
					}	
					
					checkForPermut(copy_candidate_solution);
					evaluation_function_value  = compute_evaluation_function(copy_candidate_solution,i,j);
					if (evaluation_function_value < current_objective_value) {
						current_objective_value = evaluation_function_value;
						copyVector(copy_candidate_solution,candidate_solution, n);
						break;
					}
					copyVector(candidate_solution, copy_candidate_solution, n);			
				}
				if (evaluation_function_value == current_objective_value) {
					break;
				}
			}
		}while(current_objective_value != previous_objective_value );
	}
	return current_objective_value;
}

void piped_vnd(char *argv[], FILE* instance_file, char* solution_buf,int solution_file_flag){
	int endInstances = 0;
	int counter = 1, i;
	time_t start, stop;
	char* option;
	double computation_time;
	int current_obj_value;
	int previous_obj_value;
	FILE* results = NULL;
	char filename[255] = "vnd/pipedvnd-earl-tr-ex-ins.dat";
		
	results = fopen(filename, "w+");
	
	allocateMemory();
	
	// INITIALISATION OF THE OPTION neighborhood 
	argv++;
	
	time(&start);
	
	if (results != NULL)
    {
		while(endInstances == 0){
			i = 0;
			previous_obj_value = 1e6;
			printf("%d\n", counter);
			endInstances = printProcessingTime(instance_file,processing_time,n);
			if (endInstances == 1) {
				break;
			}
			printWeights(instance_file,weight,n);
			printDueDate(instance_file, due_date,n);
			printCandidateSolution(instance_file, candidate_solution, solution_file_flag,n, solution_buf);
			if (strcmp(*argv,"--random-init") == 0) {
				randomPermutation(candidate_solution, n);
			}
			else {
				earliestDueDate(candidate_solution, due_date, n);
			}
			
			// The next is a simple check for a necessary condition whether a candidate solution is a permutation 
			checkForPermut(candidate_solution);
			
			while (i < 3) {
				argv++;
				if (i==1) {
					option = "--transpose";
				}
				else {
					option = *argv;
				}

				current_obj_value = improvement_vnd_piped(option);
				if (current_obj_value < previous_obj_value) {
					previous_obj_value = current_obj_value;
					argv-=i;
					i = 1;
				}
				else {
					i++;
				}
			}
			argv-=i;
			counter++;
			fprintf(results, "%d\n", current_obj_value);
			printf("objective_function : %d\n",current_obj_value);
		} 
	}
    else
    {
        printf("Couldn't open the file %s\n", filename);
		exit(1);
    }
	
	if(fclose(results) == EOF) {
		printf("Couldn't close the file %s\n", filename);
		exit(1);
	}
	time(&stop);
	computation_time = difftime(stop,start);
	printf("Computation_time : %4.10f\n", computation_time);
	fclose(instance_file);
	freeMemory();
	
}

void vnd(char *argv[], FILE* instance_file, char* solution_buf,int solution_file_flag){
	int endInstances = 0;
	int counter = 1, i,j;
	time_t start, stop;
	double computation_time;
	int current_global;
	int previous_global;
	int current_local;
	
	int copy_candidate_solution[n];
	int evaluation_function_value; 
	FILE* results = NULL;
	char filename[255] = "vnd/vnd-rand-tr-ins-ex.dat";
    
	results = fopen(filename, "w+");
	
	allocateMemory();
	
	// INITIALISATION OF THE OPTION neighborhood 
	argv++;
	time(&start);
	
	if (results != NULL)
    {
		while(endInstances == 0){
			endInstances = printProcessingTime(instance_file,processing_time,n);
			if (endInstances == 1) {
				break;
			}
			printWeights(instance_file,weight,n);
			printDueDate(instance_file, due_date,n);
			printCandidateSolution(instance_file, candidate_solution, solution_file_flag,n, solution_buf);
			
			chooseInitialiser(*argv, due_date, candidate_solution, n);
			// The next is a simple check for a necessary condition whether a candidate solution is a permutation 
			checkForPermut(candidate_solution);
			copyVector(candidate_solution, copy_candidate_solution, n);
			evaluation_function_value  = compute_evaluation_function(copy_candidate_solution,0,n);
			current_local = evaluation_function_value;
			
			current_global = current_local;
			argv+=2;
			do{
				previous_global = current_global;
				for (i=0; i < n; i++) {
					
					for (j=i+1; j < n; j++) {
							if (strcmp(*argv, "--insert") == 0) {
								transpose(copy_candidate_solution, i, j);
								insert(copy_candidate_solution, i,j);
								exchange(copy_candidate_solution, i,j);
							}
							else {
								transpose(copy_candidate_solution, i, j);
								exchange(copy_candidate_solution, i,j);
								insert(copy_candidate_solution, i,j);
							}
						
							checkForPermut(copy_candidate_solution);
							evaluation_function_value  = compute_evaluation_function(copy_candidate_solution,i,j);
							if (evaluation_function_value < current_local) {
								current_local = evaluation_function_value;
								copyVector(copy_candidate_solution,candidate_solution, n);
								break;
							}
							copyVector(candidate_solution, copy_candidate_solution, n);			
					}
					if (evaluation_function_value == current_local) {
						break;
					}
				}
				if (current_local < current_global) {
					current_global = current_local;
				}
			}while(current_global != previous_global );
			argv-=2;
			printf("The objective function for instance %d is %d\n",counter,current_global);
			counter++;
			fprintf(results, "%d\n", current_global);
			 
		} 
	}
    else
    {
        printf("Couldn't open the file %s\n", filename);
		exit(1);
    }
	
	if(fclose(results) == EOF) {
		printf("Couldn't close the file %s\n", filename);
		exit(1);
	}
	time(&stop);
	computation_time = difftime(stop,start);
	printf("Computation_time : %4.10f\n", computation_time);
	fclose(instance_file);
	freeMemory();
}
