//=============================================================================
// SpewTrigger.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================
//
// Spews out the specified actors in random directions.  Good for explosions
// and for randomly littering an area with rubble or something...
//=============================================================================

class SpewTrigger expands KeyPoint;

struct ThingT
{
	var() class<actor> Actor;						// class of actors to spawn
	var() int Count;								// number of actors to spawn at once (turn collision off)
	var() float MinSpeed;							// min initial speed
	var() float MaxSpeed;							// max initial speed
	var() byte DetailLevel;							// detail level for spawned actors
	var() float DrawScale;							// override default DrawScale
};

var(SpewTrigger) ThingT Things[16];					// list of actors to spawn and properties to assign to them
var(SpewTrigger) float TimeBetweenSpewsSecs;		// time between passes through the Things list
var(SpewTrigger) float SpewVisibilityHeight;		// assigned to spawned actors' VisibilityHeight
var(SpewTrigger) float SpewVisibilityRadius;		// assigned to spawned actors' VisibilityRadius
var(SpewTrigger) bool bSilent;						// disable sounds in spawned actors
var(SpewTrigger) int  SpewCount;					// # times to go through Things list each time enabled
var(SpewTrigger) bool bTumble;						// if true spawned actors tumble (random rotation while falling)
var(SpewTrigger) bool bInheritVelocity;				// if true initial velocity is along direction SpewTrigger is aimed in
var(SpewTrigger) Rotator SpewRotationSpread;		// if bInheritVelocity is true, Roation is randomized by this about SpewTrigger's Rotation
var(SpewTrigger) bool bCollision;					// set to true if spawned actors should have collision on
var(SpewTrigger) bool bEnabled;						// true if active

var private float DefaultSpewCount;
var private float NextSpewTime;
var private actor SavedTrigger;



simulated function BeginPlay()
{
	Super.BeginPlay();
	
	DefaultSpewCount = SpewCount;
	
	EnableSpewing( bEnabled );
}



function EnableSpewing( bool bVal )
{
	bEnabled = bVal;

	// reset
    SpewCount = DefaultSpewCount;
}



function Tick( float DeltaTime )
{
  	if( bEnabled && Level.TimeSeconds >= NextSpewTime )
	{
		NextSpewTime = Level.TimeSeconds+TimeBetweenSpewsSecs;

		SpewThings();

		if( DefaultSpewCount != 0 && --SpewCount <= 0 )
		{
			EnableSpewing( false );
		}

		if( SavedTrigger != None )
		{
			SavedTrigger.EndEvent();
		}
	}	
}



state() TriggerTurnsOn
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		if( SavedTrigger!=None )
		{
			SavedTrigger.EndEvent();
		}

		SavedTrigger = Other;
		if( SavedTrigger!=None )
		{
			SavedTrigger.BeginEvent();
		}

		EnableSpewing( true );
	}
}



state() TriggerTurnsOff
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		if( SavedTrigger!=None )
		{
			SavedTrigger.EndEvent();
		}

		SavedTrigger = Other;
		if( SavedTrigger!=None )
		{
			SavedTrigger.BeginEvent();
		}

		EnableSpewing( false );
	}
}



state() TriggerToggle
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		if( SavedTrigger!=None )
		{
			SavedTrigger.EndEvent();
		}

		SavedTrigger = Other;
		if( SavedTrigger!=None )
		{
			SavedTrigger.BeginEvent();
		}

		EnableSpewing( !bEnabled );
	}
}



state() TriggerControl
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		if( SavedTrigger!=None )
		{
			SavedTrigger.EndEvent();
		}

		SavedTrigger = Other;
		if( SavedTrigger!=None )
		{
			SavedTrigger.BeginEvent();
		}

		EnableSpewing( !bEnabled );
	}

	function UnTrigger( actor Other, pawn EventInstigator )
	{
		if( SavedTrigger!=None )
		{
			SavedTrigger.EndEvent();
		}

		SavedTrigger = Other;
		if( SavedTrigger!=None )
		{
			SavedTrigger.BeginEvent();
		}

		EnableSpewing( !bEnabled );
	}
}



function SpewThing( int Index )
{
	local int i;
	local Actor A;
	local Rotator SpewRotation;
	
	for( i = 0; i < Things[Index].Count; i++ )
	{
		A = Spawn( Things[Index].Actor );
		
		if( A == None )
		{
			warn( "SpewTrigger::SpewThing: couldn't spawn class " $ Things[Index].Actor );
		}
		else
		{
			if( bTumble )
			{
				A.SetRotation( RotRand() );
				
				A.RotationRate.Yaw = 250000 * FRand() - 125000;
				A.RotationRate.Pitch = 250000 * FRand() - 125000;
				A.RotationRate.Roll = 250000 * FRand() - 125000;	
				A.DesiredRotation = RotRand();
				A.bRotateToDesired = false;
				A.bFixedRotationDir = true;
			}
	
			if( bInheritVelocity )
			{		
				// direction comes from SpewTrigger's current rotation
				SpewRotation = Rotation;
	
				SpewRotation.Yaw = class'util'.static.PerturbInt( SpewRotation.Yaw, SpewRotationSpread.Yaw ) & 0xFFFF;
				SpewRotation.Roll = class'util'.static.PerturbInt( SpewRotation.Roll, SpewRotationSpread.Roll ) & 0xFFFF;
				SpewRotation.Pitch = class'util'.static.PerturbInt( SpewRotation.Pitch, SpewRotationSpread.Pitch ) & 0xFFFF;
			}
			else
			{
				// direction is random
				SpewRotation = RotRand();
			}
	
			A.Velocity = normal( vector( SpewRotation ) ) * RandRange( Things[Index].MinSpeed, Things[Index].MaxSpeed );
	
			// This is so the spawned actors will bounce around when they're spawned.
			A.bBounce = true;
	
			if( !bCollision )
			{
				// If this is not done, the actors will spawn in, hit each other, and end
				// up in a stupid stack.  This allows them to bounce/fall naturally.
				A.SetCollision( false );
			}
			
			// Other variables that it's useful to have access to.
			if( Things[Index].DrawScale != 0.0 )
			{
				A.DrawScale = Things[Index].DrawScale;
			}
				
			A.DetailLevel = Things[Index].DetailLevel;
			A.VisibilityHeight = SpewVisibilityHeight;
			A.VisibilityRadius = SpewVisibilityRadius;
	
			// Sometimes the bouncing sounds are annoying.
			if( bSilent )
			{
				if( BounceableDecoration(A) != None )
				{
					BounceableDecoration(A).LandSound1 = None;
				}
			}
	
			// Other.
			A.SetPhysics( PHYS_Falling );
		}
	}
}

function SpewThings()
{
	local int i;

	for( i = 0; i < ArrayCount(Things); i++ )
	{
		if( Things[i].Actor != None )
		{
			SpewThing( i );
		}
	}
}

defaultproperties
{
     TimeBetweenSpewsSecs=1.000000
     SpewVisibilityHeight=1024.000000
     SpewVisibilityRadius=1024.000000
     SpewCount=1
     bTumble=True
     bStatic=False
     bCollideWhenPlacing=True
     RemoteRole=ROLE_SimulatedProxy
     bDirectional=True
     VisibilityRadius=1024.000000
     VisibilityHeight=1024.000000
}
