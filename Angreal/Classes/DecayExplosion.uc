//=============================================================================
// DecayExplosion.
//=============================================================================
class DecayExplosion expands Explosion;

#exec TEXTURE IMPORT NAME=DecayExplosion00 FILE=MODELS\DCEX_A01.pcx NAME=DCEX_A01 GROUP=Effects
#exec TEXTURE IMPORT NAME=DecayExplosion01 FILE=MODELS\DCEX_A02.pcx NAME=DCEX_A02 GROUP=Effects
#exec TEXTURE IMPORT NAME=DecayExplosion02 FILE=MODELS\DCEX_A03.pcx NAME=DCEX_A03 GROUP=Effects
#exec TEXTURE IMPORT NAME=DecayExplosion03 FILE=MODELS\DCEX_A04.pcx NAME=DCEX_A04 GROUP=Effects
#exec TEXTURE IMPORT NAME=DecayExplosion04 FILE=MODELS\DCEX_A05.pcx NAME=DCEX_A05 GROUP=Effects
#exec TEXTURE IMPORT NAME=DecayExplosion05 FILE=MODELS\DCEX_A06.pcx NAME=DCEX_A06 GROUP=Effects
#exec TEXTURE IMPORT NAME=DecayExplosion06 FILE=MODELS\DCEX_A07.pcx NAME=DCEX_A07 GROUP=Effects
#exec TEXTURE IMPORT NAME=DecayExplosion07 FILE=MODELS\DCEX_A08.pcx NAME=DCEX_A08 GROUP=Effects
#exec TEXTURE IMPORT NAME=DecayExplosion08 FILE=MODELS\DCEX_A09.pcx NAME=DCEX_A09 GROUP=Effects
#exec TEXTURE IMPORT NAME=DecayExplosion09 FILE=MODELS\DCEX_A10.pcx NAME=DCEX_A10 GROUP=Effects

var vector OwnerLocation;

replication
{
	reliable if( Role==ROLE_Authority && Owner!=None && !Owner.bNetRelevant )
		OwnerLocation;
}

//=============================================================================
simulated function Tick( float DeltaTime )
{
	if( Owner != None )
	{
		OwnerLocation = Owner.Location;
	}

	SetLocation( OwnerLocation );
		
	Super.Tick( DeltaTime );
}

defaultproperties
{
    ExplosionAnim(0)=Texture'Effects.DecayExplosion00'
    ExplosionAnim(1)=Texture'Effects.DecayExplosion01'
    ExplosionAnim(2)=Texture'Effects.DecayExplosion02'
    ExplosionAnim(3)=Texture'Effects.DecayExplosion03'
    ExplosionAnim(4)=Texture'Effects.DecayExplosion04'
    ExplosionAnim(5)=Texture'Effects.DecayExplosion05'
    ExplosionAnim(6)=Texture'Effects.DecayExplosion06'
    ExplosionAnim(7)=Texture'Effects.DecayExplosion07'
    ExplosionAnim(8)=Texture'Effects.DecayExplosion08'
    ExplosionAnim(9)=Texture'Effects.DecayExplosion09'
    LifeSpan=1.00
    DrawScale=0.80
    SoundPitch=32
    LightEffect=13
    LightBrightness=192
    LightHue=112
    LightSaturation=64
    LightRadius=4
}
