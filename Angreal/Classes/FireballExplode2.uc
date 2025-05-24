//=============================================================================
// FireballExplode2.
//=============================================================================
class FireballExplode2 expands Explosion;

#exec TEXTURE IMPORT NAME=FBExp200 FILE=MODELS\E2_A00.pcx NAME=FE2_00 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp201 FILE=MODELS\E2_A01.pcx NAME=FE2_01 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp202 FILE=MODELS\E2_A02.pcx NAME=FE2_02 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp203 FILE=MODELS\E2_A03.pcx NAME=FE2_03 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp204 FILE=MODELS\E2_A04.pcx NAME=FE2_04 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp205 FILE=MODELS\E2_A05.pcx NAME=FE2_05 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp206 FILE=MODELS\E2_A06.pcx NAME=FE2_06 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp207 FILE=MODELS\E2_A07.pcx NAME=FE2_07 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp208 FILE=MODELS\E2_A08.pcx NAME=FE2_08 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp209 FILE=MODELS\E2_A09.pcx NAME=FE2_09 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp210 FILE=MODELS\E2_A10.pcx NAME=FE2_10 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp211 FILE=MODELS\E2_A11.pcx NAME=FE2_11 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp212 FILE=MODELS\E2_A12.pcx NAME=FE2_12 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp213 FILE=MODELS\E2_A13.pcx NAME=FE2_13 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp214 FILE=MODELS\E2_A14.pcx NAME=FE2_14 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp215 FILE=MODELS\E2_A15.pcx NAME=FE2_15 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp216 FILE=MODELS\E2_A16.pcx NAME=FE2_16 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp217 FILE=MODELS\E2_A17.pcx NAME=FE2_17 GROUP=Effects

// end of FireballExplode2.

defaultproperties
{
     ExplosionAnim(0)=Texture'Angreal.Effects.FBExp200'
     ExplosionAnim(1)=Texture'Angreal.Effects.FBExp201'
     ExplosionAnim(2)=Texture'Angreal.Effects.FBExp202'
     ExplosionAnim(3)=Texture'Angreal.Effects.FBExp203'
     ExplosionAnim(4)=Texture'Angreal.Effects.FBExp204'
     ExplosionAnim(5)=Texture'Angreal.Effects.FBExp205'
     ExplosionAnim(6)=Texture'Angreal.Effects.FBExp206'
     ExplosionAnim(7)=Texture'Angreal.Effects.FBExp207'
     ExplosionAnim(8)=Texture'Angreal.Effects.FBExp208'
     ExplosionAnim(9)=Texture'Angreal.Effects.FBExp209'
     ExplosionAnim(10)=Texture'Angreal.Effects.FBExp210'
     ExplosionAnim(11)=Texture'Angreal.Effects.FBExp211'
     ExplosionAnim(12)=Texture'Angreal.Effects.FBExp212'
     ExplosionAnim(13)=Texture'Angreal.Effects.FBExp213'
     ExplosionAnim(14)=Texture'Angreal.Effects.FBExp214'
     ExplosionAnim(15)=Texture'Angreal.Effects.FBExp215'
     ExplosionAnim(16)=Texture'Angreal.Effects.FBExp216'
     ExplosionAnim(17)=Texture'Angreal.Effects.FBExp217'
     LifeSpan=1.000000
     DrawScale=2.500000
     SoundPitch=32
     LightEffect=LE_NonIncidence
     LightRadius=12
}
