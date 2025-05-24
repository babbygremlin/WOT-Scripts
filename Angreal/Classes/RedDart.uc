//------------------------------------------------------------------------------
// RedDart.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class RedDart expands AngrealDartProjectile;

#exec TEXTURE IMPORT FILE=MODELS\Comet_red.pcx	GROUP=Skins		FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\Corona_red.pcx	GROUP=Coronas
#exec TEXTURE IMPORT FILE=MODELS\Expl_red.pcx		GROUP=Explosions

defaultproperties
{
     CoronaTexture=Texture'Angreal.Coronas.Corona_red'
     ExplosionTexture=Texture'Angreal.Explosions.Expl_red'
     Skin=Texture'Angreal.Skins.Comet_red'
     LightHue=0
}
