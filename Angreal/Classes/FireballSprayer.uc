//------------------------------------------------------------------------------
// FireballSprayer.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class FireballSprayer expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
    Spread=60.00
    Volume=30.00
    Gravity=(X=-800.00,Y=0.00,Z=80.00),
    NumTemplates=5
    Templates(0)=(LifeSpan=1.00,Weight=1.00,MaxInitialVelocity=250.00,MinInitialVelocity=200.00,MaxDrawScale=0.70,MinDrawScale=0.30,MaxScaleGlow=1.00,MinScaleGlow=0.50,GrowPhase=1,MaxGrowRate=-0.30,MinGrowRate=-0.30,FadePhase=1,MaxFadeRate=-0.40,MinFadeRate=-0.40),
    Templates(1)=(LifeSpan=1.50,Weight=1.00,MaxInitialVelocity=250.00,MinInitialVelocity=196.00,MaxDrawScale=0.70,MinDrawScale=0.30,MaxScaleGlow=0.70,MinScaleGlow=0.50,GrowPhase=1,MaxGrowRate=-0.30,MinGrowRate=-0.30,FadePhase=1,MaxFadeRate=-0.40,MinFadeRate=-0.40),
    Templates(2)=(LifeSpan=2.00,Weight=1.00,MaxInitialVelocity=290.00,MinInitialVelocity=-220.00,MaxDrawScale=0.50,MinDrawScale=0.20,MaxScaleGlow=0.60,MinScaleGlow=0.30,GrowPhase=1,MaxGrowRate=-0.20,MinGrowRate=-0.20,FadePhase=1,MaxFadeRate=-0.20,MinFadeRate=-0.20),
    Templates(3)=(LifeSpan=2.00,Weight=1.00,MaxInitialVelocity=0.00,MinInitialVelocity=0.00,MaxDrawScale=0.80,MinDrawScale=0.60,MaxScaleGlow=0.40,MinScaleGlow=0.20,GrowPhase=1,MaxGrowRate=0.80,MinGrowRate=0.80,FadePhase=1,MaxFadeRate=-0.40,MinFadeRate=-0.40),
    Templates(4)=(LifeSpan=1.50,Weight=1.00,MaxInitialVelocity=0.00,MinInitialVelocity=0.00,MaxDrawScale=1.00,MinDrawScale=0.50,MaxScaleGlow=0.70,MinScaleGlow=0.20,GrowPhase=1,MaxGrowRate=0.50,MinGrowRate=0.50,FadePhase=1,MaxFadeRate=-0.30,MinFadeRate=-0.30),
    Particles(0)=Texture'ParticleSystems.Flares.PF14'
    Particles(1)=Texture'ParticleSystems.Flares.PF13'
    Particles(2)=Texture'ParticleSystems.Flares.PF06'
    Particles(3)=Texture'ParticleSystems.Smoke.SmokeBase01'
    Particles(4)=Texture'ParticleSystems.Smoke.particle_fog01'
    bStatic=False
}
