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
     Spread=60.000000
     Volume=30.000000
     Gravity=(X=-800.000000,Z=80.000000)
     NumTemplates=5
     Templates(0)=(MaxInitialVelocity=250.000000,MinInitialVelocity=200.000000,MaxDrawScale=0.700000,MinDrawScale=0.300000,MinScaleGlow=0.500000,GrowPhase=1,MaxGrowRate=-0.300000,MinGrowRate=-0.300000,FadePhase=1,MaxFadeRate=-0.400000,MinFadeRate=-0.400000)
     Templates(1)=(LifeSpan=1.500000,MaxInitialVelocity=250.000000,MinInitialVelocity=196.000000,MaxDrawScale=0.700000,MinDrawScale=0.300000,MaxScaleGlow=0.700000,MinScaleGlow=0.500000,GrowPhase=1,MaxGrowRate=-0.300000,MinGrowRate=-0.300000,FadePhase=1,MaxFadeRate=-0.400000,MinFadeRate=-0.400000)
     Templates(2)=(LifeSpan=2.000000,MaxInitialVelocity=290.000000,MinInitialVelocity=-220.000000,MaxDrawScale=0.500000,MinDrawScale=0.200000,MaxScaleGlow=0.600000,MinScaleGlow=0.300000,GrowPhase=1,MaxGrowRate=-0.200000,MinGrowRate=-0.200000,FadePhase=1,MaxFadeRate=-0.200000,MinFadeRate=-0.200000)
     Templates(3)=(LifeSpan=2.000000,MaxDrawScale=0.800000,MinDrawScale=0.600000,MaxScaleGlow=0.400000,MinScaleGlow=0.200000,GrowPhase=1,MaxGrowRate=0.800000,MinGrowRate=0.800000,FadePhase=1,MaxFadeRate=-0.400000,MinFadeRate=-0.400000)
     Templates(4)=(LifeSpan=1.500000,MinDrawScale=0.500000,MaxScaleGlow=0.700000,MinScaleGlow=0.200000,GrowPhase=1,MaxGrowRate=0.500000,MinGrowRate=0.500000,FadePhase=1,MaxFadeRate=-0.300000,MinFadeRate=-0.300000)
     Particles(0)=Texture'ParticleSystems.Flares.PF14'
     Particles(1)=Texture'ParticleSystems.Flares.PF13'
     Particles(2)=Texture'ParticleSystems.Flares.PF06'
     Particles(3)=Texture'ParticleSystems.Smoke.SmokeBase01'
     Particles(4)=Texture'ParticleSystems.Smoke.particle_fog01'
     bStatic=False
}
