/*****************************************************************************/
/*                                                                           */
/*      Version:  1.00   Date: 26/02/11   File: smtwto_basic.c               */
/* Last Version:                          File:                              */
/* Changes:                                                                  */
/*                                                                           */
/* Purpose: provide some basic routines for the SMTWTP implementation        */
/*          exercise                                                         */
/*                                                                           */
/* Copyright:  Thomas Stuetzle                                               */
/*                                                                           */
/*****************************************************************************/
/*                                                                           */
/*===========================================================================*/

#include <stdio.h>
#include <math.h>
#include <limits.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

#include "algorithm.h"

#define LINE_BUF_LEN  512
#define PROG_ID_STR "basic routines for SMTWTP, Heuristic Optimization 2011, V1.0\n"
#define CALL_SYNTAX_STR1 "smtwtp_basic <instance> <candidate permutation> \n" 
#define CALL_SYNTAX_STR2 "smtwtp_basic <instance> (<candidate permutation>) <improvement> <neighborhood> <initialisation>\n" 

#define VERBOSE(x)

int main(int argc, char *argv[]) {
	srand(time(NULL));
	char instance_buf[LINE_BUF_LEN];
	char solution_buf[LINE_BUF_LEN];
	int solution_file_flag;
	FILE    *instance_file;           /* input file to read in the instance */
	
    setbuf(stdout,NULL);
	printf(PROG_ID_STR);
	argv++;
	/* evaluate program-params */
	if (argc == 2) {
		strncpy (instance_buf, *argv++, 100);
		solution_file_flag = 0;
	}
	else if (argc == 3) {
		strncpy (instance_buf, *argv++, 100);
		strncpy (solution_buf, *argv++, 100);
		solution_file_flag = 1;
	}
	/* use of parameters init, neighbor and improvement*/
	else if(argc == 5){
		strncpy (instance_buf, *argv++, 100);
		solution_file_flag = 0;
	}
	else if(argc == 6 || argc == 8){
		strncpy (instance_buf, *argv++, 100);
		strncpy (solution_buf, *argv++, 100);
		solution_file_flag = 0;
	}
	else {
		printf("Error in you syntaxe : to launch the program please use one of the following expressions\n");
		printf (CALL_SYNTAX_STR1);
		printf (CALL_SYNTAX_STR2);
		exit(1);
	}
	
	instance_file = fopen(instance_buf, "r");
	
	if (instance_file == NULL) {
		printf("Error : couldn't open the file\n");
		exit(1);
	}
			
	/* ALGORITHM */
	improvement(argv, instance_file, solution_buf,solution_file_flag); 
	//vnd(argv, instance_file, solution_buf,solution_file_flag);
	//piped_vnd(argv, instance_file, solution_buf,solution_file_flag);
	return(0);
}








