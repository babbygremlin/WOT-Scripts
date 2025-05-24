//=============================================================================
// MyrddraalElectric.
//=============================================================================
class MyrddraalElectric expands Explosion;

#exec TEXTURE IMPORT FILE=MODELS\MyrdElectric01.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\MyrdElectric02.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\MyrdElectric03.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\MyrdElectric04.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\MyrdElectric05.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\MyrdElectric06.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\MyrdElectric07.pcx GROUP=Effects

// end of MyrddraalElectric.

defaultproperties
{
     ExplosionAnim(0)=Texture'WOTPawns.Effects.MyrdElectric01'
     ExplosionAnim(1)=Texture'WOTPawns.Effects.MyrdElectric02'
     ExplosionAnim(2)=Texture'WOTPawns.Effects.MyrdElectric03'
     ExplosionAnim(3)=Texture'WOTPawns.Effects.MyrdElectric04'
     ExplosionAnim(4)=Texture'WOTPawns.Effects.MyrdElectric05'
     ExplosionAnim(5)=Texture'WOTPawns.Effects.MyrdElectric06'
     ExplosionAnim(6)=Texture'WOTPawns.Effects.MyrdElectric07'
     LifeSpan=0.400000
     DrawScale=0.500000
     LightType=LT_None
}
