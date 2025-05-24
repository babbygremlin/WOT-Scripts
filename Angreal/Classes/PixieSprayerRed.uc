//------------------------------------------------------------------------------
// PixieSprayerRed.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class PixieSprayerRed expands PixieSprayer;

#exec TEXTURE IMPORT FILE=MODELS\Spark01Red.pcx GROUP=Particles
#exec TEXTURE IMPORT FILE=MODELS\Spark02Red.pcx GROUP=Particles
#exec TEXTURE IMPORT FILE=MODELS\Spark03Red.pcx GROUP=Particles
#exec TEXTURE IMPORT FILE=MODELS\Spark04Red.pcx GROUP=Particles

defaultproperties
{
     Particles(0)=Texture'Angreal.Particles.Spark01Red'
     Particles(1)=Texture'Angreal.Particles.Spark02Red'
     Particles(2)=Texture'Angreal.Particles.Spark04Red'
     Particles(3)=Texture'Angreal.Particles.Spark03Red'
     LightHue=0
}
