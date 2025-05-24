//------------------------------------------------------------------------------
// SnowSprayer03.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class SnowSprayer03 expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
    Spread=10.00
    Volume=60.00
    Gravity=(X=50.00,Y=0.00,Z=0.00),
    NumTemplates=1
    Templates=(LifeSpan=0.10,Weight=1.00,MaxInitialVelocity=0.00,MinInitialVelocity=-5.00,MaxDrawScale=0.60,MinDrawScale=0.55,MaxScaleGlow=0.00,MinScaleGlow=1.00,GrowPhase=0,MaxGrowRate=1.00,MinGrowRate=0.00,FadePhase=2,MaxFadeRate=3.00,MinFadeRate=2.00),
    Particles=Texture'Ice.SnowC'
    bOn=True
    MinVolume=20.00
    bStatic=False
}
