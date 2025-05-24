//------------------------------------------------------------------------------
// AirBlastProj.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AirBlastProj expands ParticleSprayer;

#exec OBJ LOAD FILE=Textures\AirPulseDartT.utx PACKAGE=Angreal.AirBurst

var vector LastRALocation;
var Actor RelativeActor;
var vector RelativeActorLocation;

var vector Offset;

var() float BlastDuration;

var AirBlastBall Ball;
var float BallTimer;

var bool bCreatedBall;

replication
{
	reliable if( Role==ROLE_Authority )
		RelativeActor;

	reliable if( Role==ROLE_Authority && bNetInitial )
		Offset;
		
	unreliable if( Role==ROLE_Authority && !RelativeActor.bNetRelevant )
		RelativeActorLocation;
}

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();

	SetTimer( BlastDuration, false );
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Ball != None )
	{
		Ball.Destroy();
		Ball = None;
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	if( RelativeActor != None )
	{
		RelativeActorLocation = RelativeActor.Location;
	}
	
	// Keep particles relative to player.
	if( LastRALocation != vect(0,0,0) )
	{
		ShiftParticles( RelativeActorLocation - LastRALocation );

		if( Ball != None )
		{
			Ball.ShiftParticles( RelativeActorLocation - LastRALocation );
		}
	}
	LastRALocation = RelativeActorLocation;

	// Get initial offset from player.
	if( Offset == vect(0,0,0) )
	{
		Offset = Location - RelativeActorLocation;
	}

	// Update location relative to player.
	Offset += Velocity * DeltaTime;
	SetLocation( RelativeActorLocation + Offset );

	// Update ball.
	if( !bCreatedBall )
	{
		bCreatedBall = true;
		Ball = Spawn( class'AirBlastBall',,, Location, rotator(Velocity) );
		BallTimer = Level.TimeSeconds + BlastDuration - 0.20;
	}
	else if( Ball != None )
	{
		if( Level.TimeSeconds > BallTimer )
		{
			if( Ball.bOn )
			{
				Ball.bOn = false;
				Ball.LifeSpan = 1.0;
				//Ball.Destroy();
				//Ball = None;
			}
		}
		else
		{
			Ball.SetLocation( Location );
		}
	}
}

//------------------------------------------------------------------------------
simulated function Timer()
{
	bOn = false;
	LifeSpan = 1.0;

	if( Ball != None )
	{
		Ball.Destroy();
		Ball = None;
	}
}

defaultproperties
{
     BlastDuration=0.350000
     Spread=20.000000
     Volume=250.000000
     NumTemplates=1
     Templates(0)=(MaxInitialVelocity=30.000000,MinInitialVelocity=-30.000000,MaxDrawScale=0.200000,MinDrawScale=0.100000,MaxScaleGlow=0.500000,MinScaleGlow=0.500000,GrowPhase=1,MaxGrowRate=0.300000,MinGrowRate=0.200000,FadePhase=1,MaxFadeRate=-0.750000,MinFadeRate=-0.750000)
     Particles(0)=Texture'Angreal.AirBurst.APulseA'
     bOn=True
     MinVolume=100.000000
     bInterpolate=True
     bDisableTick=False
     bStatic=False
     RemoteRole=ROLE_SimulatedProxy
     bMustFace=False
     VisibilityRadius=2500.000000
     VisibilityHeight=2500.000000
}
