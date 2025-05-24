//=============================================================================
// WotWeaponProjectile.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================

class WotWeaponProjectile expands WotProjectile;

var(WOTSounds) Sound SoundHitPawn;
var(WOTSounds) Sound SoundHitWall;

var() bool			bStickInWalls;
var() bool			bPassThroughActors;
var() float			StayStuckTime;
var() float			FadeAwayTime;
var() float			FadeStartGlow;
var() float			FadeEndGlow;
var() bool			bMotionBlur;

var() int			YawSpinRate;
var() int			RollSpinRate;
var() int			PitchSpinRate;

var() float			ClearOtherDelaySecs;			// fixes hitting actor on way in then again on way out of collision cylinder
var private float	ClearOtherTime;

var private Actor PreviousOther;
var private bool bHitWall;

//=============================================================================

simulated function RandomizeRotationParams()
{
	local rotator Rot;

	Rot = Rotation;

	// randomize initial rotation if will be spinning on that axis
	if( YawSpinRate != 0 )
	{
		Rot.Yaw = FRand()*65536;
	}	
	if( RollSpinRate != 0 )
	{
		Rot.Roll = FRand()*65536;
	}	
	if( PitchSpinRate != 0 )
	{
		Rot.Pitch = FRand()*65536;
	}	

	SetRotation( Rot );
}

//=============================================================================

function MPPlaySound( Sound Sound, ESoundSlot Slot )
{
	PlaySound( Sound, Slot );
}

//=============================================================================

simulated function BeginPlay()
{
    Super.BeginPlay();

    MPPlaySound( SpawnSound, SLOT_Interact );
}

//=============================================================================

simulated function Destroyed()
{
	Super.Destroyed();

	if( Owner != None )
	{
		class'Util'.static.TriggerActor( Self, Owner, None, DestroyedEvent );
	}
}

//=============================================================================
// Base function for all WotWeaponProjectiles.  By default, the projectile 
// is destroyed.
//
// This common function is needed so that a given angreal (or whatever) can 
// destroy another angreal's projectile.

simulated function Explode( vector HitLocation, Vector HitNormal )
{
	GotoState( 'Explosion' );
}

//=============================================================================

auto simulated state Flying
{
	simulated function Tick( float DeltaTime )
	{
		local rotator Rot;

		Global.Tick( DeltaTime );
	
		Rot = Rotation;

		if( YawSpinRate != 0)
		{
			Rot.Yaw		+= YawSpinRate * DeltaTime;
			Rot.Yaw		=  Rot.Yaw & 0xFFFF;	// Keep in range.
		}

		if( RollSpinRate != 0)
		{
			Rot.Roll	+= RollSpinRate * DeltaTime;
			Rot.Roll	=  Rot.Roll & 0xFFFF;	// Keep in range.
		}

		if( PitchSpinRate != 0)
		{
			Rot.Pitch	+= PitchSpinRate * DeltaTime;
			Rot.Pitch	=  Rot.Pitch & 0xFFFF;	// Keep in range.
		}

		SetRotation( Rot );

		if( (PreviousOther != None) && (Level.TimeSeconds >= ClearOtherTime) )
		{
			PreviousOther = None;
		}
	}

    simulated function HitWall( vector HitNormal, actor Wall )
    {
		if( bHitWall )
		{
			return;
		}
		bHitWall = true;

		if( Role == ROLE_Authority )
		{
			if( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
			{
				Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), '');
			}
		}

		AmbientSound=None;
		
        MPPlaySound( SoundHitWall, SLOT_Misc );

		if( bStickInWalls )
		{
			// immediately disable motion blur on projectiles stuck in 
			// wall or projectile stuck in wall will be blurred
			RenderIteratorClass = None;

			GotoState( 'StuckInSomething' );
		}
		else
		{
	        Explode( Location, HitNormal );
		}
    }

	simulated function ProcessTouch( Actor Other, Vector HitLocation )
	{
		local float Dist;

		if( Projectile(Other) == None ) 
		{
			if( Role == ROLE_Authority )
			{
				if( Other != PreviousOther )
				{
					Other.TakeDamage( Damage, Instigator, HitLocation, vect(0,0,0), 'shot' );

					// can't hit same actor 2x within 
					PreviousOther = Other;
					ClearOtherTime = Level.TimeSeconds + ClearOtherDelaySecs;
				}
			}

			if( Pawn(Other) != None )
			{
				MPPlaySound( SoundHitPawn, SLOT_Misc );
			}
			else
			{
	            MPPlaySound( SoundHitWall, SLOT_Misc );
			}

			if( !bPassThroughActors )
			{
				// projectile should "explode" = disappear upon hitting another actor
	            Explode( HitLocation, vect(0, 0, 1) );
			}
        }
    }

	simulated function BeginState()
	{
		// velocity comes out of current rotation (set when aiming weapon)
		Velocity = vector(Rotation) * Speed;
    
	    // can play with rotation now (e.g. spin arrow, shield while flying)
		RandomizeRotationParams();
	
		if( bMotionBlur )
		{
			RenderIteratorClass = Class'MotionBlurRI';
		}
	}
	
	simulated function EndState()
	{
		if( bMotionBlur )
		{
			RenderIteratorClass = None;
		}
	}
}

simulated state StuckInSomething
{
	simulated function BeginState()
	{
		if( FadeAwayTime ~= 0.0 )
		{
			// destroy immediately
			Destroy();
		}
		else
		{
			// fade out then destroy -- replication problems on client side
			class'Util'.static.Fade( Self, FadeAwayTime, false, default.ScaleGlow, FadeEndGlow, StayStuckTime );
		}

		SetPhysics( PHYS_None );
	}
}

//=============================================================================
// Base state for all WotWeaponProjectiles.
// See comment above in function Explode
// override in derived class

simulated state Explosion
{
	simulated function BeginState()
	{
	 	Super.BeginState();

		Destroy();
	}
}

defaultproperties
{
     bStickInWalls=True
     StayStuckTime=5.000000
     FadeStartGlow=1.000000
     ClearOtherDelaySecs=0.050000
     speed=5.000000
     MaxSpeed=5.000000
     Damage=10.000000
     RemoteRole=ROLE_SimulatedProxy
     bMustFace=False
     bAlwaysRelevant=True
     SoundVolume=255
     Mass=1.000000
}
