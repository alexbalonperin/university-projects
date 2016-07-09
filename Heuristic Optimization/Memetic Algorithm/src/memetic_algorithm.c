/*
 *  memetic_algorithm.c
 *  Projet_2
 *
 *  Created by Alex on 05/05/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "memetic_algorithm.h"
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <limits.h>
#include <unistd.h>
#include <string.h>
#include <time.h>

#include "memetic_algorithm.h"

#define LINE_BUF_LEN  512
#define PROG_ID_STR "basic routines for SMTWTP, Heuristic Optimization 2011, V1.0\n" 
#define CALL_SYNTAX_STR "smtwtp_basic <instance> <improvement> <neighborhood>\n" 

//#define VERBOSE(x)

#define MAX(x,y)        ((x)>=(y)?(x):(y))
#define TRUE 1
#define FALSE 0

const int n = 100; /* instance size of the SMTWP instance */

//vectors containing the objective values 
long int *objectiveValue; 

//size of the basicparents (without mutant and children)
long int pop_size = 40;

//tables containing the individuals
long int **parents;
long int ** crossed_pop;
long int ** mutant_pop;

//global table containing all theparents at the end of the loop, in order to ease the selection 
//process
long int ** new_generation;

//options du script for different part of the algorithm
char* option_improv;
char* option_neighbor;

int  *processing_time;  /* array containing the processing time of each job */
int  *weight;           /* array containing the weight (importance) of each job */
int  *due_date;         /* array containing the due dates of each job */
int  *completion_time;  /* array containing the completion times of each job */
int  *tardiness;         /* array containing the completion times of each job */
int  *candidate_solution;  /* array containing current solution */

/*--------------------------------------------------------------------------------------------------*/
/*										UTILITY FUNCTIONS											*/
/*--------------------------------------------------------------------------------------------------*/

long int*  random_generator(int n){
	int i,j,deja;
	long int* tab= malloc(sizeof(long int)*n);
	
	i=0;
	while (i<n) {
		tab[i]=rand()%n;
		deja=0;
		for (j=0;j<i;j++) {
			if (tab[j]==tab[i]) {
				deja=1;
				break;
			}
		}
		if (deja==0)
			i++;
	}
	
	return tab;
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


//gets the index of the value in the individual
int getIndex(long int* individual, long int element)
{
	int i;
	int position;
	for (i=0; i<n; i++)
	{
		if (individual[i]==element)
			position=i;
	}
	
	return position;
}

/*--------------------------------------------------------------------------------------------------*/
/*                           EVALUATION OF TOTAL WEIGHTED TARDINESS                                 */
/*--------------------------------------------------------------------------------------------------*/

 int compute_evaluation_function( long int *p ) {
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

/*--------------------------------------------------------------------------------------------------*/
/*                                   CROSSOVER                                                      */
/*--------------------------------------------------------------------------------------------------*/


long int* crossover (long int**parents, long int father, long int mother)
{
	long int* offspring;
	long int* simFacilities;//tells the similar values between parents and offspring
	long int* dlb; //don't look bit
	
	offspring=malloc (sizeof(long int)*n);
	simFacilities=malloc (sizeof(long int)*n);
	dlb = malloc (sizeof (long int)*n);
	
	int i;
	//init dlb and facilities
	for (i=0; i<n; i++)
	{
		simFacilities[i]=0;
		dlb[i]=0;
	}
	
	for (i=0; i<n; i++)
	{
		if (parents[father][i]==parents[mother][i])
		{
			offspring[i]=parents[father][i];
			dlb[i]=1;;
			simFacilities[offspring[i]]=1;
		}
	}
	
	long int element;
	long int index;
	for (i=0; i<n; i++)
	{
		if (dlb[i]==0)
		{
			//selection of the parent
			int parent=rand()%10;
			if (parent>5)
			{
				parent=mother;
				element =parents[father][i];
			}
			else
			{
				parent=father;
				element =parents[mother][i];
			}
			
			offspring[i]=parents[parent][i];
			dlb[i]=1;     
			//while the next element is not similar to the first added one
			while (element!=offspring[i])
			{
				index=getIndex(parents[parent], element);	  
				offspring[index]=parents[parent][index];
				dlb[index]=1;  
				if (parent == mother)
				{
					element =parents[father][index];
				}
				else
				{
					element =parents[mother][index];
				}
			}
		}
    }
	
	return offspring;
}

/*--------------------------------------------------------------------------------------------------*/
/*                                   MUTATION                                                       */
/*--------------------------------------------------------------------------------------------------*/
long int* mutation(long int **parents, long int parent, long int dist_mut)
{
	
	long int* offspring;
	offspring=malloc (sizeof(long int)*n);
	int i;
	for (i=0; i<n; i++)
		offspring[i]=parents[parent][i];
	long int pos1;
	long int pos2;
	pos1=rand()%n;
	pos2=rand()%n;
	while(pos1==pos2)
		pos2=rand()%n;
	for (i=0; i<dist_mut; i++)
	{
		long int tempFac=offspring[pos1];
		offspring[pos1]=offspring[pos2];
		offspring[pos2]=tempFac;
		pos1=pos2;
		pos2=rand()%n;
		while(tempFac==pos2 || pos1==pos2)
			pos2=rand()%n;
	}
	
	return offspring;
}


/*--------------------------------------------------------------------------------------------------*/
/*                                   DIVERSIFICATION                                                */
/*--------------------------------------------------------------------------------------------------*/

double getDistance(long int * ind1, long int * ind2)
{
	int distance=0;
	int k;
	for (k=0; k<n; k++)
	{
		if (ind1[k]!=ind2[k])
			distance++;
	}
	return distance;
}


double averageDistance(long int**parents, int size)
{
	double av=0;
	int i,j;
	for (i=0; i<size; i++)
	{
		for (j=i+1; j<size; j++)
		{
			av+=getDistance(parents[i],parents[j]);
		}
	}
	av=av/n;
	return av;  
}


double averageFitness(long int**parents, int size)
{
	double av=0;
	int i;
	for (i=0; i<size; i++)
	{
		av+=compute_evaluation_function(parents[i]);
	}
	av=av/n;
	return av;  
}

int stableFitness(double * average_fitness, int size)
{
	int stable=1;
	int i;
	for (i=0; i<size-1; i++)
	{
		if (average_fitness[i]!=average_fitness[i+1])
			stable=0;
	}
	return stable;
}

int findBestIndividual (long int **parents, int pop_size)
{
	int pos=0;
	long int bestVal;
	bestVal=compute_evaluation_function(parents[0]);
	int k;
	for (k=1; k<pop_size; k++)
	{
		if (compute_evaluation_function(parents[k])<bestVal)
		{
			pos=k;
			bestVal=compute_evaluation_function(parents[k]);
		}
	}
	return pos;
}
/*--------------------------------------------------------------------------------------------------*/
/*                                   SELECTION                                                      */
/*--------------------------------------------------------------------------------------------------*/
long int ** selection (long int**parents, long int size, long int minSize)
{
	long int ** selection;
	long int * dlb;
	dlb=malloc(sizeof(long int)*size);
	selection = malloc (sizeof(long int)*minSize);
	int firststep=1;
	int i;
	for (i=0; i<size;i++)
		dlb[i]=0;
	
	for (i=0; i<minSize;i++)
	{
		long int * bestIndividual;
		int k=0;
		while (dlb[k]!=0)
			k++;
		bestIndividual=parents[k];
		
		int posBest=k;
		for(; k<size; k++)
		{
			if (compute_evaluation_function(parents[k])<compute_evaluation_function(bestIndividual) && dlb[k]==0 && inSelection(selection,i,parents[k], firststep)==0 )
			{
				bestIndividual=parents[k];
				posBest=k;
			}
		}
		firststep=0;
		selection[i]=bestIndividual;
		dlb[posBest]=1;
	}	
	return selection;
}

int inSelection (long int ** pop, int size, long int* individual, int check)
{
	if (check==0)
	{
		int j;
		int in=0;
		for (j=0; j<size; j++)
		{
			if (sameIndividual(pop[j], individual)==1)
				in=1;
		}
		return in;
	}
	else
		return 0;
}         
int sameIndividual(long int* ind1, long int* ind2)
{
	int same=1;      
	int i;
	for (i=0; i<n; i++)
	{
		if (ind1[i]!=ind2[i])
			same=0;
	}
	return same;
}

/*--------------------------------------------------------------------------------------------------*/
/*										IMPROVEMENT                                                 */
/*--------------------------------------------------------------------------------------------------*/

int pivoting_rule(neighborhood neighbor,long int *current_parent){
	int i,j;
	int current_objective_value;
	int previous_objective_value; 
	int evaluation_function_value;
	long int copy_candidate_solution[n];
	
	copyVector(current_parent, copy_candidate_solution, n);
	evaluation_function_value = compute_evaluation_function(copy_candidate_solution);
	current_objective_value = evaluation_function_value;
	
	do{
		previous_objective_value = current_objective_value;
		for (i=0; i < n; i++) {
			for (j=i+1; j < n; j++) {
				neighbor(copy_candidate_solution, i,j);
				checkForPermut(copy_candidate_solution, n);
				evaluation_function_value  = compute_evaluation_function(copy_candidate_solution);
				if (evaluation_function_value < current_objective_value) {
					current_objective_value = evaluation_function_value;
					copyVector(copy_candidate_solution,current_parent, n);
					if (strcmp(option_improv,"--first") == 0) {
						break;
					}
				}
				copyVector(current_parent, copy_candidate_solution, n);			
			}
			if (strcmp(option_improv,"--first") == 0) {
				if (evaluation_function_value == current_objective_value) {
					break;
				}
			}
		}
	}while(current_objective_value != previous_objective_value );
	
	//printf("The objective function value is %d\n\n",current_objective_value);
	
	return current_objective_value;
}

/*--------------------------------------------------------------------------------------------------*/
/*                                   INITIALISATION                                                 */
/*--------------------------------------------------------------------------------------------------*/

neighborhood initializePopulation(long int **parents,long int *objectiveValue,long int pop_size){
	
	neighborhood neighbor = chooseNeighborhood(option_neighbor);
	
	int i;
	for (i=0; i<pop_size; i++)
	{
		parents[i]=random_generator(n);
		objectiveValue[i]=pivoting_rule(neighbor,parents[i]);
	}
	return neighbor;
	
}

/***************************************************************************************************/
/*										MEMETIC ALGORITHM										   */
/***************************************************************************************************/

int main(int argc,char *argv[]){
	
	srand(time(NULL));
	char instance_buf[LINE_BUF_LEN];
	char solution_buf[LINE_BUF_LEN];
	int solution_file_flag;
	FILE *instance_file;           /* input file to read in the instance */
	
    setbuf(stdout,NULL);
	printf(PROG_ID_STR);
	
	argv++;
	/* evaluate program-params */
	if (argc == 4) {
		strncpy (instance_buf, *argv++, 100);
		solution_file_flag = 0;
	}
	else if (argc == 5) {
		strncpy (instance_buf, *argv++, 100);
		strncpy (solution_buf, *argv++, 100);
		solution_file_flag = 1;
	}
	else {
		printf("Error in you syntaxe : to launch the program please use one of the following expressions\n");
		printf (CALL_SYNTAX_STR);
		exit(1);
	}

	instance_file = fopen(instance_buf, "r");
	
	if (instance_file == NULL) {
		printf("Error : couldn't open the file\n");
		exit(1);
	}
	
	
	int finish = 0;
	int counter = 1;
	time_t start, stop;
	double computation_time;
	
	
	
	//number of children and mutants in each loop
	long int nb_cross=pop_size/2;
	long int nb_mut=pop_size/4;
	//distance that has to be respected
	long int dist_mut=4;
	
	double* average_fitness;
	int fitnessGen;
	int max_fitness=30;
	

	allocateMemory();
	
	/* INITIALISATION OF THE OPTIONS */
	option_improv = *argv++;
	option_neighbor = *argv;
	
	time(&start);
	printf("neighbor : %s\n", option_neighbor);
	printf("improvement : %s\n", option_improv);
	
		
	while(TRUE){
		int i;
		//printf("%d\n\n",counter);
		finish = printProcessingTime(instance_file,processing_time,n);
		if (finish == 1) {
			break;
		}
		printWeights(instance_file,weight,n);
		printDueDate(instance_file, due_date,n);
		printCandidateSolution(instance_file, candidate_solution, solution_file_flag,n, solution_buf);
		if(counter==86){
		/*-------------------------------------------------------------------------------*/
		/*                              INITIALISATION                                   */
		/*-------------------------------------------------------------------------------*/
		parents = malloc (sizeof(long int)*pop_size);
		crossed_pop = malloc (sizeof(long int)*nb_cross);
		mutant_pop = malloc (sizeof(long int)*nb_mut);
		
		new_generation = malloc (sizeof(long int)*(pop_size+nb_cross+nb_mut));
		
		objectiveValue = malloc (sizeof(long int)*pop_size);
		
		average_fitness = malloc (sizeof(double)*30);
		
		for (i=0; i<pop_size; i++)
			parents[i]=malloc(sizeof(long int)*n);
		
		for (i=0; i<nb_cross; i++)
			crossed_pop[i]=malloc(sizeof(long int)*n);
		
		for (i=0; i<nb_mut; i++)
			mutant_pop[i]=malloc(sizeof(long int)*n);
		
		fitnessGen=0;

		neighborhood neighbor = initializePopulation(parents,objectiveValue,pop_size);
		

		average_fitness[fitnessGen]=averageFitness(parents, pop_size);
		fitnessGen++;
		float startTime = clock()/CLOCKS_PER_SEC;
		
		while ((float)clock()/CLOCKS_PER_SEC - startTime < 10)
		{
			
			/*-------------------------------------------------------------------------------*/
			/*                              CROSSOVER										 */
			/*-------------------------------------------------------------------------------*/				
			//New Generation of offsprings - randomly select two parent and create an offspring according to the CX
			//indices of the two parents in theparents table
			long int father;
			long int mother;
			
			for (i=0; i<nb_cross; i++)
			{
				father = rand()%pop_size;
				do
				{
					mother = rand()%pop_size;
				}while (mother==father);
				crossed_pop[i]=crossover(parents, father, mother);
			}
			
					
			/*-------------------------------------------------------------------------------*/
			/*                              MUTATION										 */
			/*-------------------------------------------------------------------------------*/
			//New Generation of mutants - randomly select an individual in the parents and create a mutant
			//according to the distance parameter
			long int parent;
			for (i=0; i<nb_mut; i++)
			{
				
				parent=rand()%pop_size;	  
				mutant_pop[i]=mutation(parents, parent, dist_mut);					
			}	  
			
			/*-------------------------------------------------------------------------------*/
			/*                              SELECTION										 */
			/*-------------------------------------------------------------------------------*/
			//Through the parents, selection of the fittest set of individual according to their objective
			//value and improving it with the First Improvement algo applied to each of them
			//assembling all the differents kinds of individuals in one set
			for (i=0; i<pop_size;i++)
			{
				new_generation[i]=parents[i];
			}
			for (i=0; i<nb_cross;i++)
			{
				new_generation[pop_size+i]=crossed_pop[i];
			}
			for (i=0; i<nb_mut;i++)
			{
				new_generation[pop_size+nb_cross+i]=mutant_pop[i];
			}
			
			parents= selection (new_generation, (pop_size+nb_cross+nb_mut), pop_size);
			for (i=0; i<pop_size; i++)
			{  
				objectiveValue[i]=pivoting_rule(neighbor,parents[i]);
			}
			
			if(fitnessGen==max_fitness)
			{
				int a;
				for (a=0; a<max_fitness-1; a++)
				{
					average_fitness[a]=average_fitness[a+1];
				}
				average_fitness[max_fitness]=averageFitness(parents, pop_size);
			}
			else
			{
				average_fitness[fitnessGen]=averageFitness(parents, pop_size);
				fitnessGen++;
			}
			/*-------------------------------------------------------------------------------*/
			/*                              DIVERSIFICATION                                  */
			/*-------------------------------------------------------------------------------*/				
			//Checking if the process of optimisation is converging, if it is, mutation of all the individual
			//appart from the fittest, if not, continue the loop
			if (averageDistance(parents, pop_size)<10 || stableFitness(average_fitness, fitnessGen)==1)
			{
				int bestInd=findBestIndividual (parents, pop_size);
				for (i=0; i<pop_size; i++)
				{
					if (i!=bestInd)
					{
						parents[i]=mutation(parents, i, dist_mut);
						objectiveValue[i]=pivoting_rule(neighbor,parents[i]);						
					}
				}
			}
		}
		
		int best_obj_value = compute_evaluation_function(parents[findBestIndividual(parents, pop_size)]);
		printf ("%d \n",best_obj_value);
		//fprintf(results, "%d\n", best_obj_value);
		free (parents);
		free (crossed_pop);
		free (mutant_pop);
		free (new_generation);
		free (objectiveValue);
		}
		counter++;
		
	}
		

	time(&stop);
	computation_time = difftime(stop,start);
	printf("Computation_time : %4.10f\n", computation_time);
	fclose(instance_file);
	freeMemory();
	return 0;
}
