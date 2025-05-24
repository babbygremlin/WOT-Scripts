//------------------------------------------------------------------------------
// AirBlastBall.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AirBlastBall expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
    Spread=0.00
    NumTemplates=3
    Templates(0)=(LifeSpan=0.30,Weight=1.00,MaxInitialVelocity=350.00,MinInitialVelocity=350.00,MaxDrawScale=0.50,MinDrawScale=0.30,MaxScaleGlow=1.00,MinScaleGlow=1.00,GrowPhase=0,MaxGrowRate=0.00,MinGrowRate=0.00,FadePhase=1,MaxFadeRate=-3.00,MinFadeRate=-3.00),
    Templates(1)=(LifeSpan=0.30,Weight=1.00,MaxInitialVelocity=350.00,MinInitialVelocity=350.00,MaxDrawScale=0.50,MinDrawScale=0.30,MaxScaleGlow=1.00,MinScaleGlow=1.00,GrowPhase=0,MaxGrowRate=0.00,MinGrowRate=0.00,FadePhase=1,MaxFadeRate=-3.00,MinFadeRate=-3.00),
    Templates(2)=(LifeSpan=0.30,Weight=1.00,MaxInitialVelocity=350.00,MinInitialVelocity=350.00,MaxDrawScale=0.50,MinDrawScale=0.30,MaxScaleGlow=1.00,MinScaleGlow=1.00,GrowPhase=0,MaxGrowRate=0.00,MinGrowRate=0.00,FadePhase=1,MaxFadeRate=-3.00,MinFadeRate=-3.00),
    Particles(0)=Texture'ParticleSystems.Appear.CyanCorona'
    Particles(1)=Texture'ParticleSystems.Flares.PF17'
    Particles(2)=Texture'ParticleSystems.Sparks.Sparks01'
    bOn=True
    MinVolume=10.00
    bStatic=False
    bStasis=True
    VisibilityRadius=2500.00
    VisibilityHeight=2500.00
}
