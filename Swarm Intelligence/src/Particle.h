#ifndef __PARTICLE__
#define __PARTICLE__

#include <iostream>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <string.h>
#include <float.h>


//======================= Some Constants =======================================
//#define	PI	acos(-1) 

//======================= Parameters =======================================
#define 	PARTICLES 	5
#define 	DIMENSION	5

using namespace std;

class Particle
{
      private:
            float v[DIMENSION];	
            float pbestsolution;
            float pCurrentsolution;
            int neighbors[PARTICLES]; 
            float damage;
            float lapTime;
      public:
             Particle();
             float pbest[DIMENSION];
             float x[DIMENSION];
             int getNeighbors(int index);
             float getX(int index);
             float getV(int index);
             float getPbest(int index);
             float getPbestSolution();
             float getPCurrentSolution();
             float getDamage();
             float getLapTime();
             void setNeighbors(int index, int val);
             void setPbest(int index, float val);
             void setPbestSolution(float val);
             void setPCurrentSolution(float val);
             void setX(int index, float val);
             void setV(int index, float val);
             void setDamage(float damage);
             void setLapTime(float lapTime);
};

#endif
