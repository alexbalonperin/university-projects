#include "Particle.h"
Particle::Particle(){
                          
}

int Particle::getNeighbors(int index){
      return this->neighbors[index];
}

float Particle::getX(int index){
       return this->x[index]; 
}

float Particle::getV(int index){
         return this->v[index];
}

float Particle::getPbest(int index){
         return this->pbest[index];
}

float Particle::getPbestSolution(){
       return this->pbestsolution;
}

float Particle::getPCurrentSolution(){
       return this->pCurrentsolution;
}

float Particle::getDamage(){
       return this->damage;
}

float Particle::getLapTime(){
       return this->lapTime;
}

void Particle::setNeighbors(int index, int val){
     this->neighbors[index] = val;    
}

void Particle::setPbest(int index, float val){
     this->pbest[index] = val;    
}

void Particle::setPbestSolution(float val){
      this->pbestsolution = val;
}

void Particle::setPCurrentSolution(float val){
      this->pCurrentsolution = val;
}

void Particle::setX(int index, float val){
     this->x[index] = val;     
}

void Particle::setV(int index, float val){
     this->v[index] = val;     
}

void Particle::setDamage(float damage){
     this->damage = damage;     
}

void Particle::setLapTime(float lapTime){
     this->lapTime = lapTime;     
}
