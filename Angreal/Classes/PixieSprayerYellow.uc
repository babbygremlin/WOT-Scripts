//------------------------------------------------------------------------------
// PixieSprayerYellow.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class PixieSprayerYellow expands PixieSprayer;

#exec TEXTURE IMPORT FILE=MODELS\Spark01Yellow.pcx GROUP=Particles
#exec TEXTURE IMPORT FILE=MODELS\Spark02Yellow.pcx GROUP=Particles
#exec TEXTURE IMPORT FILE=MODELS\Spark03Yellow.pcx GROUP=Particles
#exec TEXTURE IMPORT FILE=MODELS\Spark04Yellow.pcx GROUP=Particles

defaultproperties
{
    Particles(0)=Texture'Particles.Spark01Yellow'
    Particles(1)=Texture'Particles.Spark02Yellow'
    Particles(2)=Texture'Particles.Spark04Yellow'
    Particles(3)=Texture'Particles.Spark03Yellow'
    LightHue=50
}
