//=============================================================================
// FireballExplode.
//=============================================================================
class FireballExplode expands Explosion;

#exec TEXTURE IMPORT NAME=FBExp100 FILE=MODELS\E1_A00.pcx NAME=FE1_00 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp101 FILE=MODELS\E1_A01.pcx NAME=FE1_01 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp102 FILE=MODELS\E1_A02.pcx NAME=FE1_02 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp103 FILE=MODELS\E1_A03.pcx NAME=FE1_03 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp104 FILE=MODELS\E1_A04.pcx NAME=FE1_04 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp105 FILE=MODELS\E1_A05.pcx NAME=FE1_05 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp106 FILE=MODELS\E1_A06.pcx NAME=FE1_06 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp107 FILE=MODELS\E1_A07.pcx NAME=FE1_07 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp108 FILE=MODELS\E1_A08.pcx NAME=FE1_08 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp109 FILE=MODELS\E1_A09.pcx NAME=FE1_09 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp110 FILE=MODELS\E1_A10.pcx NAME=FE1_10 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp111 FILE=MODELS\E1_A11.pcx NAME=FE1_11 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp112 FILE=MODELS\E1_A12.pcx NAME=FE1_12 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp113 FILE=MODELS\E1_A13.pcx NAME=FE1_13 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp114 FILE=MODELS\E1_A14.pcx NAME=FE1_14 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp115 FILE=MODELS\E1_A15.pcx NAME=FE1_15 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp116 FILE=MODELS\E1_A16.pcx NAME=FE1_16 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp117 FILE=MODELS\E1_A17.pcx NAME=FE1_17 GROUP=Effects

// end of FireballExplode.

defaultproperties
{
    ExplosionAnim(0)=Texture'Effects.FBExp100'
    ExplosionAnim(1)=Texture'Effects.FBExp101'
    ExplosionAnim(2)=Texture'Effects.FBExp102'
    ExplosionAnim(3)=Texture'Effects.FBExp103'
    ExplosionAnim(4)=Texture'Effects.FBExp104'
    ExplosionAnim(5)=Texture'Effects.FBExp105'
    ExplosionAnim(6)=Texture'Effects.FBExp106'
    ExplosionAnim(7)=Texture'Effects.FBExp107'
    ExplosionAnim(8)=Texture'Effects.FBExp108'
    ExplosionAnim(9)=Texture'Effects.FBExp109'
    ExplosionAnim(10)=Texture'Effects.FBExp110'
    ExplosionAnim(11)=Texture'Effects.FBExp111'
    ExplosionAnim(12)=Texture'Effects.FBExp112'
    ExplosionAnim(13)=Texture'Effects.FBExp113'
    ExplosionAnim(14)=Texture'Effects.FBExp114'
    ExplosionAnim(15)=Texture'Effects.FBExp115'
    ExplosionAnim(16)=Texture'Effects.FBExp116'
    ExplosionAnim(17)=Texture'Effects.FBExp117'
    LifeSpan=1.00
    DrawScale=2.50
    SoundPitch=32
    LightEffect=13
    LightRadius=12
}
