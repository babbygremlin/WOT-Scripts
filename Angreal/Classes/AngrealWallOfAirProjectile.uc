//------------------------------------------------------------------------------
// AngrealWallOfAirProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 7 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealWallOfAirProjectile expands AngrealProjectile;

#exec MESH IMPORT MESH=WallOfAir ANIVFILE=MODELS\WallOfAir_a.3d DATAFILE=MODELS\WallOfAir_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=WallOfAir X=0 Y=0 Z=0 YAW=-64

#exec MESH SEQUENCE MESH=WallOfAir SEQ=All         STARTFRAME=0 NUMFRAMES=22
#exec MESH SEQUENCE MESH=WallOfAir SEQ=WallOfAir STARTFRAME=0 NUMFRAMES=22

#exec TEXTURE IMPORT NAME=JWallOfAir0 FILE=MODELS\WallOfAir.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=WallOfAir MESH=WallOfAir
#exec MESHMAP SCALE MESHMAP=WallOfAir X=0.5 Y=0.5 Z=1.0

#exec MESHMAP SETTEXTURE MESHMAP=WallOfAir NUM=0 TEXTURE=JWallOfAir0

#exec AUDIO IMPORT FILE=Sounds\WallOfAir\LaunchWA.wav	GROUP=WallOfAir
#exec AUDIO IMPORT FILE=Sounds\WallOfAir\LoopWA.wav		GROUP=WallOfAir
#exec AUDIO IMPORT FILE=Sounds\WallOfAir\DeflectWA.wav	GROUP=WallOfAir

var Actor Source;
var Actor Destination;

var vector SourceLocation;
var vector DestinationLocation;

var() float PctDistFromSource;

var() Sound SpawnSound, DeflectSound;

var() name UnAffectedTypes[2];		// Types of projectiles we are not allowed to destroy.

replication
{
	unreliable if( Role==ROLE_Authority )
		SourceLocation, DestinationLocation;
}

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LoopAnim( 'ALL', 1.0 );
	PlaySound( SpawnSound );
	Super.PreBeginPlay();
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	// Make sure we still got things to work with.
	if( Role == ROLE_Authority )
	{
		if
		(	(Pawn(Source) == None		|| Pawn(Source).Health <= 0)
		||	(Pawn(Destination) == None	|| Pawn(Destination).Health <= 0)
		)
		{
			Destroy();
			return;
		}
	}

	if( Source != None )
	{
		SourceLocation = Source.Location;
	}

	if( Destination != None )
	{
		DestinationLocation = Destination.Location;
	}

	SetLocation( SourceLocation + ((DestinationLocation - SourceLocation)*PctDistFromSource) );
	SetRotation( rotator(DestinationLocation - SourceLocation) );
	
	Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Role == ROLE_Authority )
	{
		SourceAngreal.UnCast();
	}
	Super.Destroyed();
}

//------------------------------------------------------------------------------
simulated function Touch( Actor Other )
{
	if( IsAffectable( Other ) )
	{
		if( AngrealProjectile(Other) != None )
		{
			//AngrealProjectile(Other).Explode( Other.Location, Normal( Other.Location - Location ) );	// This causes seekers to attach effects to thier destinations.
			Other.Destroy();
			Other.PlaySound( DeflectSound );
			Spawn( class'WOTSparks',,, Other.Location, rotator(Other.Location-Location) );
		}
		else if( WOTProjectile(Other) != None )
		{
			Other.Velocity = vect(0,0,-1);
			Other.Acceleration = vect(0,0,-950);
			Other.SetLocation( Other.Location );	// To set bJustTeleported to trick the physic code into letting me change the velocity.
			Spawn( class'WOTSparks',,, Other.Location, rotator(Other.Location-Location) );
		}
	}
}

//------------------------------------------------------------------------------
simulated function bool IsAffectable( Actor Other )
{
	local int i;

	for( i = 0; i < ArrayCount(UnAffectedTypes); i++ )
	{
		if( UnAffectedTypes[i] != '' )
		{
			if( Other.IsA( UnAffectedTypes[i] ) )
			{
				return false;
			}
		}
	}

	return true;
}

/////////////
// Ignores //
/////////////

//------------------------------------------------------------------------------
simulated function HitWall (vector HitNormal, actor Wall);

//------------------------------------------------------------------------------
simulated function Explode(vector HitLocation, vector HitNormal);

defaultproperties
{
    PctDistFromSource=0.33
    SpawnSound=Sound'WallOfAir.LaunchWA'
    DeflectSound=Sound'WallOfAir.DeflectWA'
    UnAffectedTypes(0)=MashadarGuide
    UnAffectedTypes(1)=MachinShin
    bCanTeleport=False
    bNetTemporary=False
    Physics=0
    LifeSpan=0.00
    Mesh=Mesh'WallOfAir'
    SoundRadius=255
    SoundVolume=255
    AmbientSound=Sound'WallOfAir.LoopWA'
    CollisionRadius=75.00
    CollisionHeight=75.00
    bCollideWorld=False
    LightType=1
    LightEffect=13
    LightBrightness=88
    LightHue=204
    LightSaturation=204
    LightRadius=12
}
