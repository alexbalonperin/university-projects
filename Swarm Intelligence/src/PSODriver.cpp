/***************************************************************************
 
    file                 : PSODriver.cpp
    copyright            : (C) 2007 Daniele Loiacono
 
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

#include "PSODriver.h"


/* Gear Changing Constants*/
const int PSODriver::gearUp[6]=
    {
        5000,6000,6000,6500,7000,0
       
    };
const int PSODriver::gearDown[6]=
    {
        0,2500,3000,3000,3500,3500
    };

/* Stuck constants*/
const int PSODriver::stuckTime = 25;
const float PSODriver::stuckAngle = .523598775; //PI/6

/* Accel and Brake Constants*/
//const float PSODriver::maxSpeedDist=40;
const float PSODriver::maxSpeed=200;
const float PSODriver::sin5 = 0.08716;
const float PSODriver::cos5 = 0.99619;

/* Steering constants*/
//const float PSODriver::steerLock=0.785398;
//const float PSODriver::steerSensitivityOffset=80.0;
//const float PSODriver::wheelSensitivityCoeff=0.8;

/* ABS Filter Constants */
const float PSODriver::wheelRadius[4]={0.3179,0.3179,0.3276,0.3276};
//const float PSODriver::absSlip=2.0;
const float PSODriver::absRange=3.0;
const float PSODriver::absMinSpeed=3.0;

/* Clutch constants */
/*
const float PSODriver::clutchMax=0.5;
const float PSODriver::clutchDelta=0.05;
//const float PSODriver::clutchRange=0.82;
const float PSODriver::clutchDeltaTime=0.02;
const float PSODriver::clutchDeltaRaced=10;
const float PSODriver::clutchDec=0.01;
const float PSODriver::clutchMaxModifier=1.3;
const float PSODriver::clutchMaxTime=1.5;
*/
PSODriver::PSODriver(){
           stuck=0;
           clutch=0.0;
           current_particle=0;
           failed=false;	
           damage = 0.0; 
           lastLapTime = 0.0;
           steerLock=0.82;
           steerSensitivityOffset=80.0;
           wheelSensitivityCoeff=0.8;
           absSlip=2.0;
           maxSpeedDist=30;
           first_round = true;
           iteration=0;
           initParam();                       
}
/*
PSODriver::~PSODriver(){
                        
       delete(this->swarm);                        
}
*/
int
PSODriver::getGear(CarState &cs)
{

    int gear = cs.getGear();
    int rpm  = cs.getRpm();

    // if gear is 0 (N) or -1 (R) just return 1 
    if (gear<1)
        return 1;
    // check if the RPM value of car is greater than the one suggested 
    // to shift up the gear from the current one     
    if (gear <6 && rpm >= gearUp[gear-1])
        return gear + 1;
    else
    	// check if the RPM value of car is lower than the one suggested 
    	// to shift down the gear from the current one
        if (gear > 1 && rpm <= gearDown[gear-1])
            return gear - 1;
        else // otherwhise keep current gear
            return gear;
}

float
PSODriver::getSteer(CarState &cs)
{
	// steering angle is compute by correcting the actual car angle w.r.t. to track 
	// axis [cs.getAngle()] and to adjust car position w.r.t to middle of track [cs.getTrackPos()*0.5]
    float targetAngle=(cs.getAngle()-cs.getTrackPos()*0.5);
    // at high speed reduce the steering command to avoid loosing the control
    if (cs.getSpeedX() > steerSensitivityOffset)
        return targetAngle/(steerLock*(cs.getSpeedX()-steerSensitivityOffset)*wheelSensitivityCoeff);
    else
        return (targetAngle)/steerLock;

}
float
PSODriver::getAccel(CarState &cs)
{
    // checks if car is out of track
    if (cs.getTrackPos() < 1 && cs.getTrackPos() > -1)
    {
        // reading of sensor at +5 degree w.r.t. car axis
        float rxSensor=cs.getTrack(10);
        // reading of sensor parallel to car axis
        float cSensor=cs.getTrack(9);
        // reading of sensor at -5 degree w.r.t. car axis
        float sxSensor=cs.getTrack(8);

        float targetSpeed;

        // track is straight and enough far from a turn so goes to max speed
        if (cSensor>maxSpeedDist || (cSensor>=rxSensor && cSensor >= sxSensor))
            targetSpeed = maxSpeed;
        else
        {
            // approaching a turn on right
            if(rxSensor>sxSensor)
            {
                // computing approximately the "angle" of turn
                float h = cSensor*sin5;
                float b = rxSensor - cSensor*cos5;
                float sinAngle = b*b/(h*h+b*b);
                // estimate the target speed depending on turn and on how close it is
                targetSpeed = maxSpeed*(cSensor*sinAngle/maxSpeedDist);
            }
            // approaching a turn on left
            else
            {
                // computing approximately the "angle" of turn
                float h = cSensor*sin5;
                float b = sxSensor - cSensor*cos5;
                float sinAngle = b*b/(h*h+b*b);
                // estimate the target speed depending on turn and on how close it is
                targetSpeed = maxSpeed*(cSensor*sinAngle/maxSpeedDist);
            }

        }

        // accel/brake command is expontially scaled w.r.t. the difference between target speed and current one
        return 2/(1+exp(cs.getSpeedX() - targetSpeed)) - 1;
    }
    else
        return 0.3; // when out of track returns a moderate acceleration command

}
void PSODriver::initParam(){
     //Random no. generator initialized
	 Utils::initrand();
	 
	 //initialize the swarm
     swarm = new Swarm();
     swarm->initializeSwarm();
     setParam();		
}


CarControl
PSODriver::wDrive(CarState cs)
{
    
	// check if car is currently stuck
	if ( fabs(cs.getAngle()) > stuckAngle )
    {
		// update stuck counter
        stuck++;
    }
    else
    {
    	// if not stuck reset stuck counter
        stuck = 0;
    }

	// after car is stuck for a while apply recovering policy
    if (stuck > stuckTime)
    {
    	/* set gear and sterring command assuming car is 
    	 * pointing in a direction out of track */
    	
    	// to bring car parallel to track axis
        float steer = - cs.getAngle() / steerLock; 
        int gear=-1; // gear R
        
        // if car is pointing in the correct direction revert gear and steer  
        if (cs.getAngle()*cs.getTrackPos()>0)
        {
            gear = 1;
            steer = -steer;
        }

        // Calculate clutching
       // clutching(cs,clutch);

        // build a CarControl variable and return it
        // accel,brake,gear,steer,clutch
        if(cs.getCurLapTime() > TIME_LIMIT  & iteration < MAX_ITERATIONS){
              failed = true; 
              this->lastLapTime = cs.getCurLapTime();
              this->damage = cs.getDamage();              
              //CarControl cc (0,0,0,0,0,0,CarControl::META_RESTART);
              CarControl cc(1.0,0.0,gear,steer,CarControl::META_RESTART);
              return cc;
        }
        
        else{
              //CarControl cc ((float)1.0,(float)0.0,gear,steer,clutch);
             CarControl cc ((float)1.0,(float)0.0,gear,steer);
              return cc;
        }
        
    }

    else // car is not stuck
    {
    	// compute accel/brake command
        float accel_and_brake = getAccel(cs);
        // compute gear 
        int gear = getGear(cs);
        // compute steering
        float steer = getSteer(cs);
        

        // normalize steering
        if (steer < -1)
            steer = -1;
        if (steer > 1)
            steer = 1;
        
        // set accel and brake from the joint accel/brake command 
        float accel,brake;
        if (accel_and_brake>0)
        {
            accel = accel_and_brake;
            brake = 0;
        }
        else
        {
            accel = 0;
            // apply ABS to brake
            brake = filterABS(cs,-accel_and_brake);
        }

        // Calculate clutching
//        clutching(cs,clutch);
  
        // build a CarControl variable and return it
        if(cs.getLastLapTime() > 0 && iteration < MAX_ITERATIONS){ 
            this->lastLapTime = cs.getLastLapTime();
            this->damage = cs.getDamage();
            //CarControl cc (1.0,0.0,gear,steer,clutch,0,1);
            CarControl cc(1.0,0.0,gear,steer,1);
            return cc;
        }
        else{
            //CarControl cc(accel,brake,gear,steer,clutch);
           CarControl cc(accel,brake,gear,steer);
            return cc;
        }
    }
}

float
PSODriver::filterABS(CarState &cs,float brake)
{
	// convert speed to m/s
	float speed = cs.getSpeedX() / 3.6;
	// when spedd lower than min speed for abs do nothing
    if (speed < absMinSpeed)
        return brake;
    
    // compute the speed of wheels in m/s
    float slip = 0.0f;
    for (int i = 0; i < 4; i++)
    {
        slip += cs.getWheelSpinVel(i) * wheelRadius[i];
    }
    // slip is the difference between actual speed of car and average speed of wheels
    slip = speed - slip/4.0f;
    // when slip too high applu ABS
    if (slip > absSlip)
    {
        brake = brake - (slip - absSlip)/absRange;
    }
    
    // check brake is not negative, otherwise set it to zero
    if (brake<0)
    	return 0;
    else
    	return brake;
}

void
PSODriver::onShutdown()
{
    cout << "shutdown!" << endl;
}

void
PSODriver::onRestart()
{   
    cout << "Restarting the race!" << endl;
    cout << "##########################################################" << endl;     
    cout << "Iteration : " << iteration+1 << endl; 
    cout << "##########################################################" << endl; 

    iteration++;
    if(iteration == MAX_ITERATIONS){
          swarm->runPSO();
           for(int i = 0; i< PARTICLES ; i++)
                  cout << "PbestSolution for particule " << i << " = " << swarm->particles[i].getPbestSolution() << endl;
          cout << endl;
          setFinalParam();
          cout << "##########################################################" << endl;     
          cout << "#                   STARTING RACE...                        " << endl;
          cout << "##########################################################" << endl;                            
    }
    else
        newIteration();  
                 
}
/*
void
PSODriver::clutching(CarState &cs, float &clutch)
{
  float maxClutch = clutchMax;

  // Check if the current situation is the race start
   if (cs.getCurLapTime()<clutchDeltaTime  && stage==RACE && cs.getDistRaced()<clutchDeltaRaced)
    clutch = maxClutch;

  // Adjust the current value of the clutch
  if(clutch > 0)
  {
    float delta = clutchDelta;
    if (cs.getGear() < 2)
	{
      // Apply a stronger clutch output when the gear is one and the race is just started
	  delta /= 2;
      maxClutch *= clutchMaxModifier;
      if (cs.getCurLapTime() < clutchMaxTime)
        clutch = maxClutch;
	}

    // check clutch is not bigger than maximum values
	clutch = min(maxClutch,float(clutch));

	// if clutch is not at max value decrease it quite quickly
	if (clutch!=maxClutch)
	{
	  clutch -= delta;
	  clutch = max(0.0,float(clutch));
	}
	// if clutch is at max value decrease it very slowly
	else
		clutch -= clutchDec;
  }
}
*/
void 
PSODriver::newIteration(){

      //runPSO --> getBestParticle among all of them and then change position of each particle accordingly  
     //keep in memory the best so far particle attribute, the value of the fitness and the laptime    
     
     if(failed){
            //car stuck or very bad config --> objective function = 0
            swarm->particles[current_particle].setLapTime(1e10);
            swarm->particles[current_particle].setDamage(1e10);
     }   
      else  {
            swarm->particles[current_particle].setLapTime(this->lastLapTime);
            swarm->particles[current_particle].setDamage(this->damage);
            
      }
      
      cout << "Damages for particule " << current_particle << " = " << this->damage << endl;
      cout << "TimeLap for particule " << current_particle << " = " << this->lastLapTime << endl;
      cout << endl;
      
     current_particle++;  
      
     if(current_particle == PARTICLES){
          if(first_round){
              for(int i = 0; i < PARTICLES ; i++){
                      float evaluation = swarm->ObjFunction(i);
                      swarm->particles[i].setPbestSolution(evaluation);
                      swarm->particles[i].setPCurrentSolution(evaluation);
              }
              first_round = false;
          }
          current_particle = 0; 
          swarm->runPSO();
          for(int i = 0; i< PARTICLES ; i++)
                  cout << "PbestSolution for particule " << i << " = " << swarm->particles[i].getPbestSolution() << endl;
          cout << endl;
     } 

     setParam();     
}

void
PSODriver::setParam(){
     //set the 5 parameters of the car with the values of the particule i 
     //must be done for each lap
     this->absSlip = swarm->particles[current_particle].getX(0);
     this->maxSpeedDist = swarm->particles[current_particle].getX(1);
     this->wheelSensitivityCoeff = swarm->particles[current_particle].getX(2);
     this->steerLock = swarm->particles[current_particle].getX(3);
     this->steerSensitivityOffset = swarm->particles[current_particle].getX(4); 
     cout << "Current Particule : " << current_particle << endl; 
     cout << "Parameters: " << endl;
     cout << "ABSSlip = " <<  this->absSlip << endl;
     cout << "MaxSpeedDistance = " <<  this->maxSpeedDist << endl;
     cout << "WheelSensitivityCoeff = " <<  this->wheelSensitivityCoeff << endl;
     cout << "Steerlock = " <<  this->steerLock << endl;
     cout << "SteerSensitivityCoeff = " <<  this->steerSensitivityOffset << endl;
     cout << endl ;
      
}

void
PSODriver::setFinalParam(){
     //set the 5 parameters of the car with the best values found by PSO 

     this->absSlip = this->swarm->solution[0];
     this->maxSpeedDist = this->swarm->solution[1];
     this->wheelSensitivityCoeff = this->swarm->solution[2];
     this->steerLock = this->swarm->solution[3];
     this->steerSensitivityOffset = this->swarm->solution[4]; 
     cout << "Best Parameters found by PSO : " << endl; 
     cout << "ABSSlip = " <<  this->absSlip << endl;
     cout << "MaxSpeedDistance = " <<  this->maxSpeedDist << endl;
     cout << "WheelSensitivityCoeff = " <<  this->wheelSensitivityCoeff << endl;
     cout << "Steerlock = " <<  this->steerLock << endl;
     cout << "SteerSensitivityCoeff = " <<  this->steerSensitivityOffset << endl;
     cout << endl << endl;
      
}

void
PSODriver::init(float *angles)
{
	// set angles as {-90,-75,-60,-45,-30,20,15,10,5,0,5,10,15,20,30,45,60,75,90}

	for (int i=0; i<5; i++)
	{
		angles[i]=-90+i*15;
		angles[18-i]=90-i*15;
	}

	for (int i=5; i<9; i++)
	{
			angles[i]=-20+(i-5)*5;
			angles[18-i]=20-(i-5)*5;
	}
	angles[9]=0;
}
