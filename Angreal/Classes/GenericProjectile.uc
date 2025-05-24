//------------------------------------------------------------------------------
// GenericProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 8 $
//
// Description:	Handles all damage related work including splash damage for
//				projectiles that just go.  Subclasses should handle visual 
//				effects and exceptions to the rule.
//------------------------------------------------------------------------------
// How to use this class:
// 
// + Subclass and handle exceptions like overriding Explode() to draw 
//   visual effects and then call Super.Explode() to take care of damage.
// + Other exceptions would include changing to a water zone where you might
//   want to destroy the projectile and create a visual/audio effect.
//------------------------------------------------------------------------------
class GenericProjectile expands AngrealProjectile
	abstract;

////////////
// Sounds //
////////////
var() Sound HitPawnSound;
var() Sound HitWaterSound;

var() float SpawnSoundPitch;
var() float ImpactSoundPitch;
var() float HitPawnSoundPitch;
var() float HitWaterSoundPitch;

var() float SpawnSoundRadius;
var() float ImpactSoundRadius;
var() float HitPawnSoundRadius;
var() float HitWaterSoundRadius;

////////////
// Damage //
////////////
var() name DamageType;		// Type of damage caused by explosion.

var() float DamageRadius;	// Extents of splash damage.

var() bool bExplode;		// Do you want this projectile to explode when 
							// it hits something?
							// NOTE[aleiby]: Set this correctly on the client-side 
							// everywhere that it is modified (relect, etc).

var Actor HitActor;			// Who we just hit.

var Pawn IgnoredPawn;		// This pawn will be immune from all calls
							// to process touch.  It should be set to
							// the pawn the spawns one of these 
							// projectiles so it doesn't blow up in its 
							// face.  It should be changed when it is
							// reflected or forked.  It should be set
							// to None when it loses its destination
							// if it is a seeking projectile.

/////////////
// Support //
/////////////

// The type of launcher used to launch this projectile.
var() class<LaunchProjectileEffect> LauncherClass;

// Spawn location offset relative to the Source's Location, 
// BaseEyeHeight (only for Pawns) and Rotation (not ViewRotation).
var() vector LaunchOffset;

// Does this projectile use the destination? (like seeking projectiles, etc.)
var() bool bUsesDestination;

// Does this projectile need a destination in order to be launched?
var() bool bRequiresDestination;

// Does this projectile require leading to successfully hit someone?
var() bool bRequiresLeading;

// For projectiles that use destinations, this is the maximum angle 
// allowed when targetting normally.
var() float MaxTargetAngle;

// Are we allowed to hurt our owner?
var() bool bHurtsOwner;

// Should we destroy the projectile when we explode?
var() bool bDestroyOnExplode;

// The object spawned when this projectile enters water.
var() class<Actor> HitWaterClass;
var() vector HitWaterOffset;

var bool bVelocityReadOnly;		// Allows you to set the velocity to be read only.
								// Only works when velocity is set through SetVelocity.

var bool bAbortProcessTouch;

replication
{
	// Send to clients if relevant.
	reliable if( Role==ROLE_Authority && (IgnoredPawn==None || IgnoredPawn.bNetRelevant) )	// Fix ARL: Remove second check once Tim sends network fix.
		IgnoredPawn;

	reliable if( Role==ROLE_Authority )
		bExplode;
}

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if( Role == ROLE_Authority )
	{
		ServerInit();
	}
}

//------------------------------------------------------------------------------
function ServerInit()
{
	if( SpawnSound != None )
	{
		PlaySound( SpawnSound,,,, SpawnSoundRadius, SpawnSoundPitch );
	}

	SetVelocity( vector(Rotation) * Speed );
}

//------------------------------------------------------------------------------
simulated function SetVelocity( vector NewVelocity )
{
	if( !bVelocityReadOnly )
	{
		Velocity = NewVelocity;
	}
}

//------------------------------------------------------------------------------
simulated function SetIgnoredPawn( Pawn GivenPawn )
{
	IgnoredPawn = GivenPawn;
}

//------------------------------------------------------------------------------
simulated function SetDestination( Actor Dest )
{
	// Generic projectiles don't need destinations... they just go.
}

//------------------------------------------------------------------------------
// Override to handle special cases.
// Example: Explosive wards will fail if they can't reach the ground.
//------------------------------------------------------------------------------
function bool CreationSucceeded()
{
	return true;
}

//------------------------------------------------------------------------------
// Called when the projectile hits something other than a wall.
// Uses DamageEffects to damage WOTPlayers and WOTPawns, otherwise it
// just calls the Actor's TakeDamage function itself.
//
// + Projectile::Damage - How much damage is done to what this projectile hits.
// + GenericProjectile::DamageRadius - Extents for splash damage.
// + GenericProjectile::DamageType - Type of damage caused by projectile.
//------------------------------------------------------------------------------
simulated function ProcessTouch( Actor Other, vector HitLocation )
{
	// Don't do anything if we touch our ignored pawn.
	if( Other == IgnoredPawn )
	{
		return;
	}

	// If we hit a WOTPlayer or WOTPawn, let it know.
	if( WOTPlayer(Other) != None )
	{
		WOTPlayer(Other).NotifyHitByAngrealProjectile( Self );
	}
	else if( WOTPawn(Other) != None )
	{
		WOTPawn(Other).NotifyHitByAngrealProjectile( Self );
	}

	if( bAbortProcessTouch )
	{
		bAbortProcessTouch = false;
		return;
	}

	// NotifyHitByAngrealProjectile, etc. may set this to false.
	if( bExplode )
	{
		// Store so we don't damage this player again with spash damage.
		HitActor = Other;

		ProcessDamage( Other, Damage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity) );
	
		Explode( HitLocation, vect(0,0,1) );

		ServerProcessTouch( Other, HitLocation );
	}
}
function ServerProcessTouch( Actor Other, vector HitLocation )
{
	if( Pawn(Other) != None && HitPawnSound != None )
	{
		PlaySound( HitPawnSound,,,, HitPawnSoundRadius, HitPawnSoundPitch );
	}
}

//------------------------------------------------------------------------------
simulated function HitWall( vector HitNormal, Actor Wall )
{
	// Store so we don't damage this player again with spash damage.
	HitActor = Wall;

	Super.HitWall( HitNormal, Wall );
}

//------------------------------------------------------------------------------
simulated function ProcessDamage( Actor Other, int GivenDamage, Pawn GivenInstigator, vector HitLocation, vector GivenMomentum )
{
	local DamageEffect DE;
	local name ProjDamageType;

	// Get appropriate damage type.
	if( SourceAngreal != None )
	{
		ProjDamageType = class'AngrealInventory'.static.GetDamageType( SourceAngreal );
	}
	else
	{
		ProjDamageType = DamageType;
	}
	
	// Damage Other using DamageEffects where appropriate.
	if( WOTPawn(Other) != None )
	{
		//DE = Spawn( class'DamageEffect' );
		DE = DamageEffect( class'Invokable'.static.GetInstance( Self, class'DamageEffect' ) );
		DE.InitializeWithProjectile( Self );
		DE.Initialize( GivenDamage, GivenInstigator, HitLocation, GivenMomentum, ProjDamageType, Self );
		DE.SetVictim( Pawn(Other) );
		WOTPawn(Other).ProcessEffect( DE );
	}
	else if( WOTPlayer(Other) != None )
	{
		//DE = Spawn( class'DamageEffect' );
		DE = DamageEffect( class'Invokable'.static.GetInstance( Self, class'DamageEffect' ) );
		DE.InitializeWithProjectile( Self );
		DE.Initialize( GivenDamage, GivenInstigator, HitLocation, GivenMomentum, ProjDamageType, Self );
		DE.SetVictim( Pawn(Other) );
		WOTPlayer(Other).ProcessEffect( DE );
	}
	else
	{
		Other.TakeDamage( GivenDamage, GivenInstigator, HitLocation, GivenMomentum, ProjDamageType );	
	}
}

//------------------------------------------------------------------------------
// Subclasses should override and take care of exceptions like visual effects.
// Make sure to call Super.Explode();
//------------------------------------------------------------------------------
simulated function Explode( vector HitLocation, vector HitNormal )
{
	ServerExplode( HitLocation, HitNormal );

	if( DamageRadius > 0 )
	{
		ProcessSplashDamage();
	}

	if( bDestroyOnExplode )
	{
		Super.Explode( HitLocation, HitNormal );
	}
}
function ServerExplode( vector HitLocation, vector HitNormal )
{
	if( ImpactSound != None )
	{
		PlaySound( ImpactSound,,,, ImpactSoundRadius, ImpactSoundPitch );

		// We are already calling MakeNoise if we hit a wall.
		// If we hit a pawn, redirect the noise to that pawn.
		if( Pawn(HitActor) != None )
		{
			HitActor.MakeNoise(1.0);
		}
	}
}	

//------------------------------------------------------------------------------
simulated function ProcessSplashDamage()
{
	local Actor		A;				// iterator
	local int		CurDamage;		// damage to A
	local vector	SplashMomentum;	// momentum due to damage.
	
	foreach RadiusActors( class 'Actor', A, DamageRadius )
	{
        if
		(	(A != HitActor)																// Don't hurt our primary Actor a second time.
		&&	(	(A.IsA('BlockAll') && Mover(A) != None && Mover(A).bDamageTriggered)	// Trigger movers.
			||	(A.bProjTarget)															// Hurt projectile targets.
			||	(A.bBlockActors && A.bBlockPlayers)										// Hurt blocking actors.
			)
		)
        {
            CurDamage = Damage - ( Damage * VSize( A.Location - Location ) / DamageRadius );
            if( CurDamage > 0 )
            {
            	SplashMomentum = ( MomentumTransfer * float(CurDamage) * ( Normal( A.Location - Location ) ) );	// NOTE[aleiby]: Does this really work?!?
				ProcessDamage( A, CurDamage, Instigator, A.Location, SplashMomentum );
			}
		}
	}
}

//------------------------------------------------------------------------------
// Notification that we just entered the water.
// Override this in your subclass to handle differently.
//------------------------------------------------------------------------------
simulated function HitWater()
{
	if( HitWaterClass != None )
	{
		Spawn( HitWaterClass,,, Location + HitWaterOffset, rotator(vect(0,0,1)) );
	}

	ServerHitWater();
}
function ServerHitWater()
{
	if( HitWaterSound != None )
	{
		PlaySound( HitWaterSound,,,, HitWaterSoundRadius, HitWaterSoundPitch );
	}
}

//------------------------------------------------------------------------------
simulated function ZoneChange( ZoneInfo NewZone )
{
	if( NewZone.bWaterZone )
	{
		HitWater();
	}
}

////////////////
// AI Support //
////////////////

//------------------------------------------------------------------------------
// Quick and dirty trig leading version.  (Assumes that the distance between
// the source and destination is much larget than the distance the destination
// can more before the projectile reaches it.)
//
// NOTE[aleiby]: Use calculus to get a more accurate leading trajectory.
//------------------------------------------------------------------------------
static function rotator CalculateTrajectory( Actor Source, Actor Destination )
{
	local vector Trajectory;
	local vector PredictedLoc;
	local float Diff;
	local float Time;

	// Filter bad data.
	if( Source == None || Destination == None )
	{
		return rot(0,0,0);
	}

	// Distance between the source and destination.
	Diff = VSize(Destination.Location - Source.Location);

	// Time it takes for the projectile to reach the destination.
	Time = Diff / default.Speed;

	// Location of the destination after time T (from above).
	PredictedLoc = Destination.Location + (Destination.Velocity * Time);
	
	// Vector from the source to the predicted destination's location after time T.
	Trajectory = PredictedLoc - Source.Location;

	return rotator(Trajectory);
}

//------------------------------------------------------------------------------
// Max distance this projectile can travel.
//------------------------------------------------------------------------------
static function float GetMaxRange()
{
	local float MaxRange;

	if(	default.Physics == PHYS_Projectile )
	{
		if( default.LifeSpan > 0.0 )
		{
			MaxRange = default.Speed * default.LifeSpan;
		}
		else
		{
			MaxRange = MaxInt;
		}
	}
	else if( default.Physics == PHYS_Falling )
	{
		// NOTE[aleiby]: This may not be correct (somebody doublecheck my math).
		// Assumes gravity of 950 units per second.
		MaxRange = default.Speed ** 4 / (2*950);
	}
	else
	{
		MaxRange = MaxInt;
	}

	return MaxRange;
}

//------------------------------------------------------------------------------
// Min safe distance this projectile may be fired.
//------------------------------------------------------------------------------
static function float GetMinRange()
{
	return default.DamageRadius;
}

defaultproperties
{
     SpawnSoundPitch=1.000000
     ImpactSoundPitch=1.000000
     HitPawnSoundPitch=1.000000
     HitWaterSoundPitch=1.000000
     SpawnSoundRadius=2500.000000
     ImpactSoundRadius=2500.000000
     HitPawnSoundRadius=2500.000000
     HitWaterSoundRadius=1000.000000
     DamageType=hurt
     bExplode=True
     LauncherClass=Class'Angreal.LaunchProjectileEffect'
     bRequiresLeading=True
     bDestroyOnExplode=True
     RemoteRole=ROLE_SimulatedProxy
}
