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
     Templates(0)=(LifeSpan=2.000000,MaxInitialVelocity=10.000000,MinInitialVelocity=5.000000,MaxDrawScale=0.200000,MinDrawScale=0.100000,GrowPhase=1,MaxGrowRate=0.200000,MinGrowRate=0.100000,FadePhase=1,MaxFadeRate=-0.500000,MinFadeRate=-0.500000)
     Templates(1)=(LifeSpan=2.000000,MaxInitialVelocity=10.000000,MinInitialVelocity=5.000000,MaxDrawScale=0.200000,MinDrawScale=0.100000,GrowPhase=1,MaxGrowRate=0.200000,MinGrowRate=0.100000,FadePhase=1,MaxFadeRate=-0.500000,MinFadeRate=-0.500000)
     Templates(2)=(LifeSpan=2.000000,MaxInitialVelocity=10.000000,MinInitialVelocity=5.000000,MaxDrawScale=0.200000,MinDrawScale=0.100000,GrowPhase=1,MaxGrowRate=0.200000,MinGrowRate=0.100000,FadePhase=1,MaxFadeRate=-0.500000,MinFadeRate=-0.500000)
     Particles(0)=Texture'ParticleSystems.Smoke.particle_fog01'
     Particles(1)=Texture'ParticleSystems.Smoke.particle_fog02'
     Particles(2)=Texture'ParticleSystems.Smoke.particle_fog03'
     bOn=True
     bStatic=False
     SpriteProjForward=32.000000
}
