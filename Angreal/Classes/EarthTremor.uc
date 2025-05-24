//------------------------------------------------------------------------------
// EarthTremor.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	This class simply orchestrates the placement of EarthTremorRocks.
//              You will never actually see this class, only its results.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Spawn.
// + SetSourceAngreal
// + Call Go();
//------------------------------------------------------------------------------
class EarthTremor expands AngrealProjectile;

// Distance between the center and the first ripple.
var() float RippleDistance;

// How high do we spawn these so that we can go up steps, etc.
var() float SpawnHeight;

var() float FirstRingDelay;
var() float SecondRingDelay;
var() float ThirdRingDelay;
var() float FourthRingDelay;

var float StartTime;

var ETSoundProxy ETS;

//------------------------------------------------------------------------------
// Engine notifications.
//------------------------------------------------------------------------------
function Touch( Actor Other );
function HitWall( vector HitLocation, Actor Wall );

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	local EarthTremorRock IterRock;
	
	foreach RadiusActors( class'EarthTremorRock', IterRock, RippleDistance * 4.0 )
	{
		IterRock.Destroy();
	}

	Super.PreBeginPlay();
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
simulated function SpawnRing( float Scale, float StartAngle, float AngleInterval, float RingRadius )
{
	local vector Loc, X, Y, Z, XAxis, YAxis, ZAxis;
	local rotator Rot;
	local float Angle;
	local EarthTremorRock Rock;
	local vector Ignored;
	
	GetAxes( Rotation, X, Y, Z );
	
	for( Angle = StartAngle; Angle < 360.0; Angle += AngleInterval )
	{
		XAxis = class'Util'.static.DSin( Angle ) * Y + class'Util'.static.DCos( Angle ) * X;

		Loc = Location + XAxis*RingRadius;
		
		// Make sure we aren't going to run into geometry.
		if( Trace( Ignored, Ignored, Loc, Location, false ) == None )
		{
			ZAxis = Z;
			YAxis = ZAxis cross XAxis;
			Rot = OrthoRotation( XAxis, YAxis, ZAxis );
			
			Rock = Spawn( class'EarthTremorRock',,, Loc, Rot );
			if( Rock != None )
			{
				Rock.SetSourceAngreal( SourceAngreal );
				Rock.Instigator = Instigator;
				Rock.Lifespan = Default.Lifespan;
				Rock.DrawScale *= Scale;
				if( ETS != None )
				{
					ETS.AddRock( Rock );
				}
				Rock.ETS = ETS;
				Rock.Go();
			}
		}
	}
}

//////////////////
// State Timers //
//////////////////

simulated function Go()
{
	GotoState( 'FirstRing' );
}

//------------------------------------------------------------------------------
simulated state FirstRing
{
	simulated function BeginState()
	{
		local EarthTremorRock Rock;
		local vector X, Y, Z;

		StartTime = Level.TimeSeconds;
		
		GetAxes( Rotation, X, Y, Z );
		Rock = Spawn( class'ETInner',,, Location, Rotation );
		if( Rock != None )
		{
			Rock.SetSourceAngreal( SourceAngreal );
			Rock.Lifespan = Default.Lifespan;
			ETS = Spawn( class'ETSoundProxy',,, Location );
			if( ETS != None )
			{
				ETS.SetLifeSpan( Default.Lifespan );
				ETS.AddRock( Rock );
			}
			Rock.ETS = ETS;
			Rock.Go();
		}
	}

	simulated function Tick( float DeltaTime )
	{
		Super.Tick( DeltaTime );

		if( (Level.TimeSeconds - StartTime) >= FirstRingDelay )
		{
			SpawnRing( 1.0, 0.0, 72.0, RippleDistance );
			GotoState( 'SecondRing' );
		}
	}
}

//------------------------------------------------------------------------------
simulated state SecondRing
{
	simulated function BeginState()
	{
		StartTime = Level.TimeSeconds;
	}

	simulated function Tick( float DeltaTime )
	{
		Super.Tick( DeltaTime );

		if( (Level.TimeSeconds - StartTime) >= SecondRingDelay )
		{
			SpawnRing( 0.85, 36.0, 72.0, RippleDistance * 2.0 );
			GotoState( 'ThirdRing' );
		}
	}
}

//------------------------------------------------------------------------------
simulated state ThirdRing
{
	simulated function BeginState()
	{
		StartTime = Level.TimeSeconds;
	}

	simulated function Tick( float DeltaTime )
	{
		Super.Tick( DeltaTime );

		if( (Level.TimeSeconds - StartTime) >= ThirdRingDelay )
		{
			SpawnRing( 0.70, 0.0, 36.0, RippleDistance * 3.0 );
			GotoState( 'FourthRing' );
		}
	}
}

//------------------------------------------------------------------------------
simulated state FourthRing
{
	simulated function BeginState()
	{
		StartTime = Level.TimeSeconds;
	}

	simulated function Tick( float DeltaTime )
	{
		Super.Tick( DeltaTime );

		if( (Level.TimeSeconds - StartTime) >= FourthRingDelay )
		{
			SpawnRing( 0.65, 18.0, 36.0, RippleDistance * 4.0 );
			Destroy();
		}
	}
}

defaultproperties
{
     RippleDistance=70.000000
     SpawnHeight=50.000000
     FirstRingDelay=0.200000
     SecondRingDelay=0.200000
     ThirdRingDelay=0.200000
     FourthRingDelay=0.200000
     bHidden=True
     RemoteRole=ROLE_None
     LifeSpan=15.000000
     DrawType=DT_None
}
