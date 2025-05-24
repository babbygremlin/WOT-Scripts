//------------------------------------------------------------------------------
// Wind.uc
// $Author: Aleiby $
// $Date: 10/10/99 9:20p $
// $Revision: 2 $
//
// Description:	Simulates wind for a particle sprayer.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Place in level.
// + Set ImpulseTime and Windspeed.
// + Link to desired ParticleSprayers via Tag and Event.
//------------------------------------------------------------------------------
class Wind expands Effects;

// How often (in seconds) we change windspeed.
var() float MaxImpulseTime;
var() float MinImpulseTime;

// Windspeed -- direction is dictated by rotation.
var() float MaxWindspeed;
var() float MinWindspeed;

var vector LastWindspeed;

// Trigger variables.
var() bool bInitiallyOn;
var bool bOn;
var() float TimerDuration;
var float TriggerTime;

replication
{
	reliable if( Role==ROLE_Authority )
		MaxImpulseTime,
		MinImpulseTime,

		MaxWindspeed,
		MinWindspeed,

		bInitiallyOn,
		TimerDuration;
}

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	bOn = bInitiallyOn;	
	Timer();
}

//------------------------------------------------------------------------------
simulated function SetSpeed( float Speed )
{
	local ParticleSprayer IterPS;
	local vector Windspeed;

	Windspeed = (vect(1,0,0) * Speed) >> Rotation;

	if( Event != '' )
	{
		foreach AllActors( class'ParticleSprayer', IterPS, Event )
		{
			if( !IterPS.bIsWindResistant )
			{
				IterPS.Gravity -= LastWindspeed;
				IterPS.Gravity += Windspeed;
			}
		}
	}

	LastWindspeed = WindSpeed;
}

//------------------------------------------------------------------------------
simulated function ResetSpeed()
{
	local ParticleSprayer IterPS;
	
	if( Event != '' )
	{
		foreach AllActors( class'ParticleSprayer', IterPS, Event )
		{
			IterPS.Gravity -= LastWindspeed;
		}
	}

	LastWindspeed = vect(0,0,0);
}

//------------------------------------------------------------------------------
simulated function Timer()
{
	if( bOn )
	{
		SetSpeed( RandRange( MinWindspeed, MaxWindspeed ) );
		SetTimer( RandRange( MinImpulseTime, MaxImpulseTime ), False );
	}
}

//------------------------------------------------------------------------------
// Toggles us on and off when triggered.
//------------------------------------------------------------------------------
simulated state() TriggerToggle
{
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		bOn = !bOn;

		if( bOn )	Timer();
		else		ResetSpeed();
	}
}

//------------------------------------------------------------------------------
// Toggled when Triggered.
// Toggled back to initial state when UnTriggered.
//------------------------------------------------------------------------------
simulated state() TriggerControl
{
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		bOn = !bInitiallyOn;
		
		if( bOn )	Timer();
		else		ResetSpeed();
	}

	simulated function UnTrigger( Actor Other, Pawn EventInstigator )
	{
		bOn = bInitiallyOn;
		
		if( bOn )	Timer();
		else		ResetSpeed();
	}
}

//------------------------------------------------------------------------------
// Toggled when triggered.
// Toggled back to initial state after TimerDuration seconds.
//------------------------------------------------------------------------------
simulated state() TriggerTimed
{
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		TriggerTime = Level.TimeSeconds + TimerDuration;

		bOn = !bInitiallyOn;
		
		if( bOn )	Timer();
		else		ResetSpeed();
	}
	
	simulated function Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );

		if( Level.TimeSeconds >= TriggerTime )
		{
			bOn = bInitiallyOn;
			
			if( bOn )	Timer();
			else		ResetSpeed();
		}
	}
}

defaultproperties
{
     bInitiallyOn=True
     bHidden=True
     RemoteRole=ROLE_SimulatedProxy
     bDirectional=True
     DrawType=DT_Sprite
}
