#include "Utils.h"

//use this first function to seed the random number generator,
//call this before any of the other functions
void Utils::initrand(){
    srand((unsigned)(time(0)));
} 

//generates a psuedo-random float between min and max
float Utils::r(float min,float max){    
    return (max-min)*(rand()/((float)(RAND_MAX)+1))+min;
} 

//generates a normally distributed psuedo-random float with a certain mean and standard deviation
float Utils::rnormal(float mean, float std_dev){
    /*
     Use the polar form of the Box-Muller transformation to obtain a pseudo      random number from a Gaussian distribution
     */
    float x1, x2, w, y1; 

    do{       
        x1 = 2.0 * r(0, 1) - 1.0; 
        x2 = 2.0 * r(0, 1) - 1.0;       
        w = x1 * x1 + x2 * x2;       
    }while (w >= 1.0);
    w = sqrt (-2.0 * log (w) / w);
    y1 = x1 * w;  
    y1 = y1 * std_dev + mean;
    return y1; 
}


float Utils::EuclideanDistance(float* x,float* y, int size){
	int i;	
	float dist=0.0;
	for(i=0;i<size;i++){
		dist+=(x[i]-y[i])*(x[i]-y[i]);
	}
	return sqrt(dist);
}

 void Utils::initTab(float *tab, int size){
        for(int i = 0; i < size ; i++)
                tab[i] = 0;
 }
