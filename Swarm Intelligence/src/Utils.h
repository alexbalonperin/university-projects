#ifndef __UTILS__
#define __UTIL__

#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>


class Utils
{
      private:
              
      public:
             //Random number generators
              static void initrand();			//Initializes RNG seed 
              static float r(float min,float max);	//Returns a random number in the range [min,max)
              static float rnormal(float mean, float std_dev); //Returns a normally distributed random number of given mean and standard deviation
              static float EuclideanDistance(float* x,float* y, int size);
              static void initTab(float *tab, int size);
};

#endif
