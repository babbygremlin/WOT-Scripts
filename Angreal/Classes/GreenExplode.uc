//=============================================================================
// GreenExplode.
//=============================================================================
class GreenExplode expands Explosion;

#exec TEXTURE IMPORT NAME=FBExp500 FILE=MODELS\E5_A00.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp501 FILE=MODELS\E5_A01.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp502 FILE=MODELS\E5_A02.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp503 FILE=MODELS\E5_A03.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp504 FILE=MODELS\E5_A04.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp505 FILE=MODELS\E5_A05.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp506 FILE=MODELS\E5_A06.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp507 FILE=MODELS\E5_A07.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp508 FILE=MODELS\E5_A08.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp509 FILE=MODELS\E5_A09.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp510 FILE=MODELS\E5_A10.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp511 FILE=MODELS\E5_A11.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp512 FILE=MODELS\E5_A12.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp513 FILE=MODELS\E5_A13.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp514 FILE=MODELS\E5_A14.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp515 FILE=MODELS\E5_A15.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=FBExp516 FILE=MODELS\E5_A16.pcx GROUP=Effects

// end of GreenExplode.

defaultproperties
{
    ExplosionAnim(0)=Texture'Effects.FBExp500'
    ExplosionAnim(1)=Texture'Effects.FBExp501'
    ExplosionAnim(2)=Texture'Effects.FBExp502'
    ExplosionAnim(3)=Texture'Effects.FBExp503'
    ExplosionAnim(4)=Texture'Effects.FBExp504'
    ExplosionAnim(5)=Texture'Effects.FBExp505'
    ExplosionAnim(6)=Texture'Effects.FBExp506'
    ExplosionAnim(7)=Texture'Effects.FBExp507'
    ExplosionAnim(8)=Texture'Effects.FBExp508'
    ExplosionAnim(9)=Texture'Effects.FBExp509'
    ExplosionAnim(10)=Texture'Effects.FBExp510'
    ExplosionAnim(11)=Texture'Effects.FBExp511'
    ExplosionAnim(12)=Texture'Effects.FBExp512'
    ExplosionAnim(13)=Texture'Effects.FBExp513'
    ExplosionAnim(14)=Texture'Effects.FBExp514'
    ExplosionAnim(15)=Texture'Effects.FBExp515'
    ExplosionAnim(16)=Texture'Effects.FBExp516'
    LifeSpan=1.00
    DrawScale=2.50
    SoundPitch=32
    LightEffect=13
    LightHue=46
    LightSaturation=60
    LightRadius=12
}
