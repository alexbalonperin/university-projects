#include "Swarm.h"

Swarm::Swarm()
{
              this->particles = new Particle[PARTICLES];   
              this->constriction = 0.729;
              this->acceleration = 2.05;
              this->inertia = 1; 
              this->damage_coeff=0.3; 
              Utils::initTab(this->solution, DIMENSION);
              this->ranges[0][0] = ATTR0_MIN_RANGE;
              this->ranges[0][1] = ATTR0_MAX_RANGE;
              this->ranges[1][0] = ATTR1_MIN_RANGE;
              this->ranges[1][1] = ATTR1_MAX_RANGE;
              this->ranges[2][0] = ATTR2_MIN_RANGE;
              this->ranges[2][1] = ATTR2_MAX_RANGE;
              this->ranges[3][0] = ATTR3_MIN_RANGE;   
              this->ranges[3][1] = ATTR3_MAX_RANGE;   
              this->ranges[4][0] = ATTR4_MIN_RANGE;   
              this->ranges[4][1] = ATTR4_MAX_RANGE;              
}
Swarm::~Swarm(){
       delete(this->particles);                
}

void Swarm::FullyConnected(int index){
    for(int i=0;i<PARTICLES;i++){
            this->particles[index].setNeighbors(i,1);		       
	}
}

void Swarm::Random(int index){
	for(int i=0;i<PARTICLES;i++){
		if( Utils::r(0.0,1.0) < 0.5 )
			this->particles[index].setNeighbors(i,1);
		else
			this->particles[index].setNeighbors(i,0);
	}
}

void Swarm::Ring(int index){
	for(int i=0;i<PARTICLES;i++){		
		this->particles[index].setNeighbors(i,0);		
	}

	if(index==0)
		this->particles[index].setNeighbors(PARTICLES-1,1);
	else
		this->particles[index].setNeighbors(index-1,1);

	this->particles[index].setNeighbors(index,1);

	if(index==PARTICLES-1)
		this->particles[index].setNeighbors(0,1);
	else
		this->particles[index].setNeighbors(index+1,1);
}



void Swarm::Constricted(int index,int neighbor){
	float evaluation;

	for(int j=0;j<DIMENSION;j++){
		this->particles[index].setV(j, constriction*(inertia*this->particles[index].getV(j) + Utils::r(0.0,acceleration)*(this->particles[index].getPbest(j) - this->particles[index].getX(j)) + Utils::r(0.0,acceleration)*(this->particles[neighbor].getPbest(j) - this->particles[index].getX(j))));
		this->particles[index].setX(j, this->particles[index].getX(j) + this->particles[index].getV(j));		
	}
	
	if(this->particles[index].getPCurrentSolution() < this->particles[index].getPbestSolution()){
		this->particles[index].setPbestSolution(this->particles[index].getPCurrentSolution());
		for(int j=0;j<DIMENSION;j++){
			this->particles[index].setPbest(j, this->particles[index].getX(j));
			solution[j] = this->particles[index].x[j];
		}
	}			
}
void Swarm::Barebones(int index,int neighbor){
	int j;
	float evaluation;

	for(j=0;j<DIMENSION;j++){	
		this->particles[index].setX(j, Utils::rnormal((this->particles[index].getPbest(j)+this->particles[neighbor].getPbest(j))/2.0,fabs(this->particles[index].getPbest(j)-this->particles[neighbor].getPbest(j)))); 	
	}

    if(this->particles[index].getPCurrentSolution() < this->particles[index].getPbestSolution()){
		this->particles[index].setPbestSolution(this->particles[index].getPCurrentSolution());
		for(int j=0;j<DIMENSION;j++){
			this->particles[index].setPbest(j, this->particles[index].getX(j));
		}
	}		
}

void Swarm::FIPS(int index){
	float neighbors;
	float sumneighbors;
	
	for(int j=0;j<DIMENSION;j++){
	  
	  sumneighbors=0.0;	  
	  neighbors=0.0;
	  for(int w=0;w<PARTICLES;w++){
	    if(this->particles[index].getNeighbors(w) == 1){
	      sumneighbors+=this->particles[w].getPbest(j);
	      neighbors++;
	    }
	  }
	  this->particles[index].setV(j, constriction*(this->particles[index].getV(j) + Utils::r(0.0,2.0*acceleration)*(sumneighbors/neighbors - this->particles[index].getX(j))));
      this->particles[index].setX(j, this->particles[index].getX(j) + this->particles[index].getV(j));
	}
    for(int i = 0; i<DIMENSION ; i++){
        if(this->particles[index].getX(i) > ranges[i][1])
             this->particles[index].setX(i,ranges[i][1] );
        else if(this->particles[index].getX(i) < ranges[i][0])
             this->particles[index].setX(i, ranges[i][0] );
    }                                               

	if(this->particles[index].getPCurrentSolution() < this->particles[index].getPbestSolution()){
		this->particles[index].setPbestSolution(this->particles[index].getPCurrentSolution());
		for(int j=0;j<DIMENSION;j++){
			this->particles[index].setPbest(j, this->particles[index].getX(j));
		}
	}		
}



//objective function
float Swarm::ObjFunction(int index){
       return this->particles[index].getLapTime()+ damage_coeff*this->particles[index].getDamage();       
}

void Swarm::runPSO(){
	int bestneighbor;
    bestSolution = 1e100;	
   	for(int i=0;i<PARTICLES;i++){
        this->particles[i].setPCurrentSolution(ObjFunction(i));                      
    }
	for(int i=0;i<PARTICLES;i++){
		bestneighbor=BestNeighbor(i);
		//Barebones(i,bestneighbor);	
        //Constricter(i,bestneighbor);
        FIPS(i);		
	}		
	BestSolution();
}

void Swarm::initializeSwarm(){
	for(int i=0;i<PARTICLES;i++){
		for(int j = 0; j < DIMENSION ; j++){
    		this->particles[i].setX(j, Utils::r(ranges[j][0],ranges[j][1]));
            this->particles[i].setPbest(j, Utils::r(ranges[j][0],ranges[j][1]));
    		this->particles[i].setV(j, 0);
        }
		FullyConnected(i);	
		//Ring(i);
		//Random(i);
		/*
		cout << "Particule " << i << " : "  << endl;
	
		for(int j = 0 ; j < DIMENSION ; j++){
                
               cout << "X : " << this->particles[i].getX(j)<< " " ; 
               cout << "V : " << this->particles[i].getV(j)<< " " ; 
               cout << "Pbest : " << this->particles[i].getPbest(j)<< " " ; 
               cout << endl;       
        }
        cout << endl;
        */
	}
}
float Swarm::BestSolution(){
	int i;
	float solution=1e100;
	for(i=0;i<PARTICLES;i++){
		if(this->particles[i].getPbestSolution() < solution){
			solution = this->particles[i].getPbestSolution();
		}			
	}
	return solution;
}

int Swarm::BestNeighbor(int index){
	int i;	
	int neighborindex=index;

	for(i=0;i<PARTICLES;i++){
		if(this->particles[index].getNeighbors(i) == 1){
			if(this->particles[i].getPbestSolution() < this->particles[index].getPbestSolution()){
				neighborindex = i;				
			}
		}
	}
	return neighborindex;
}

void Swarm::PrintSwarm(){
	int i,j;
	
	for(i=0;i<PARTICLES;i++){
		printf("============================================\n");
		printf("Particle %d:\n",i);
		printf("Current position:\n");
		for(j=0;j<DIMENSION;j++){
			printf("%1.3lf ",this->particles[i].getX(j));
		}
		printf("\n");
		printf("Previous best position:\n");
		for(j=0;j<DIMENSION;j++){
			printf("%1.3lf ",this->particles[i].getPbest(j));
		}
		printf("\n");
		printf("Velocity:\n");
		for(j=0;j<DIMENSION;j++){
			printf("%1.3lf ",this->particles[i].getV(j));
		}
		printf("\n");
		printf("Best solution value = %1.3lf\n",this->particles[i].getPbestSolution());

		printf("Neighbors:\n");
		for(j=0;j<PARTICLES;j++){
			if(this->particles[i].getNeighbors(j) == 1)
				printf("%d ",j);
		}
		printf("\n");
	}
}

void Swarm::PrintSolution(){
  int i;
  printf("Solution: ");
  for(i=0;i<DIMENSION;i++){
    printf("%e\t",solution[i]);
  }
  printf("\n");
}



