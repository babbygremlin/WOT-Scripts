//------------------------------------------------------------------------------
// Smoke03.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class Smoke03 expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Volume=30.000000
     Gravity=(Z=30.000000)
     NumTemplates=2
     Templates(0)=(LifeSpan=2.000000,MaxInitialVelocity=10.000000,MinInitialVelocity=5.000000,MinDrawScale=0.500000,MaxScaleGlow=0.400000,MinScaleGlow=0.100000,GrowPhase=1,MaxGrowRate=0.700000,MinGrowRate=0.500000,FadePhase=1,MaxFadeRate=-0.200000,MinFadeRate=-0.200000)
     Templates(1)=(LifeSpan=3.000000,MaxInitialVelocity=10.000000,MinInitialVelocity=5.000000,MaxDrawScale=0.200000,MinDrawScale=0.100000,MaxScaleGlow=0.300000,MinScaleGlow=0.100000,GrowPhase=1,MaxGrowRate=0.500000,MinGrowRate=0.400000,FadePhase=1,MaxFadeRate=-0.100000,MinFadeRate=-0.100000)
     Particles(0)=Texture'ParticleSystems.Smoke.particle_fog07'
     Particles(1)=Texture'ParticleSystems.Smoke.particle_fog01'
     bOn=True
     bStatic=False
     VisibilityRadius=800.000000
     VisibilityHeight=800.000000
}
