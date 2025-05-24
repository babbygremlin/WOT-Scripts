//------------------------------------------------------------------------------
// BlueDart.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class BlueDart expands AngrealDartProjectile;

#exec TEXTURE IMPORT FILE=MODELS\Comet_blue.pcx		GROUP=Skins		FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\Corona_blue.pcx	GROUP=Coronas
#exec TEXTURE IMPORT FILE=MODELS\Expl_blue.pcx		GROUP=Explosions

defaultproperties
{
    CoronaTexture=Texture'Coronas.Corona_blue'
    ExplosionTexture=Texture'Explosions.Expl_blue'
    Skin=Texture'Skins.Comet_blue'
}
