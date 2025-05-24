//------------------------------------------------------------------------------
// LightningSparks.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LightningSparks expands ParticleSprayer;

#exec TEXTURE IMPORT FILE=MODELS\LightningSpark01.pcx GROUP=Sparks
#exec TEXTURE IMPORT FILE=MODELS\LightningSpark02.pcx GROUP=Sparks
#exec TEXTURE IMPORT FILE=MODELS\LightningSpark03.pcx GROUP=Sparks
#exec TEXTURE IMPORT FILE=MODELS\LightningSpark04.pcx GROUP=Sparks
#exec TEXTURE IMPORT FILE=MODELS\LightningSpark05.pcx GROUP=Sparks

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Spread=90.000000
     Volume=50.000000
     Gravity=(Z=-400.000000)
     NumTemplates=2
     Templates(0)=(LifeSpan=5.000000,MaxInitialVelocity=200.000000,MinInitialVelocity=-10.000000,MaxDrawScale=0.700000,MinDrawScale=0.200000,GrowPhase=1,MaxGrowRate=-0.500000,MinGrowRate=-0.500000,FadePhase=1,MaxFadeRate=-2.000000,MinFadeRate=-2.000000)
     Templates(1)=(LifeSpan=5.000000,Weight=20.000000,MaxInitialVelocity=200.000000,MinInitialVelocity=-10.000000,MaxDrawScale=0.700000,MinDrawScale=0.200000,GrowPhase=1,MaxGrowRate=-0.500000,MinGrowRate=-0.500000,FadePhase=1,MaxFadeRate=-1.000000,MinFadeRate=-1.000000)
     Particles(0)=Texture'Angreal.Sparks.LightningSpark05'
     Particles(1)=Texture'Angreal.Sparks.LightningSpark04'
     bOn=True
     bStatic=False
     VisibilityRadius=500.000000
     VisibilityHeight=500.000000
}
