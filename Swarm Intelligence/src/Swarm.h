#ifndef __SWARM__
#define __SWARM__

#include <iostream>
#include <stdlib.h>
#include <string.h>
#include <float.h>

#include "Utils.h"
#include "Particle.h"

//======================= Some Constants =======================================
#define	PI	acos(-1) 

//======================= Parameters =======================================
#define 	PARTICLES 	5

#define 	DIMENSION	5
#define 	MIN_RANGE 	-5.12
#define		MAX_RANGE	5.12

#define     ATTR0_MIN_RANGE  1
#define     ATTR0_MAX_RANGE  3
#define     ATTR1_MIN_RANGE  25
#define     ATTR1_MAX_RANGE  75
#define     ATTR2_MIN_RANGE  0.5
#define     ATTR2_MAX_RANGE  1.5
#define     ATTR3_MIN_RANGE  0.5
#define     ATTR3_MAX_RANGE  1.5
#define     ATTR4_MIN_RANGE  50
#define     ATTR4_MAX_RANGE  100

#define 	MIN_VEL  	MIN_RANGE
#define		MAX_VEL		MAX_RANGE


using namespace std;

class Swarm
{
      private:
            
            float constriction;
            float acceleration;
            float inertia;
            float bestSolution;
            float ranges[DIMENSION][2];  
            float damage_coeff;
            
      public:
             
              Swarm();
              ~Swarm();
              
              //objective function
              float ObjFunction(int index);
            
             //Neighborhood functions
              void FullyConnected(int index);			//Fully connected topology
              void Random(int index);				//Random
              void Ring(int index);					//Ring
            
             //PSO functions 
              void Constricted(int index,int neighbor);		//Clerc & Kennedy's constricted PSO
              void FIPS(int index);			//Mendes' Fully informed Particle Swarm
              void Barebones(int index,int neighbor);		//Kennedy's Barebones
            
              void initializeSwarm();
              void runPSO();
              float BestSolution();
              int BestNeighbor(int index);
            
             //Utility functions
              void PrintSwarm(); 
              void PrintSolution();
              void PrintSolutionDevelopment();
              
              float solution[DIMENSION];
              Particle *particles; 
};

#endif
