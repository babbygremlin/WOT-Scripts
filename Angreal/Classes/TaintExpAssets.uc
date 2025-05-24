//=============================================================================
// TaintExpAssets.
//=============================================================================
class TaintExpAssets expands Effects;

// Common assets.
#exec OBJ LOAD FILE=Textures\TaintExplodeT.utx PACKAGE=Angreal.Taint

var() int NumAnimFrames;
var() float AnimationRate;
var float InitialLifeSpan;

var vector OwnerLocation;

replication
{
	reliable if( Role==ROLE_Authority && Owner!=None && !Owner.bNetRelevant )
		OwnerLocation;
}

simulated function BeginPlay()
{
	Super.BeginPlay();

	PlayAnim( 'All', AnimationRate );
	InitialLifeSpan = (NumAnimFrames / AnimationRate) / 30.0/*fps*/;
	LifeSpan = InitialLifeSpan;
}

simulated function Tick( float DeltaTime )
{
	local float Scalar;

	Super.Tick( DeltaTime );

	Scalar = FClamp( LifeSpan / InitialLifeSpan, 0.0, 1.0 );

	ScaleGlow = default.ScaleGlow * Scalar;
	LightBrightness = default.LightBrightness * Scalar;

	if( Owner != None )
	{
		OwnerLocation = Owner.Location;
	}

	SetLocation( OwnerLocation );

/*
	if( Owner != None && Base == None )
	{
		SetLocation( Owner.Location );
		SetBase( Owner );
	}
*/
}

defaultproperties
{
    AnimationRate=0.40
    RemoteRole=0
    DrawScale=5.00
}
