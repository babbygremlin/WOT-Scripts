//------------------------------------------------------------------------------
// AngrealExpWardProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 8 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealExpWardProjectile expands GenericProjectile;

#exec MESH IMPORT MESH=ExpWard ANIVFILE=MODELS\TwoTriangles_a.3d DATAFILE=MODELS\TwoTriangles_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=ExpWard X=0 Y=0 Z=0 Pitch=0 Yaw=0 Roll=0

#exec MESH SEQUENCE MESH=ExpWard SEQ=All     STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT FILE=MODELS\LandmineRune01.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LandmineRune02.pcx GROUP=Effects

#exec MESHMAP NEW   MESHMAP=ExpWard MESH=ExpWard
#exec MESHMAP SCALE MESHMAP=ExpWard X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=ExpWard NUM=0 TEXTURE=LandmineRune01

#exec AUDIO IMPORT FILE=Sounds\LandMine\PlaceLM.wav		GROUP=LandMine
#exec AUDIO IMPORT FILE=Sounds\LandMine\ExplodeLM.wav	GROUP=LandMine
#exec AUDIO IMPORT FILE=Sounds\LandMine\ActivateLM.wav	GROUP=LandMine

// How fast to fade in/out.  (ScaleGlow units per second.)
var() float ScaleGlowRate;

// How far down to trace.
var() float TraceDist;

// Could we correctly place ourself?
var bool bCorrectlyPlaced;

// How long to wait before becoming active.
var() float ActivationTime;

var() Sound ActivateSound;

// Normal vector.
var vector RelativeUp;

var() class<Decal> ScorchType;
var() float ScorchSize;

replication 
{
	reliable if( Role==ROLE_Authority )
		RelativeUp;
}

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	local vector HitLocation;
	local Actor HitActor;

	// NOTE[aleiby]: Adjust or don't place if doesn't fit.

	if( Role == ROLE_Authority )
	{
		// Trace forward to surface.
		HitActor = Trace( HitLocation, RelativeUp, Location + ((vect(1,0,0) * TraceDist) >> Rotation), Location, False );

		if( HitActor != None )
		{
			SetCollision( False );

			SetRotation( rotator( RelativeUp ) );
			bCorrectlyPlaced = SetLocation( HitLocation + RelativeUp * 0.5 );

			// Play sound, etc.
			if( bCorrectlyPlaced )
			{
				Super.PreBeginPlay();

				// Stick to movers.
				if( Mover(HitActor) != None )
				{
					SetBase( HitActor );
				}
			}
			else
			{
				Super(Actor).PreBeginPlay();	// Always make sure Actor's PreBeginPlay gets called.
			}
		}
		else
		{
			Super(Actor).PreBeginPlay();		// Always make sure Actor's PreBeginPlay gets called.
		}
	}
	else
	{
		Super.PreBeginPlay();					// Always make sure Actor's PreBeginPlay gets called.
	}

	LightBrightness = 0;

	// Explosive wards are permanent in SP.
	if( Level.NetMode == NM_Standalone )
	{
		LifeSpan = 0.0;
	}
}

//------------------------------------------------------------------------------
function bool CreationSucceeded()
{
	return bCorrectlyPlaced;
}

//------------------------------------------------------------------------------
singular simulated function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType )
{
	Explode( HitLocation, RelativeUp );
}

//------------------------------------------------------------------------------
singular simulated function Trigger( Actor Other, Pawn EventInstigator )
{
	Explode( Location, RelativeUp );
}

//------------------------------------------------------------------------------
simulated function Explode( vector HitLocation, vector HitNormal )
{
	local Decal BurnMark;
	
	if( ScorchType != None )
	{
		BurnMark = Spawn( ScorchType,,, Location );
		if( BurnMark != None )
		{
			BurnMark.DrawScale = ScorchSize;
			BurnMark.Align( RelativeUp );
		}
	}
	
	Spawn( class'FireballExplode3',,, Location );
	Spawn( class'BlastBits',,, Location, rotator(RelativeUp) );

	TriggerOthers();

	Super.Explode( HitLocation, HitNormal );
}

//------------------------------------------------------------------------------
function TriggerOthers()
{
	local Actor IterA;

	if( Event != '' )
		foreach AllActors( class'Actor', IterA )
			if( IterA.Tag == Event )
				IterA.Trigger( Self, None );
}

//------------------------------------------------------------------------------
simulated function HitWater()
{
	Super.HitWater();
	Destroy();
}

//------------------------------------------------------------------------------
simulated function Expired()
{
	Super.Expired();
	Explode( Location, RelativeUp );
}

//------------------------------------------------------------------------------
auto simulated state Waiting
{
	ignores Touch, ProcessTouch, TakeDamage, Explode;

begin:
	Sleep( ActivationTime );
	PlaySound( ActivateSound );
	SetCollision( True );
	GotoState('FadeOut');
}

//------------------------------------------------------------------------------
simulated state FadeIn
{
	simulated function Tick( float DeltaTime )
	{
		ScaleGlow += ScaleGlowRate * DeltaTime;
		
		if( ScaleGlow >= default.ScaleGlow )
		{
			ScaleGlow = default.ScaleGlow;
			GotoState( 'FadeOut' );
		}
		
		LightBrightness = byte((ScaleGlow / default.ScaleGlow) * float(default.LightBrightness));
		
		Global.Tick( DeltaTime );
	}
}

//------------------------------------------------------------------------------
simulated state FadeOut
{
	simulated function Tick( float DeltaTime )
	{
		ScaleGlow -= ScaleGlowRate * DeltaTime;
		
		if( ScaleGlow <= 0 )
		{
			ScaleGlow = 0.0;
			GotoState( 'FadeIn' );
		}
		
		LightBrightness = byte((ScaleGlow / default.ScaleGlow) * float(default.LightBrightness));

		Global.Tick( DeltaTime );
	}
}

//------------------------------------------------------------------------------
// Set initial state to this if you don't want them visible.
// This is useful for triggering them like dynamite.  :)
//------------------------------------------------------------------------------
simulated state() NoVisual
{
	simulated function BeginState()
	{
		bHidden = true;
		LightType = LT_None;
	}
}

////////////////
// AI Support //
////////////////

//------------------------------------------------------------------------------
static function rotator CalculateTrajectory( Actor Source, Actor Destination )
{
	local vector Direction;

	Direction = Normal(Destination.Location - Source.Location);	// Toward the Destination.
	Direction.z = -0.5;											// 45 degrees down.
	return rotator(Direction);
}

//------------------------------------------------------------------------------
static function float GetMaxRange()
{
	//return default.TraceDist;
	return 600.0;	// Needs time to activate.
}

defaultproperties
{
     ScaleGlowRate=1.000000
     TraceDist=200.000000
     ActivationTime=1.000000
     ActivateSound=Sound'Angreal.LandMine.ActivateLM'
     ScorchType=Class'ParticleSystems.ScorchMark'
     ScorchSize=2.500000
     DamageType=xEFxx
     DamageRadius=120.000000
     bRequiresLeading=False
     bHurtsOwner=True
     Damage=50.000000
     MomentumTransfer=6000
     SpawnSound=Sound'Angreal.LandMine.PlaceLM'
     ImpactSound=Sound'Angreal.LandMine.ExplodeLM'
     bCanTeleport=False
     Physics=PHYS_None
     LifeSpan=60.000000
     Style=STY_Translucent
     Skin=Texture'Angreal.Effects.LandmineRune01'
     Mesh=Mesh'Angreal.ExpWard'
     DrawScale=0.300000
     bUnlit=True
     CollisionRadius=24.000000
     CollisionHeight=8.000000
     bCollideActors=False
     bCollideWorld=False
     bProjTarget=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightRadius=1
}
