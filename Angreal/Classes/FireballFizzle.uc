//=============================================================================
// FireballFizzle.
//=============================================================================
class FireballFizzle expands Explosion;

#exec TEXTURE IMPORT NAME=FBFiz100 FILE=MODELS\E3_A00.pcx NAME=FE3_00 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBFiz101 FILE=MODELS\E3_A01.pcx NAME=FE3_01 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBFiz102 FILE=MODELS\E3_A02.pcx NAME=FE3_02 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBFiz103 FILE=MODELS\E3_A03.pcx NAME=FE3_03 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBFiz104 FILE=MODELS\E3_A04.pcx NAME=FE3_04 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBFiz105 FILE=MODELS\E3_A05.pcx NAME=FE3_05 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBFiz106 FILE=MODELS\E3_A06.pcx NAME=FE3_06 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBFiz107 FILE=MODELS\E3_A07.pcx NAME=FE3_07 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBFiz108 FILE=MODELS\E3_A08.pcx NAME=FE3_08 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBFiz109 FILE=MODELS\E3_A09.pcx NAME=FE3_09 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBFiz110 FILE=MODELS\E3_A10.pcx NAME=FE3_10 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBFiz111 FILE=MODELS\E3_A11.pcx NAME=FE3_11 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBFiz112 FILE=MODELS\E3_A12.pcx NAME=FE3_12 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBFiz113 FILE=MODELS\E3_A13.pcx NAME=FE3_13 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBFiz114 FILE=MODELS\E3_A14.pcx NAME=FE3_14 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBFiz115 FILE=MODELS\E3_A15.pcx NAME=FE3_15 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBFiz116 FILE=MODELS\E3_A16.pcx NAME=FE3_16 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBFiz117 FILE=MODELS\E3_A17.pcx NAME=FE3_17 GROUP=Effects
#exec TEXTURE IMPORT NAME=FBFiz118 FILE=MODELS\E3_A18.pcx NAME=FE3_18 GROUP=Effects

// end of FireballFizzle.

defaultproperties
{
    ExplosionAnim(0)=Texture'Effects.FBFiz100'
    ExplosionAnim(1)=Texture'Effects.FBFiz101'
    ExplosionAnim(2)=Texture'Effects.FBFiz102'
    ExplosionAnim(3)=Texture'Effects.FBFiz103'
    ExplosionAnim(4)=Texture'Effects.FBFiz104'
    ExplosionAnim(5)=Texture'Effects.FBFiz105'
    ExplosionAnim(6)=Texture'Effects.FBFiz106'
    ExplosionAnim(7)=Texture'Effects.FBFiz107'
    ExplosionAnim(8)=Texture'Effects.FBFiz108'
    ExplosionAnim(9)=Texture'Effects.FBFiz109'
    ExplosionAnim(10)=Texture'Effects.FBFiz110'
    ExplosionAnim(11)=Texture'Effects.FBFiz111'
    ExplosionAnim(12)=Texture'Effects.FBFiz112'
    ExplosionAnim(13)=Texture'Effects.FBFiz113'
    ExplosionAnim(14)=Texture'Effects.FBFiz114'
    ExplosionAnim(15)=Texture'Effects.FBFiz115'
    ExplosionAnim(16)=Texture'Effects.FBFiz116'
    ExplosionAnim(17)=Texture'Effects.FBFiz117'
    ExplosionAnim(18)=Texture'Effects.FBFiz118'
    LifeSpan=1.00
    DrawScale=4.00
    SoundPitch=32
    LightEffect=13
    LightBrightness=128
    LightSaturation=128
    LightRadius=8
}
