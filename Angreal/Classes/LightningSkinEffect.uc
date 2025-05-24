//------------------------------------------------------------------------------
// LightningSkinEffect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LightningSkinEffect expands Effects;

#exec TEXTURE IMPORT FILE=MODELS\LSE_A01.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A02.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A03.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A04.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A05.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A06.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A07.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A08.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A09.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A10.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A11.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A12.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A13.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A14.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A15.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A16.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A17.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A18.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A19.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A20.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A21.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\LSE_A22.pcx GROUP=Effects

var int TextureIndex;
var() Texture LightningTextures[22];

struct LightningRingData
{
	var LSRing Ring;
	var float RiseRate;
	var vector Height;
};

var LightningRingData Rings[5];
var int RingIndex;

var() float MinRingRiseRate, MaxRingRiseRate;	// Speed rings move upward.
var() float MinRingSpawnTime, MaxRingSpawnTime;	// Time between spawning rings.
var float NextRingSpawnTime;


//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local int i;
	local vector BaseLocation;
	local float MaxHeight;
	local float FadeHeight;

	Super.Tick( DeltaTime );

	// Hide from First person perspective.
	if( PlayerPawn(Owner) != None )
	{
		bOwnerNoSee = PlayerPawn(Owner).ViewTarget == None;
	}

	// Why won't Unreal animate these for me?
	TextureIndex = (TextureIndex + 1) % ArrayCount(LightningTextures);
	SetTexture( LightningTextures[ TextureIndex ] );

	// Create new rings.
	if( Level.TimeSeconds >= NextRingSpawnTime )
	{
		NextRingSpawnTime = Level.TimeSeconds + RandRange( MinRingSpawnTime, MaxRingSpawnTime );

		RingIndex = (RingIndex + 1) % ArrayCount(Rings);
		if( Rings[ RingIndex ].Ring != None )
		{
			Rings[ RingIndex ].Ring.Destroy();
		}
		Rings[ RingIndex ].Ring = Spawn( class'LSRing' );
		Rings[ RingIndex ].RiseRate = RandRange( MinRingRiseRate, MaxRingRiseRate );
		Rings[ RingIndex ].Height = vect(0,0,0);
	}

	// Update exiting rings.
	BaseLocation = Owner.Location - (vect(0,0,1) * Owner.CollisionHeight);
	MaxHeight = Owner.CollisionHeight * 2;
	FadeHeight = MaxHeight * 0.9;
	for( i = 0; i < ArrayCount(Rings); i++ )
	{
		if( Rings[i].Ring != None )
		{
			Rings[i].Height.Z += Rings[i].RiseRate * DeltaTime;

			if( Rings[i].Height.Z > MaxHeight )
			{
				Rings[i].Ring.Destroy();
				Rings[i].Ring = None;
			}
			else
			{
				Rings[i].Ring.SetLocation( BaseLocation + Rings[i].Height );
				Rings[i].Ring.DrawScale += 0.2 * DeltaTime;
				
				// Fade rings out last 10%
				if( Rings[i].Height.Z > FadeHeight )
				{
					Rings[i].Ring.ScaleGlow = (1.0 - ((Rings[i].Height.Z - FadeHeight) / (MaxHeight - FadeHeight))) * Rings[i].Ring.default.ScaleGlow;
				}
			}
		}
	}
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	local int i;

	for( i = 0; i < ArrayCount(Rings); i++ )
	{
		if( Rings[i].Ring != None )
		{
			Rings[i].Ring.Destroy();
			Rings[i].Ring = None;
		}
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
simulated function SetTexture( Texture T )
{
	local int i;

	Texture = T;
	Skin = T;

	for( i = 0; i < ArrayCount(MultiSkins); i++ )
	{
		MultiSkins[i] = T;
	}
}

defaultproperties
{
     LightningTextures(0)=Texture'Angreal.Effects.LSE_A01'
     LightningTextures(1)=Texture'Angreal.Effects.LSE_A02'
     LightningTextures(2)=Texture'Angreal.Effects.LSE_A03'
     LightningTextures(3)=Texture'Angreal.Effects.LSE_A04'
     LightningTextures(4)=Texture'Angreal.Effects.LSE_A05'
     LightningTextures(5)=Texture'Angreal.Effects.LSE_A06'
     LightningTextures(6)=Texture'Angreal.Effects.LSE_A07'
     LightningTextures(7)=Texture'Angreal.Effects.LSE_A08'
     LightningTextures(8)=Texture'Angreal.Effects.LSE_A09'
     LightningTextures(9)=Texture'Angreal.Effects.LSE_A10'
     LightningTextures(10)=Texture'Angreal.Effects.LSE_A11'
     LightningTextures(11)=Texture'Angreal.Effects.LSE_A12'
     LightningTextures(12)=Texture'Angreal.Effects.LSE_A13'
     LightningTextures(13)=Texture'Angreal.Effects.LSE_A14'
     LightningTextures(14)=Texture'Angreal.Effects.LSE_A15'
     LightningTextures(15)=Texture'Angreal.Effects.LSE_A16'
     LightningTextures(16)=Texture'Angreal.Effects.LSE_A17'
     LightningTextures(17)=Texture'Angreal.Effects.LSE_A18'
     LightningTextures(18)=Texture'Angreal.Effects.LSE_A19'
     LightningTextures(19)=Texture'Angreal.Effects.LSE_A20'
     LightningTextures(20)=Texture'Angreal.Effects.LSE_A21'
     LightningTextures(21)=Texture'Angreal.Effects.LSE_A22'
     MinRingRiseRate=32.000000
     MaxRingRiseRate=64.000000
     MinRingSpawnTime=0.400000
     MaxRingSpawnTime=1.000000
     bAnimByOwner=True
     bNetTemporary=False
     bTrailerSameRotation=True
     Physics=PHYS_Trailer
     RemoteRole=ROLE_SimulatedProxy
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=Texture'Angreal.Effects.LSE_A01'
     Skin=Texture'Angreal.Effects.LSE_A01'
     ScaleGlow=0.500000
     AmbientGlow=200
     Fatness=157
     bUnlit=True
     MultiSkins(0)=Texture'Angreal.Effects.LSE_A01'
     MultiSkins(1)=Texture'Angreal.Effects.LSE_A01'
     MultiSkins(2)=Texture'Angreal.Effects.LSE_A01'
     MultiSkins(3)=Texture'Angreal.Effects.LSE_A01'
     MultiSkins(4)=Texture'Angreal.Effects.LSE_A01'
     MultiSkins(5)=Texture'Angreal.Effects.LSE_A01'
     MultiSkins(6)=Texture'Angreal.Effects.LSE_A01'
     MultiSkins(7)=Texture'Angreal.Effects.LSE_A01'
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=204
     LightSaturation=204
     LightRadius=12
}
