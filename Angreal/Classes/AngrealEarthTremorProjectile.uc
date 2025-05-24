//------------------------------------------------------------------------------
// AngrealEarthTremorProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 8 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealEarthTremorProjectile expands GenericProjectile;

#exec TEXTURE IMPORT FILE=MODELS\ETL_A01.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A02.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A03.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A04.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A05.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A06.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A07.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A08.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A09.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A10.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A11.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A12.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A13.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A14.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A15.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A16.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A17.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A18.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A19.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A20.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A21.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A22.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A23.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A24.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A25.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A26.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A27.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A28.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A29.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\ETL_A30.pcx GROUP=Effects

#exec AUDIO IMPORT FILE=Sounds\EarthTremor\HitLevelET.wav		GROUP=EarthTremor
#exec AUDIO IMPORT FILE=Sounds\EarthTremor\HitWaterET.wav		GROUP=EarthTremor
#exec AUDIO IMPORT FILE=Sounds\EarthTremor\LaunchET.wav			GROUP=EarthTremor

var vector HitWallNormal;
var() float WaitTime;

var rotator ClientRotation;		// Since Rotation isn't replication for Sprites.

replication
{
	reliable if( Role==ROLE_Authority )
		ClientRotation;
}

//------------------------------------------------------------------------------
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if( Role == ROLE_Authority )
	{
		// Override normal velocity calculation.
		Velocity = ( Vector(Rotation) + vect(0,0,0.3) ) * Speed;
		//SetPhysics( PHYS_Falling );

		// Send rotation to the client.
		ClientRotation = Rotation;
	}
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	// Get rotation from the server.
	if( Role < ROLE_Authority && Rotation != ClientRotation )
	{
		SetRotation( ClientRotation );
	}

	Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
simulated function Explode( vector HitLocation, vector HitNormal )
{
	local vector X, Y, Z;
	local rotator Rot;
	local EarthTremor ET;
	
	GetAxes( Rotation, X, Y, Z );
	
	Z = HitNormal;
	Y = Z cross vector(Rotation);
	X = Z cross -Y;

	ET = Spawn( class'EarthTremor',,, Location, OrthoRotation( X, Y, Z ) );
	ET.SetSourceAngreal( SourceAngreal );
	ET.Instigator = Instigator;
	ET.Go();

	SpawnChunks( class'LavaRock', Location, HitNormal );

	if( FRand() < 0.5 )
	{
		Spawn( class'FireballExplode' );
	}
	else
	{
		Spawn( class'FireballExplode2' );
	}
	
	Super.Explode( HitLocation, HitNormal );
}

/*
//------------------------------------------------------------------------------
simulated function ProjTouch( Actor Other )
{
	DM( Self$"::ProjTouch: "$Other );
	Super.ProjTouch( Other );
	Touch( Other );
}
*/

////////////////
// AI Support // 
////////////////

//------------------------------------------------------------------------------
static function rotator CalculateTrajectory( Actor Source, Actor Destination )
{
	local vector Direction;

	// NOTE[aleiby]: Use correct math.
	Direction = Normal(Destination.Location - Source.Location);	// Aim toward Destination.
	Direction.z = 0.33;											// Aim up 30 degrees for safe measure.

	return rotator(Direction);
}

//------------------------------------------------------------------------------
// Min safe distance this projectile may be fired.
//------------------------------------------------------------------------------
static function float GetMinRange()
{
	return 300.0;	// NOTE[aleiby]: Bad coder.... no hardcoded values.
}

defaultproperties
{
     WaitTime=1.000000
     HitPawnSound=Sound'Angreal.EarthTremor.HitLevelET'
     HitWaterSound=Sound'Angreal.EarthTremor.HitWaterET'
     DamageRadius=280.000000
     HitWaterClass=Class'Angreal.FireballFizzle'
     HitWaterOffset=(Z=56.000000)
     speed=500.000000
     Damage=30.000000
     MomentumTransfer=10000
     SpawnSound=Sound'Angreal.EarthTremor.LaunchET'
     ImpactSound=Sound'Angreal.EarthTremor.HitLevelET'
     bAnimLoop=True
     Physics=PHYS_Falling
     AnimRate=0.400000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'Angreal.Effects.ETL_A01'
     DrawScale=0.800000
     AmbientGlow=211
     bUnlit=True
     bAlwaysRelevant=True
     SoundRadius=160
     SoundVolume=100
     SoundPitch=96
     CollisionRadius=6.000000
     CollisionHeight=12.000000
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=192
     LightHue=20
     LightSaturation=32
     LightRadius=8
     bBounce=True
}
