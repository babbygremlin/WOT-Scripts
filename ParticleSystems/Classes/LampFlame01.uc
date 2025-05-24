//------------------------------------------------------------------------------
// LampFlame01.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LampFlame01 expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Spread=5.000000
     Volume=15.000000
     NumTemplates=3
     Templates(0)=(LifeSpan=0.500000,Weight=2.000000,MaxInitialVelocity=20.000000,MinInitialVelocity=10.000000,MaxDrawScale=0.200000,MinDrawScale=0.150000,MinScaleGlow=0.750000,GrowPhase=1,MaxGrowRate=-0.500000,MinGrowRate=-0.200000,MaxFadeRate=1.000000,MinFadeRate=0.500000)
     Templates(1)=(LifeSpan=1.500000,Weight=0.250000,MaxInitialVelocity=20.000000,MinInitialVelocity=10.000000,MaxDrawScale=0.100000,MinDrawScale=0.050000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,FadePhase=2,MaxFadeRate=0.500000,MinFadeRate=0.250000)
     Templates(2)=(LifeSpan=5.000000,Weight=0.350000,MaxInitialVelocity=15.000000,MinInitialVelocity=10.000000,MaxDrawScale=0.150000,MinDrawScale=0.050000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,FadePhase=2,MaxFadeRate=0.200000,MinFadeRate=0.100000)
     Particles(0)=Texture'ParticleSystems.Fire.Flame07'
     Particles(1)=Texture'ParticleSystems.Magic.particle_yellw1'
     Particles(2)=Texture'ParticleSystems.Smoke.particle_fog01'
     bOn=True
     bStatic=False
     DrawScale=0.250000
     VisibilityRadius=500.000000
     VisibilityHeight=500.000000
}
