//=============================================================================
// FireballExplode3.
//=============================================================================
class FireballExplode3 expands Explosion;

#exec TEXTURE IMPORT NAME=FBExp400 FILE=MODELS\E4_A00.pcx NAME=FE4_00 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp401 FILE=MODELS\E4_A01.pcx NAME=FE4_01 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp402 FILE=MODELS\E4_A02.pcx NAME=FE4_02 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp403 FILE=MODELS\E4_A03.pcx NAME=FE4_03 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp404 FILE=MODELS\E4_A04.pcx NAME=FE4_04 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp405 FILE=MODELS\E4_A05.pcx NAME=FE4_05 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp406 FILE=MODELS\E4_A06.pcx NAME=FE4_06 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp407 FILE=MODELS\E4_A07.pcx NAME=FE4_07 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp408 FILE=MODELS\E4_A08.pcx NAME=FE4_08 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp409 FILE=MODELS\E4_A09.pcx NAME=FE4_09 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp410 FILE=MODELS\E4_A10.pcx NAME=FE4_10 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp411 FILE=MODELS\E4_A11.pcx NAME=FE4_11 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp412 FILE=MODELS\E4_A12.pcx NAME=FE4_12 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp413 FILE=MODELS\E4_A13.pcx NAME=FE4_13 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp414 FILE=MODELS\E4_A14.pcx NAME=FE4_14 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp415 FILE=MODELS\E4_A15.pcx NAME=FE4_15 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp416 FILE=MODELS\E4_A16.pcx NAME=FE4_16 GROUP=Effects

// end of FireballExplode3.

defaultproperties
{
     ExplosionAnim(0)=Texture'Angreal.Effects.FBExp400'
     ExplosionAnim(1)=Texture'Angreal.Effects.FBExp401'
     ExplosionAnim(2)=Texture'Angreal.Effects.FBExp402'
     ExplosionAnim(3)=Texture'Angreal.Effects.FBExp403'
     ExplosionAnim(4)=Texture'Angreal.Effects.FBExp404'
     ExplosionAnim(5)=Texture'Angreal.Effects.FBExp405'
     ExplosionAnim(6)=Texture'Angreal.Effects.FBExp406'
     ExplosionAnim(7)=Texture'Angreal.Effects.FBExp407'
     ExplosionAnim(8)=Texture'Angreal.Effects.FBExp408'
     ExplosionAnim(9)=Texture'Angreal.Effects.FBExp409'
     ExplosionAnim(10)=Texture'Angreal.Effects.FBExp410'
     ExplosionAnim(11)=Texture'Angreal.Effects.FBExp411'
     ExplosionAnim(12)=Texture'Angreal.Effects.FBExp412'
     ExplosionAnim(13)=Texture'Angreal.Effects.FBExp413'
     ExplosionAnim(14)=Texture'Angreal.Effects.FBExp414'
     ExplosionAnim(15)=Texture'Angreal.Effects.FBExp415'
     ExplosionAnim(16)=Texture'Angreal.Effects.FBExp416'
     LifeSpan=1.000000
     DrawScale=2.500000
     SoundPitch=32
     LightEffect=LE_NonIncidence
     LightRadius=12
}
