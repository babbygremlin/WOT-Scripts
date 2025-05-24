//------------------------------------------------------------------------------
// YellowDart.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class YellowDart expands AngrealDartProjectile;

#exec TEXTURE IMPORT FILE=MODELS\Comet_yellow.pcx	GROUP=Skins		FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\Corona_yellow.pcx	GROUP=Coronas
#exec TEXTURE IMPORT FILE=MODELS\Expl_yellow.pcx		GROUP=Explosions

defaultproperties
{
    CoronaTexture=Texture'Coronas.Corona_yellow'
    ExplosionTexture=Texture'Explosions.Expl_yellow'
    Skin=Texture'Skins.Comet_yellow'
    LightHue=30
}
