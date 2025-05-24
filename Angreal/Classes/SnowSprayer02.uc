//------------------------------------------------------------------------------
// SnowSprayer02.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class SnowSprayer02 expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
    Spread=155.00
    Volume=60.00
    Gravity=(X=15.00,Y=0.00,Z=-50.00),
    NumTemplates=1
    Templates=(LifeSpan=1.00,Weight=1.00,MaxInitialVelocity=20.00,MinInitialVelocity=-10.00,MaxDrawScale=0.30,MinDrawScale=0.09,MaxScaleGlow=1.00,MinScaleGlow=0.00,GrowPhase=2,MaxGrowRate=0.00,MinGrowRate=0.00,FadePhase=2,MaxFadeRate=0.00,MinFadeRate=0.00),
    Particles=Texture'Ice.SnowB'
    bOn=True
    MinVolume=20.00
    bStatic=False
}
