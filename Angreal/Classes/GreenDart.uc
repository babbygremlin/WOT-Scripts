//------------------------------------------------------------------------------
// GreenDart.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class GreenDart expands AngrealDartProjectile;

#exec TEXTURE IMPORT FILE=MODELS\Comet_green.pcx	GROUP=Skins		FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\Corona_green.pcx	GROUP=Coronas
#exec TEXTURE IMPORT FILE=MODELS\Expl_green.pcx		GROUP=Explosions

defaultproperties
{
    CoronaTexture=Texture'Coronas.Corona_green'
    ExplosionTexture=Texture'Explosions.Expl_green'
    Skin=Texture'Skins.Comet_green'
    LightHue=110
}
