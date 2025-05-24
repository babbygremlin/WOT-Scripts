//------------------------------------------------------------------------------
// BalefireCorona.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	Gather effect for Balefire.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class BalefireCorona expands Effects;

#exec TEXTURE IMPORT FILE=MODELS\BFCorona.PCX	GROUP=Effects		FLAGS=2
/*
#exec TEXTURE IMPORT FILE=MODELS\BFHand_A01.PCX	GROUP=BalefireHand	FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\BFHand_A02.PCX	GROUP=BalefireHand	FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\BFHand_A03.PCX	GROUP=BalefireHand	FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\BFHand_A04.PCX	GROUP=BalefireHand	FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\BFHand_A05.PCX	GROUP=BalefireHand	FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\BFHand_A06.PCX	GROUP=BalefireHand	FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\BFHand_A07.PCX	GROUP=BalefireHand	FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\BFHand_A08.PCX	GROUP=BalefireHand	FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\BFHand_A09.PCX	GROUP=BalefireHand	FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\BFHand_A10.PCX	GROUP=BalefireHand	FLAGS=2
*/
#exec OBJ LOAD FILE=Textures\BalefireGather.utx PACKAGE=Angreal.BalefireHand

var ParticleSprayer SP[6];
var() Texture SPTexture[6];
var() float SPRadius;

var Pawn FollowPawn;	// Pawn we are following.
var rotator FollowPawnViewRotation;

var vector LastLocation;
var() float FollowFactor;

var() float FadeVolumeRate;

var() vector RelativeOffset;

replication
{
	reliable if( Role==ROLE_Authority )
		FollowPawn, FollowPawnViewRotation;
}

//------------------------------------------------------------------------------
simulated function BeginPlay()
{
	Super.BeginPlay();
	LastLocation = Location;
	SoundVolume = 0;
}

//-----------------------------------------------------------------------------
function SetFollowPawn( Pawn FollowPawn )
{
	Self.FollowPawn = FollowPawn;
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local vector DesiredLocation;
	local int i;

	if( SoundVolume < default.SoundVolume )
	{
		SoundVolume = Min( SoundVolume + (default.SoundVolume * (FadeVolumeRate * DeltaTime)), 255 );
	}
	
	// Update position relative to FollowPawn.
	if( FollowPawn == None )
	{
		Destroy();
		return;
	}

	if( Role == ROLE_Authority || (PlayerPawn(FollowPawn) != None && PlayerPawn(FollowPawn).Player != None) )
	{
		FollowPawnViewRotation = FollowPawn.ViewRotation;
	}

/* -- OLD
	DesiredLocation = FollowPawn.Location;
	DesiredLocation.z += FollowPawn.BaseEyeHeight;
	DesiredLocation += vect(50,0,0) >> FollowPawn.ViewRotation;
	LastLocation += (DesiredLocation - LastLocation) / FollowFactor;
	SetLocation( LastLocation );
*/
	// Sync with player's crosshair.
	DesiredLocation = FollowPawn.Location;
	DesiredLocation.z += FollowPawn.BaseEyeHeight;
	DesiredLocation += RelativeOffset >> FollowPawnViewRotation;	
	SetLocation( DesiredLocation );

	// Create particles if needed.
	for( i = 0; i < ArrayCount(SP); i++ )
	{
		if( SP[i] == None )
		{
			SP[i] = Spawn( class'BFSprayer',,, Location, FollowPawn.ViewRotation );
			SP[i].Particles[0] = SPTexture[i];
		}
	}

	// Orient to the six sides of a cube pointing in.
	SP[0].SetLocation( DesiredLocation + ((vect( 1, 0, 0) * SPRadius) >> Rotation) );
	SP[1].SetLocation( DesiredLocation + ((vect(-1, 0, 0) * SPRadius) >> Rotation) );
	SP[2].SetLocation( DesiredLocation + ((vect( 0, 1, 0) * SPRadius) >> Rotation) );
	SP[3].SetLocation( DesiredLocation + ((vect( 0,-1, 0) * SPRadius) >> Rotation) );
	SP[4].SetLocation( DesiredLocation + ((vect( 0, 0, 1) * SPRadius) >> Rotation) );
	SP[5].SetLocation( DesiredLocation + ((vect( 0, 0,-1) * SPRadius) >> Rotation) );	
	for( i = 0; i < ArrayCount(SP); i++ )
	{
		SP[i].SetRotation( rotator(DesiredLocation - SP[i].Location) );
	}

	// Keep particles grouped together.
	if( LastLocation != vect(0,0,0) )
	{
		for( i = 0; i < ArrayCount(SP); i++ )
		{
			SP[i].ShiftParticles( DesiredLocation - LastLocation );
		}
	}
	LastLocation = DesiredLocation;
}	

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	local vector GravDir;
	local int i;

	if( FollowPawn != None )
		GravDir = vector(FollowPawn.ViewRotation) * 10000;

	for( i = 0; i < ArrayCount(SP); i++ )
	{
		if( SP[i] != None )
		{
			SP[i].bOn = False;
			SP[i].LifeSpan = 2.0;
			SP[i].Gravity = GravDir;
			SP[i] = None;
		}
	}

	Super.Destroyed();
}

defaultproperties
{
    SPTexture(0)=Texture'ParticleSystems.Appear.PurpleCorona'
    SPTexture(1)=Texture'ParticleSystems.Appear.PurpleSpark'
    SPTexture(2)=Texture'ParticleSystems.Appear.WhiteCorona'
    SPTexture(3)=Texture'ParticleSystems.Appear.APurpleCorona'
    SPTexture(4)=Texture'ParticleSystems.Appear.BlueSpark'
    SPTexture(5)=Texture'ParticleSystems.Flares.PF04'
    SPRadius=30.00
    FollowFactor=1.00
    FadeVolumeRate=0.50
    RelativeOffset=(X=50.00,Y=0.00,Z=-30.00),
    bNetTemporary=False
    Physics=5
    RemoteRole=2
    DrawType=1
    Style=3
    Texture=Texture'BalefireHand.hand.BFHand_A01'
    DrawScale=0.50
    AmbientGlow=200
    SoundRadius=72
    SoundVolume=255
    AmbientSound=Sound'Balefire.LoopBF'
    LightType=1
    LightEffect=13
    LightBrightness=255
    LightSaturation=255
    LightRadius=5
    bFixedRotationDir=True
    RotationRate=(Pitch=100000,Yaw=80000,Roll=60000),
}
