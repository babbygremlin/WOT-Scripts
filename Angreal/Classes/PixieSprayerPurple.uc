//------------------------------------------------------------------------------
// PixieSprayerPurple.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class PixieSprayerPurple expands PixieSprayer;

#exec TEXTURE IMPORT FILE=MODELS\Spark01Purple.pcx GROUP=Particles
#exec TEXTURE IMPORT FILE=MODELS\Spark02Purple.pcx GROUP=Particles
#exec TEXTURE IMPORT FILE=MODELS\Spark03Purple.pcx GROUP=Particles
#exec TEXTURE IMPORT FILE=MODELS\Spark04Purple.pcx GROUP=Particles

defaultproperties
{
    Particles(0)=Texture'Particles.Spark01Purple'
    Particles(1)=Texture'Particles.Spark02Purple'
    Particles(2)=Texture'Particles.Spark04Purple'
    Particles(3)=Texture'Particles.Spark03Purple'
}
