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
    Spread=90.00
    Volume=50.00
    Gravity=(X=0.00,Y=0.00,Z=-400.00),
    NumTemplates=2
    Templates(0)=(LifeSpan=5.00,Weight=1.00,MaxInitialVelocity=200.00,MinInitialVelocity=-10.00,MaxDrawScale=0.70,MinDrawScale=0.20,MaxScaleGlow=1.00,MinScaleGlow=1.00,GrowPhase=1,MaxGrowRate=-0.50,MinGrowRate=-0.50,FadePhase=1,MaxFadeRate=-2.00,MinFadeRate=-2.00),
    Templates(1)=(LifeSpan=5.00,Weight=20.00,MaxInitialVelocity=200.00,MinInitialVelocity=-10.00,MaxDrawScale=0.70,MinDrawScale=0.20,MaxScaleGlow=1.00,MinScaleGlow=1.00,GrowPhase=1,MaxGrowRate=-0.50,MinGrowRate=-0.50,FadePhase=1,MaxFadeRate=-1.00,MinFadeRate=-1.00),
    Particles(0)=Texture'Sparks.LightningSpark05'
    Particles(1)=Texture'Sparks.LightningSpark04'
    bOn=True
    bStatic=False
    VisibilityRadius=500.00
    VisibilityHeight=500.00
}
