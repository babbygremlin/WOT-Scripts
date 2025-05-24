//------------------------------------------------------------------------------
// WhirlwindDust.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class WhirlwindDust expands ParticleSprayer;

defaultproperties
{
    NumTemplates=3
    Templates(0)=(LifeSpan=2.00,Weight=1.00,MaxInitialVelocity=10.00,MinInitialVelocity=5.00,MaxDrawScale=0.20,MinDrawScale=0.10,MaxScaleGlow=1.00,MinScaleGlow=1.00,GrowPhase=1,MaxGrowRate=0.20,MinGrowRate=0.10,FadePhase=1,MaxFadeRate=-0.50,MinFadeRate=-0.50),
    Templates(1)=(LifeSpan=2.00,Weight=1.00,MaxInitialVelocity=10.00,MinInitialVelocity=5.00,MaxDrawScale=0.20,MinDrawScale=0.10,MaxScaleGlow=1.00,MinScaleGlow=1.00,GrowPhase=1,MaxGrowRate=0.20,MinGrowRate=0.10,FadePhase=1,MaxFadeRate=-0.50,MinFadeRate=-0.50),
    Templates(2)=(LifeSpan=2.00,Weight=1.00,MaxInitialVelocity=10.00,MinInitialVelocity=5.00,MaxDrawScale=0.20,MinDrawScale=0.10,MaxScaleGlow=1.00,MinScaleGlow=1.00,GrowPhase=1,MaxGrowRate=0.20,MinGrowRate=0.10,FadePhase=1,MaxFadeRate=-0.50,MinFadeRate=-0.50),
    Particles(0)=Texture'ParticleSystems.Smoke.particle_fog01'
    Particles(1)=Texture'ParticleSystems.Smoke.particle_fog02'
    Particles(2)=Texture'ParticleSystems.Smoke.particle_fog03'
    bOn=True
    bStatic=False
    SpriteProjForward=32.00
}
