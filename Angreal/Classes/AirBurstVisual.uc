//------------------------------------------------------------------------------
// AirBurstVisual.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 5 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AirBurstVisual expands Effects;

#exec MESH    IMPORT     MESH=AirBurst ANIVFILE=MODELS\AirBurst_a.3D DATAFILE=MODELS\AirBurst_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AirBurst X=0 Y=0 Z=0 Pitch=0 Yaw=64 Roll=0

#exec MESH    SEQUENCE   MESH=AirBurst SEQ=All  STARTFRAME=0  NUMFRAMES=1

#exec TEXTURE IMPORT     NAME=AirBurst FILE=MODELS\AirBurst.PCX GROUP=Skins FLAGS=2 // AirBurst

#exec MESHMAP NEW        MESHMAP=AirBurst MESH=AirBurst
#exec MESHMAP SCALE      MESHMAP=AirBurst X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=AirBurst NUM=0 TEXTURE=AirBurst

var() float Duration;	// Used in place of LifeSpan for replication purposes.

var Actor FollowActor;
var vector FollowActorLocation;

var vector RelativeOffset;

replication 
{
	reliable if( Role==ROLE_Authority )
		FollowActor, RelativeOffset;

	unreliable if( Role==ROLE_Authority && FollowActor!=None && !FollowActor.bNetRelevant )
		FollowActorLocation;
}

//------------------------------------------------------------------------------
simulated function SetFollowActor( Actor Other )
{
	FollowActor = Other;
	
	if( FollowActor != None )
	{
		FollowActorLocation = FollowActor.Location;
	}

	RelativeOffset = Location - FollowActorLocation;
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( FollowActor != None )
	{
		FollowActorLocation = FollowActor.Location;
	}

	SetLocation( FollowActorLocation + RelativeOffset );

	// NOTE[aleiby]: Make ROLE_None so ScaleGlow doesn't get replicated.
	ScaleGlow = default.ScaleGlow * (Duration / default.Duration);

	Duration -= DeltaTime;
	if( Duration <= 0 )
	{
		Destroy();
	}
}

defaultproperties
{
     Duration=0.500000
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=10.000000
     DrawType=DT_Mesh
     Style=STY_Translucent
     bMustFace=False
     Texture=None
     Mesh=Mesh'Angreal.AirBurst'
}
