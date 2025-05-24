//------------------------------------------------------------------------------
// PixieSprayerBlue.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class PixieSprayerBlue expands PixieSprayer;

#exec TEXTURE IMPORT FILE=MODELS\Spark01Blue.pcx GROUP=Particles
#exec TEXTURE IMPORT FILE=MODELS\Spark02Blue.pcx GROUP=Particles
#exec TEXTURE IMPORT FILE=MODELS\Spark03Blue.pcx GROUP=Particles
#exec TEXTURE IMPORT FILE=MODELS\Spark04Blue.pcx GROUP=Particles

defaultproperties
{
    Particles(0)=Texture'Particles.Spark01Blue'
    Particles(1)=Texture'Particles.Spark02Blue'
    Particles(2)=Texture'Particles.Spark04Blue'
    Particles(3)=Texture'Particles.Spark03Blue'
    LightHue=140
}
