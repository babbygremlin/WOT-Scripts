//------------------------------------------------------------------------------
// AngrealTracerProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 6 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealTracerProjectile expands SeekingProjectile;

#exec MESH IMPORT MESH=Tracer ANIVFILE=MODELS\Tracer_a.3d DATAFILE=MODELS\Tracer_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Tracer X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Tracer SEQ=All    STARTFRAME=0 NUMFRAMES=2
#exec MESH SEQUENCE MESH=Tracer SEQ=TRACER STARTFRAME=0 NUMFRAMES=2

#exec TEXTURE IMPORT NAME=JTracer1 FILE=MODELS\Tracer.PCX GROUP=Skins FLAGS=2 // T

#exec MESHMAP NEW   MESHMAP=Tracer MESH=Tracer
#exec MESHMAP SCALE MESHMAP=Tracer X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Tracer NUM=1 TEXTURE=JTracer1


#exec AUDIO IMPORT FILE=Sounds\Tracer\ActivateTR.wav	GROUP=Tracer
#exec AUDIO IMPORT FILE=Sounds\Tracer\LoopTR.wav		GROUP=Tracer
#exec AUDIO IMPORT FILE=Sounds\Tracer\ImpactTR.wav		GROUP=Tracer

var() class<ParticleSprayer> SprayerClass;
var ParticleSprayer Sprayer;

// The seal that we are currently tracking after.
var Seal TrackingSeal;

var() rotator SpinRate;
var rotator Spin;

//------------------------------------------------------------------------------
function PreBeginPlay()
{
	Super.PreBeginPlay();
	SetTimer( 1.0, True );
	LoopAnim( 'TRACER', 0.1 );
}

//------------------------------------------------------------------------------
function SetDestination( Actor NewDest )
{
	if( Pawn(NewDest) != None )
	{
		TrackingSeal = Seal(Pawn(NewDest).FindInventoryType( class'Seal' ));
	}
	else if( Seal(NewDest) != None )
	{
		TrackingSeal = Seal(NewDest);
	}

	Super.SetDestination( NewDest );
}

//------------------------------------------------------------------------------
function Timer()
{
	local Seal S;

	// NOTE[aleiby]: We wouldn't have to do all this extra work if the
	// seal's location was updated while a player is carrying it using
	// SetBase();

	// If we are following a player, check to make sure he/she didn't 
	// drop the seal on us.
	if( Pawn(Destination) != None )
	{
		S = Seal(Pawn(Destination).FindInventoryType( class'Seal' ));
		if( S != None )
		{
			TrackingSeal = S;
		}
		else
		{
			// He/she must have dropped it.  Start following it.
			SetDestination( TrackingSeal );
		}
	}
	// Otherwise, make sure no one picked it up.
	else if( Seal(Destination) != None )
	{
		if( Seal(Destination).GetStateName() != 'Pickup' )
		{
			SetDestination( Destination.Owner );
		}
	}
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );
	
	if( Sprayer == None && !bDeleteMe )
	{
		Sprayer = Spawn( SprayerClass,,, Location, rotator(vect(0,0,1)) );
		Sprayer.VisibilityRadius = 0.0;
		Sprayer.VisibilityHeight = 0.0;
		Sprayer.MinVolume = Sprayer.Volume;
		Sprayer.bMustFace = False;
		Sprayer.FollowActor = Self;
		Sprayer.Disable('Tick');
	}
	
	Spin += SpinRate * DeltaTime;
	SetRotation( Rotation + Spin );
}

//------------------------------------------------------------------------------
simulated function NotifySeekerBounced( NavigationPoint OnNode )
{
	Velocity = Normal(DestLoc-Location) * VSize(Velocity);
	bDisableCalcNextDirection = true;
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Sprayer != None )
	{
		Sprayer.LifeSpan = 15.0;
		Sprayer.Volume = 0.0;
	}

	Super.Destroyed();
}

defaultproperties
{
     SprayerClass=Class'Angreal.TracerSprayer'
     spinRate=(Roll=65000)
     Acceleration=150.000000
     bTakeShortcuts=False
     bDesperateSeeker=True
     ReachTolerance=20.000000
     bNotifiesDestination=False
     ImpactSoundRadius=700.000000
     speed=1.000000
     MaxSpeed=500.000000
     SpawnSound=Sound'Angreal.Tracer.ActivateTR'
     ImpactSound=Sound'Angreal.Tracer.ImpactTR'
     LifeSpan=0.000000
     Texture=None
     Mesh=Mesh'Angreal.Tracer'
     SoundRadius=64
     SoundVolume=128
     AmbientSound=Sound'Angreal.Tracer.LoopTR'
     CollisionRadius=16.000000
     CollisionHeight=16.000000
}
