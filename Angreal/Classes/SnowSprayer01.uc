//------------------------------------------------------------------------------
// SnowSprayer01.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class SnowSprayer01 expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
    Spread=95.00
    Volume=60.00
    Gravity=(X=20.00,Y=0.00,Z=-90.00),
    NumTemplates=2
    Templates(0)=(LifeSpan=0.65,Weight=1.00,MaxInitialVelocity=-20.00,MinInitialVelocity=-18.00,MaxDrawScale=0.40,MinDrawScale=0.10,MaxScaleGlow=0.00,MinScaleGlow=0.00,GrowPhase=1,MaxGrowRate=1.00,MinGrowRate=0.00,FadePhase=2,MaxFadeRate=3.00,MinFadeRate=0.00),
    Templates(1)=(LifeSpan=0.75,Weight=1.00,MaxInitialVelocity=20.00,MinInitialVelocity=-18.00,MaxDrawScale=0.40,MinDrawScale=0.10,MaxScaleGlow=0.00,MinScaleGlow=0.00,GrowPhase=2,MaxGrowRate=1.00,MinGrowRate=0.00,FadePhase=2,MaxFadeRate=3.00,MinFadeRate=0.00),
    Particles(0)=Texture'Ice.SnowE'
    Particles(1)=Texture'Ice.SnowD'
    bOn=True
    MinVolume=20.00
    bStatic=False
}
