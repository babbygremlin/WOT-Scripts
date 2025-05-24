//------------------------------------------------------------------------------
// BurningChunk.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class BurningChunk expands GenericProjectile;

// NOTE[aleiby]: Move to a higher level package.

#exec TEXTURE IMPORT FILE=MODELS\LavaRock.PCX GROUP=BurningChunk

var() float MinLifespan;
var() float MaxLifespan;
var() float MinSpeed;
var() float MaxSpeed;
var() float FadeoutTime;
var() bool bFlaming;

var float Duration;

var float InitialScaleGlow;
var float InitialLightBrightness;
var bool bFading;
var float FadeoutTimer;
var float Speed;

var class<ParticleSprayer> SprayerTypes[2];
var ParticleSprayer Sprayers[2];

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if( MaxLifespan > 0 )
	{
		Duration = RandRange( MinLifeSpan, MaxLifeSpan );
		Lifespan = Duration;
	}

	Speed = RandRange( MinSpeed, MaxSpeed );
	Velocity = vector(Rotation) * Speed;

	SetTimer( FRand() * 0.5, false );	// Stagger sprayer creation.
}

//------------------------------------------------------------------------------
simulated function Timer()
{
	CreateSprayers();
}

//------------------------------------------------------------------------------
simulated function CreateSprayers()
{
	local int i;
	
	if( bFlaming )
	{
		for( i = 0; i < ArrayCount(SprayerTypes); i++ )
		{
			if( SprayerTypes[i] != None )
			{
				Sprayers[i] = Spawn( SprayerTypes[i],,, Location, rotator(vect(0,0,1)) );
				Sprayers[i].FollowActor = Self;
				Sprayers[i].Disable('Tick');
			}
		}
	}
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	DestroySprayers();
	Super.Destroyed();
}

//------------------------------------------------------------------------------
simulated function DestroySprayers()
{
	local int i;

	for( i = 0; i < ArrayCount(Sprayers); i++ )
	{
		if( Sprayers[i] != None )
		{
			Sprayers[i].bOn = False;
			Sprayers[i].LifeSpan = 5.0;
		}
	}
}

//------------------------------------------------------------------------------
simulated function HitWall( vector HitNormal, Actor HitWall )
{
	//local Decal BurnMark;

	//BurnMark = Spawn( class'BurnDecal',,, Location );
	//BurnMark.Align( HitNormal );

	Bounce( HitNormal );
}

//------------------------------------------------------------------------------
simulated function Landed( vector HitNormal )
{
	local Decal BurnMark;

	BurnMark = Spawn( class'BurnDecal',,, Location );
	if( BurnMark != None )
	{
		BurnMark.Align( HitNormal );
	}

	Bounce( HitNormal );
}

//------------------------------------------------------------------------------
simulated function Touch( Actor Other )
{
	Super.Touch( Other );
	Bounce( Normal(Other.Location - Location) );
}

//------------------------------------------------------------------------------
simulated function Bounce( vector HitNormal )
{
	Velocity = (Velocity dot HitNormal) * HitNormal * Velocity;
}

//------------------------------------------------------------------------------
simulated function HitWater()
{
	local vector Loc;
	local FireballFizzle FF;

	// adjust spawn position to offset the fizzle sprite animation from the water
	Loc = Location;
	Loc.z += 39;

	FF = Spawn( class'FireballFizzle',,, Loc );
	FF.DrawScale = 0.7;
	
	LightBrightness = 0;

	DestroySprayers();
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local float Scalar;
	local int i;

	Super.Tick( DeltaTime );

	// Update Sprayer volumes.
	for( i = 0; i < ArrayCount(Sprayers); i++ )
	{
		if( Sprayers[i] != None )
		{
			Sprayers[i].Volume = Sprayers[i].default.Volume * LifeSpan / Duration;
			Sprayers[i].SetLocation( Location );
		}
	}

	// See if it is time to fade out yet.
	if( !bFading && Lifespan > 0 && Lifespan <= FadeoutTime )
	{
		Style = STY_Translucent;
		InitialScaleGlow = ScaleGlow;
		InitialLightBrightness = LightBrightness;
		FadeoutTimer = FadeoutTime;
		bFading = True;
	}

	if( bFading )
	{
		FadeoutTimer -= DeltaTime;
		if( FadeoutTimer < 0 )
		{
			FadeoutTimer = 0;
		}
		
		Scalar = FadeoutTimer / FadeoutTime;
		ScaleGlow = InitialScaleGlow * Scalar;
		LightBrightness = InitialLightBrightness * Scalar;
	}
}

defaultproperties
{
     MinLifeSpan=1.000000
     MaxLifeSpan=3.000000
     MinSpeed=100.000000
     MaxSpeed=500.000000
     FadeOutTime=0.500000
     bFlaming=True
     SprayerTypes(0)=Class'ParticleSystems.Flame01'
     Damage=1.000000
     DetailLevel=3
     Physics=PHYS_Falling
     RemoteRole=ROLE_None
     DrawType=DT_Sprite
     Style=STY_Masked
     Texture=Texture'Angreal.BurningChunk.LavaRock'
     DrawScale=0.100000
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=204
     LightHue=12
     LightRadius=1
}
