//------------------------------------------------------------------------------
// PixieSprayerGreen.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class PixieSprayerGreen expands PixieSprayer;

#exec TEXTURE IMPORT FILE=MODELS\Spark01Green.pcx GROUP=Particles
#exec TEXTURE IMPORT FILE=MODELS\Spark02Green.pcx GROUP=Particles
#exec TEXTURE IMPORT FILE=MODELS\Spark03Green.pcx GROUP=Particles
#exec TEXTURE IMPORT FILE=MODELS\Spark04Green.pcx GROUP=Particles

defaultproperties
{
    Particles(0)=Texture'Particles.Spark01Green'
    Particles(1)=Texture'Particles.Spark02Green'
    Particles(2)=Texture'Particles.Spark04Green'
    Particles(3)=Texture'Particles.Spark03Green'
    LightHue=96
}
