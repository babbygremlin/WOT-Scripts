//------------------------------------------------------------------------------
// TriggeredAngrealSpawner.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
// + Place in level.
// + Aim at target .. or ...
// + Link targets with Tags (for targets) / Event (for us). ... or ...
// + Fill in Targets array manually.
// + Set appropriate initial state.
// (Leading will be automatically performed for moving targets.)
//------------------------------------------------------------------------------
class TriggeredAngrealSpawner expands Effects;

var() class<GenericProjectile> ProjType;	// Type of projectile to fire.
var() Actor Targets[32];					// List of targets.
var() bool bAlwaysInitialize;

// (Organized by difficulty level).
var() float MaxSpeedOverride[3];
var() float SpeedOverride[3];
var() float CollisionHeightOverride[3];
var() float CollisionRadiusOverride[3];
var() float DamageOverride[3];
var() float DamageRadiusOverride[3];
var() int   LightBrightnessOverride[3];
var() int   LightHueOverride[3];
var() int   LightSaturationOverride[3];
var() int   LightRadiusOverride[3];

var int NumTargets;
var int LastShot;
var bool bInitialized;

////////////
// States //
////////////

//------------------------------------------------------------------------------
// Uses our Rotation.
//------------------------------------------------------------------------------
simulated state() Directed
{
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		local GenericProjectile P;

		// Error check
		if( ProjType == None )
		{
			class'Debug'.static.DebugWarn( Self, "ProjType not set.", 'DebugCategory_Angreal' );
			return;
		}

		P = Spawn( ProjType,,, Location, Rotation );
		
		// Overrides.
		if( MaxSpeedOverride[ Level.Game.Difficulty ] != 0 )
			P.MaxSpeed = MaxSpeedOverride[ Level.Game.Difficulty ];

		if( SpeedOverride[ Level.Game.Difficulty ] != 0 )
		{
			P.Speed = SpeedOverride[ Level.Game.Difficulty ];
			P.Velocity = Normal(P.Velocity) * P.Speed;
		}

		if( CollisionRadiusOverride[ Level.Game.Difficulty ] != 0 || CollisionHeightOverride[ Level.Game.Difficulty ] != 0 )
			P.SetCollisionSize( CollisionRadiusOverride[ Level.Game.Difficulty ], CollisionHeightOverride[ Level.Game.Difficulty ] );

		if( DamageOverride[ Level.Game.Difficulty ] != 0 )
			P.Damage = DamageOverride[ Level.Game.Difficulty ];

		if( DamageRadiusOverride[ Level.Game.Difficulty ] != 0 )
			P.DamageRadius = DamageOverride[ Level.Game.Difficulty ];

		if( LightBrightnessOverride[ Level.Game.Difficulty ] > -1 )
			P.LightBrightness = LightBrightnessOverride[ Level.Game.Difficulty ];

		if( LightHueOverride[ Level.Game.Difficulty ] > -1 )
			P.LightHue = LightHueOverride[ Level.Game.Difficulty ];

		if( LightSaturationOverride[ Level.Game.Difficulty ] > -1 )
			P.LightSaturation = LightSaturationOverride[ Level.Game.Difficulty ];

		if( LightRadiusOverride[ Level.Game.Difficulty ] > -1 )
			P.LightRadius = LightRadiusOverride[ Level.Game.Difficulty ];
	}
}

//------------------------------------------------------------------------------
// Iterate linearly across the targets.
//------------------------------------------------------------------------------
simulated state() RoundRobin
{
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		if( !bInitialized )
		{
			Initialize();
		}

		FireAt( GetNext() );
	}
}

//------------------------------------------------------------------------------
// Randomly pick a target.
//------------------------------------------------------------------------------
simulated state() Random
{
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		if( !bInitialized )
		{
			Initialize();
		}

		FireAt( GetRandom() );
	}
}

//------------------------------------------------------------------------------
// Shoot at everybody at once.
//------------------------------------------------------------------------------
simulated state() Simultaneous
{
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		local int i;

		if( !bInitialized )
		{
			Initialize();
		}
		
		for( i = 0; i < NumTargets; i++ )
		{
			FireAt( Targets[i] );
		}
	}
}

//------------------------------------------------------------------------------
// Shoot at the instigator.
//------------------------------------------------------------------------------
simulated state() Instigated
{
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		FireAt( EventInstigator );
	}
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
simulated function Initialize()
{
	local Actor A;
	local int i;

	// Count existing targets.
	for( NumTargets = 0; NumTargets < ArrayCount(Targets); NumTargets++ )
	{
		if( Targets[NumTargets] == None )
		{
			break;
		}
	}

	// Add in more as desired.
	if( Event != '' )
	{
		foreach AllActors( class'Actor', A, Event )
		{
			Targets[NumTargets++] = A;
		}
	}

	bInitialized = !bAlwaysInitialize;
}

//------------------------------------------------------------------------------
simulated function Actor GetNext()
{
	local Actor A;
	local int StartIndex;

	// Get the next target.
	A = Targets[LastShot];

	// If this target is invalid, try getting the next valid target (if any).
	if( A == None )
	{
		StartIndex = LastShot;
		for
		(	LastShot = (LastShot + 1) % NumTargets;
			StartIndex != LastShot && Targets[LastShot] == None;
			LastShot = (LastShot + 1) % NumTargets
		);

		A = Targets[LastShot];
	}

	// Queue up the next valid target (if any).
	StartIndex = LastShot;
	for
	(	LastShot = (LastShot + 1) % NumTargets;
		StartIndex != LastShot && Targets[LastShot] == None;
		LastShot = (LastShot + 1) % NumTargets
	);

	return A;
}

//------------------------------------------------------------------------------
simulated function Actor GetRandom()
{
	local Actor A;
	local int i;

	// Compact list in case some actors became None.
	NumTargets = 0;
	for( i = 0; i < ArrayCount(Targets); i++ )
	{
		if( Targets[i] != None )
		{
			Targets[NumTargets++] = Targets[i];
		}
	}

	LastShot = NumTargets * FRand();
		
	A = Targets[LastShot];

	return A;
}

//------------------------------------------------------------------------------
simulated function FireAt( Actor A )
{
	local GenericProjectile P;

	// Error check
	if( ProjType == None )
	{
		class'Debug'.static.DebugWarn( Self, "ProjType not set.", 'DebugCategory_Angreal' );
		return;
	}

	if( A == None )
	{
		class'Debug'.static.DebugWarn( Self, "Target is NULL.", 'DebugCategory_Angreal' );
		return;
	}
	
	P = Spawn( ProjType,,, Location, ProjType.static.CalculateTrajectory( Self, A ) );
	P.SetDestination( A );

	// Overrides.
	if( MaxSpeedOverride[ Level.Game.Difficulty ] != 0 )
		P.MaxSpeed = MaxSpeedOverride[ Level.Game.Difficulty ];

	if( SpeedOverride[ Level.Game.Difficulty ] != 0 )
	{
		P.Speed = SpeedOverride[ Level.Game.Difficulty ];
		P.Velocity = Normal(P.Velocity) * P.Speed;
	}

	if( CollisionRadiusOverride[ Level.Game.Difficulty ] != 0 || CollisionHeightOverride[ Level.Game.Difficulty ] != 0 )
		P.SetCollisionSize( CollisionRadiusOverride[ Level.Game.Difficulty ], CollisionHeightOverride[ Level.Game.Difficulty ] );

	if( DamageOverride[ Level.Game.Difficulty ] != 0 )
		P.Damage = DamageOverride[ Level.Game.Difficulty ];

	if( DamageRadiusOverride[ Level.Game.Difficulty ] != 0 )
		P.DamageRadius = DamageOverride[ Level.Game.Difficulty ];

	if( LightBrightnessOverride[ Level.Game.Difficulty ] > -1 )
		P.LightBrightness = LightBrightnessOverride[ Level.Game.Difficulty ];

	if( LightHueOverride[ Level.Game.Difficulty ] > -1 )
		P.LightHue = LightHueOverride[ Level.Game.Difficulty ];

	if( LightSaturationOverride[ Level.Game.Difficulty ] > -1 )
		P.LightSaturation = LightSaturationOverride[ Level.Game.Difficulty ];

	if( LightRadiusOverride[ Level.Game.Difficulty ] > -1 )
		P.LightRadius = LightRadiusOverride[ Level.Game.Difficulty ];
}

defaultproperties
{
    LightBrightnessOverride(0)=-1
    LightBrightnessOverride(1)=-1
    LightBrightnessOverride(2)=-1
    LightHueOverride(0)=-1
    LightHueOverride(1)=-1
    LightHueOverride(2)=-1
    LightSaturationOverride(0)=-1
    LightSaturationOverride(1)=-1
    LightSaturationOverride(2)=-1
    LightRadiusOverride(0)=-1
    LightRadiusOverride(1)=-1
    LightRadiusOverride(2)=-1
    bHidden=True
    RemoteRole=0
    InitialState=Directed
    bDirectional=True
    DrawType=1
}
