/***************************************************************************

    file                 : SimpleDriver.cpp
    copyright            : (C) 2007 Daniele Loiacono

 ***************************************************************************/

#include "SimpleDriver.h"
SimpleDriver::SimpleDriver()
{

}
/* Gear Changing Constants*/
const int SimpleDriver::gearUp[6]=
    {
        5000,6000,6000,6500,7000,0
    };
const int SimpleDriver::gearDown[6]=
    {
        0,2500,3000,3000,3500,3500
    };

/* Stuck constants*/
const int SimpleDriver::stuckTime = 25;
const float SimpleDriver::stuckAngle = .523598775; //PI/6

/* Accel and Brake Constants*/
const float SimpleDriver::maxSpeedDist=70;
const float SimpleDriver::maxSpeed=150;
const float SimpleDriver::sin10 = 0.17365;
const float SimpleDriver::cos10 = 0.98481;

/* Steering constants*/
const float SimpleDriver::steerLock=0.785398;
const float SimpleDriver::steerSensitivityOffset=80.0;
const float SimpleDriver::wheelSensitivityCoeff=1;

/* ABS Filter Constants */
const float SimpleDriver::wheelRadius[4]={0.3179,0.3179,0.3276,0.3276};
const float SimpleDriver::absSlip=2.0;
const float SimpleDriver::absRange=3.0;
const float SimpleDriver::absMinSpeed=3.0;

int
SimpleDriver::getGear(CarState &cs)
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
SimpleDriver::getSteer(CarState &cs)
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
SimpleDriver::getAccel(CarState &cs)
{
    // checks if car is out of track
    if (cs.getTrackPos() < 1 && cs.getTrackPos() > -1)
    {
        // reading of sensor at +10 degree w.r.t. car axis
        float rxSensor=cs.getTrack(10);
        // reading of sensor parallel to car axis
        float cSensor=cs.getTrack(9);
        // reading of sensor at -10 degree w.r.t. car axis
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
                float h = cSensor*sin10;
                float b = rxSensor - cSensor*cos10;
                float sinAngle = b*b/(h*h+b*b);
                // estimate the target speed depending on turn and on how close it is
                targetSpeed = maxSpeed*(cSensor*sinAngle/maxSpeedDist);
            }
            // approaching a turn on left
            else
            {
                // computing approximately the "angle" of turn
                float h = cSensor*sin10;
                float b = sxSensor - cSensor*cos10;
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

CarControl
SimpleDriver::wDrive(CarState cs)
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
        // build a CarControl variable and return it
        CarControl cc (1.0,0.0,gear,steer);
        return cc;
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
        // build a CarControl variable and return it
        CarControl cc(accel,brake,gear,steer);
        return cc;
    }
}

float
SimpleDriver::filterABS(CarState &cs,float brake)
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
SimpleDriver::onShutdown()
{
    cout << "Bye bye! JAAAAH" << endl;
}

void
SimpleDriver::onRestart()
{
    cout << "Restarting the race!" << endl;
}

