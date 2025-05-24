//------------------------------------------------------------------------------
// PurpleDart.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class PurpleDart expands AngrealDartProjectile;

#exec TEXTURE IMPORT FILE=MODELS\Comet_purple.pcx	GROUP=Skins		FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\Corona_purple.pcx	GROUP=Coronas
#exec TEXTURE IMPORT FILE=MODELS\Expl_purple.pcx	GROUP=Explosions

defaultproperties
{
     CoronaTexture=Texture'Angreal.Coronas.Corona_purple'
     ExplosionTexture=Texture'Angreal.Explosions.Expl_purple'
     Skin=Texture'Angreal.Skins.Comet_purple'
     LightHue=200
}
