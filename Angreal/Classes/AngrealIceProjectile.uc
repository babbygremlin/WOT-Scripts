//------------------------------------------------------------------------------
// AngrealIceProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 5 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealIceProjectile expands SeekingProjectile;

#exec OBJ LOAD FILE=Textures\FreezeT.utx PACKAGE=Angreal.Ice

#exec AUDIO IMPORT FILE=Sounds\Ice\LaunchIC.wav		GROUP=Ice
#exec AUDIO IMPORT FILE=Sounds\Ice\LoopIC.wav		GROUP=Ice
#exec AUDIO IMPORT FILE=Sounds\Ice\HitPawnIC.wav	GROUP=Ice

// NOTE[aleiby]: This code looks suspiciously like LeechAttacher.uc and AngrealDecayProjectile.uc
// Is there a way we can put this in a single place?

// How long does this effect last?
// This number gets used for all the leeches installed.
// That way they will all get unattached at the same time.
var() float Duration;

// The reflector to install. 
var() class<Leech> LeechClasses[10];

// The type of Installer to use.
var() class<AttachLeechEffect> AttachLeechEffectClass;

// Our persistant Attacher.
var AttachLeechEffect Attacher;

// Our particle systems.
var() class<ParticleSprayer> SprayerTypes[3];
var ParticleSprayer Sprayers[3];

// "S" parameters.
var() float SRate;	// Radians per second. (2*PI radians completes a single "S" pattern).
var() float SRadius;
var float SAngle;

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local int i;
	local vector Loc, X, Y, Z;
	local rotator Rot;

	Super.Tick( DeltaTime );

	Rot = rotator(Velocity);
	
	// Calculate locations of sprayers (to form an "S" like pattern).
	SAngle += SRate * DeltaTime;
	
	GetAxes( Rot, X, Y, Z );
	Loc = Location + (Y * SRadius * Sin(SAngle));
	
	// Update Locations and Rotations, creating sprayers as needed.
	for( i = 0; i < ArrayCount(Sprayers); i++ )
	{
		if( Sprayers[i] != None )
		{
			Sprayers[i].SetLocation( Loc );
			Sprayers[i].SetRotation( Rot );
		}
		else if( Velocity != vect(0,0,0) /* && Sprayers[i] == None */ && !bDeleteMe )
		{
			Sprayers[i] = Spawn( SprayerTypes[i],,, Loc, Rot );
		}
	}
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	local int i;

	for( i = 0; i < ArrayCount(Sprayers); i++ )
	{
		if( Sprayers[i] != None )
		{
			Sprayers[i].bOn = False;
			Sprayers[i].LifeSpan = 5.0;
			Sprayers[i] = None;
		}
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
function ProcessDamage( Actor Other, int GivenDamage, Pawn GivenInstigator, vector HitLocation, vector GivenMomentum )
{
	local int i;
/*	
	// Create a leech attacher if we need one.
	if( Attacher == None )
	{
		Attacher = Spawn( AttachLeechEffectClass );
		Attacher.InitializeWithProjectile( Self );
	}
*/
	// don't freeze dead/dying pawns since this can result in floating carcasses etc.
	if( Pawn(Other).Health > 0 )
	{
		Attacher = AttachLeechEffect( class'Invokable'.static.GetInstance( Self, AttachLeechEffectClass ) );
		Attacher.InitializeWithProjectile( Self );
	
		// Set its victim to be the person we just hit.
		Attacher.SetVictim( Pawn(Other) );
		
		for( i = 0; 
		     i < ArrayCount(LeechClasses) &&
			 LeechClasses[i] != None; 
			 i++ )
		{
			// Initialize it with the appropriate Reflector and lifespan
			Attacher.Initialize( LeechClasses[i], Duration );
		
			
			// Pass it off to our owner for processing.
			if( WOTPlayer(Other) != None )
			{
				WOTPlayer(Other).ProcessEffect( Attacher );
			}
			else if( WOTPawn(Other) != None )
			{
				WOTPawn(Other).ProcessEffect( Attacher );
			}
		}
	}
}

defaultproperties
{
     Duration=7.000000
     LeechClasses(0)=Class'Angreal.IceLeech'
     AttachLeechEffectClass=Class'Angreal.AttachLeechEffect'
     SprayerTypes(0)=Class'Angreal.SnowSprayer01'
     SprayerTypes(1)=Class'Angreal.SnowSprayer02'
     SprayerTypes(2)=Class'Angreal.SnowSprayer03'
     SRate=5.000000
     SRadius=20.000000
     speed=300.000000
     SpawnSound=Sound'Angreal.Ice.LaunchIC'
     ImpactSound=Sound'Angreal.Ice.HitPawnIC'
     LifeSpan=0.000000
     DrawType=DT_None
     SoundRadius=64
     SoundVolume=128
     AmbientSound=Sound'Angreal.Ice.LoopIC'
     CollisionRadius=6.000000
     CollisionHeight=12.000000
     LightType=LT_Steady
     LightBrightness=255
     LightSaturation=255
}
