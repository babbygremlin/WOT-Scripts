//------------------------------------------------------------------------------
// ShieldParticleMesh.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class ShieldParticleMesh expands Effects;

#exec MESH IMPORT MESH=ShieldParticleMesh ANIVFILE=MODELS\ShieldParticleMesh_a.3d DATAFILE=MODELS\ShieldParticleMesh_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=ShieldParticleMesh X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=ShieldParticleMesh SEQ=All STARTFRAME=0 NUMFRAMES=32

#exec MESHMAP NEW   MESHMAP=ShieldParticleMesh MESH=ShieldParticleMesh
#exec MESHMAP SCALE MESHMAP=ShieldParticleMesh X=0.3 Y=0.3 Z=0.6

#exec OBJ LOAD FILE=Textures\ElementalT.utx PACKAGE=Angreal.Elemental

//var Actor FollowActor;

var() float RotationYawRate;
var float RotationYaw;

var() float FadeInTime;
var() float SustainTime;
var() float FadeOutTime;

var float StopFadeInTime;
var float StopSustainTime;
var float StopFadeOutTime;

var float FadeInRate;
var float FadeOutRate;

var float Scalar;

var() float SpriteAnimationRate;	// Frames per second.
var float SpriteAnimationTime;		// Seconds per frame.
var float SpriteAnimationTimer;		// Seconds till next frame.

var() Texture TextureSet[5];
var int TextureIndex;
/*
replication
{
	reliable if( Role==ROLE_Authority )
		FollowActor;
}
*/
//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	
	LoopAnim( 'All', 1.0 );
	
	LightBrightness = 0;
	ScaleGlow = 0.0;

	Scalar = 0.0;
	
	StopFadeInTime = Level.TimeSeconds + FadeInTime;
	StopSustainTime = StopFadeInTime + SustainTime;
	StopFadeOutTime = StopSustainTime + FadeOutTime;

	FadeInRate = 1.0 / FadeInTime;
	FadeOutRate = 1.0 / FadeOutTime;

	SpriteAnimationTime = 1.0 / SpriteAnimationRate;
	SpriteAnimationTimer = SpriteAnimationTime;

	Texture = TextureSet[TextureIndex];
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local rotator Rot;
	
	Super.Tick( DeltaTime );

	// Update glow.
	if( Level.TimeSeconds >= StopFadeOutTime )
	{
		Destroy();
	}
	else if( Level.TimeSeconds >= StopSustainTime )
	{
		Scalar -= FMax( 0.0, FadeOutRate * DeltaTime );
	}
	else if( Level.TimeSeconds >= StopFadeInTime )
	{
		Scalar = 1.0;
	}
	else
	{
		Scalar += FMin( 1.0, FadeInRate * DeltaTime );
	}
	
	LightBrightness = default.LightBrightness * Scalar;
	ScaleGlow = default.ScaleGlow * Scalar;
/*
	// Update position.
	if( Base != FollowActor )
	{
		SetBase( FollowActor );
	}
*/
	Rot = Rotation;
	RotationYaw += RotationYawRate * DeltaTime;
	Rot.Yaw = RotationYaw;
	SetRotation( Rot );

	// Update textures.
	SpriteAnimationTimer -= DeltaTime;
	while( SpriteAnimationTimer <= 0.0 )
	{
		SpriteAnimationTimer += SpriteAnimationTime;
		TextureIndex = (TextureIndex + 1) % ArrayCount(TextureSet);
		Texture = TextureSet[TextureIndex];
	}
}
/*
//------------------------------------------------------------------------------
simulated function SetFollowActor( Actor Other )
{
	FollowActor = Other;
	SetBase( FollowActor );
}
*/
defaultproperties
{
    RotationYawRate=-20000.00
    FadeInTime=0.20
    SustainTime=0.20
    FadeOutTime=0.60
    SpriteAnimationRate=15.00
    Physics=11
    RemoteRole=2
    DrawType=2
    Style=3
    bMustFace=False
    Texture=Texture'ParticleSystems.Appear.ABlueCorona'
    Mesh=Mesh'ShieldParticleMesh'
    DrawScale=0.25
    bParticles=True
    LightType=1
    LightEffect=13
    LightBrightness=255
    LightHue=4
    LightRadius=6
}
